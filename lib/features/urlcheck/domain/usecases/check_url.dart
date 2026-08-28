import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_facts.dart';
import 'package:simply_internet/features/urlcheck/domain/repositories/url_inspector.dart';
import 'package:simply_internet/l10n/app_localizations.dart';
import 'package:simply_internet/l10n/app_localizations_en.dart';

/// Thrown when the text the user typed cannot be understood as a web address.
class InvalidUrlException implements Exception {
  const InvalidUrlException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// One conclusion: what the headline says, the finding that explains why, and
/// the instructions that follow from it.
typedef Conclusion = ({
  UrlFinding finding,
  String headline,
  List<String> advice,
});

/// Runs every URL probe concurrently and distils the raw facts into an
/// ordered list of plain-language findings plus a single headline verdict.
///
/// Explanation and instruction are kept in separate fields throughout: a
/// finding only ever says what is wrong, and everything the user could do
/// about it ends up in the report's advice list, so the UI can show one "What
/// to do" block instead of hiding actions inside paragraphs of cause.
///
/// Every user-facing string is resolved from an injected [AppLocalizations];
/// [call] falls back to English when none is passed, so the pure
/// fact-to-verdict tests need no localization setup.
class CheckUrl {
  const CheckUrl(this._inspector);

  final UrlInspector _inspector;

  List<String> _certificateAdvice(AppLocalizations l10n) => [
    l10n.urlAdviceCertNoPasswords,
    l10n.urlAdviceCheckClock,
    l10n.urlAdviceCertOwnerFix,
  ];

  List<String> _noSuchAddressAdvice(AppLocalizations l10n) => [
    l10n.urlAdviceCheckSpelling,
    l10n.urlAdviceUnregistered,
  ];

  List<String> _blockedAdvice(AppLocalizations l10n) => [
    l10n.urlAdviceTryMobile,
    l10n.urlAdviceVpn,
  ];

  /// Standard web ports probed when the user did not specify one, so we can
  /// spot a service that is only listening on an alternate port.
  static const List<({int port, String service})> _webPorts = [
    (port: 80, service: 'HTTP'),
    (port: 443, service: 'HTTPS'),
    (port: 8080, service: 'HTTP-alt'),
    (port: 8443, service: 'HTTPS-alt'),
  ];

  /// Checks [rawUrl] and reports on it.
  ///
  /// [medium] is how the link in use is named ('Wi-Fi', 'mobile data', …) and
  /// is recorded in the technical details, the way the diagnosis records the
  /// medium it measured over: a result that differs between Wi-Fi and mobile
  /// data is the whole point of the cross-medium re-check, and comparing two
  /// reports means nothing if neither says which link it came from. Null when
  /// the link could not be read, which the log states rather than guessing.
  Future<UrlCheckReport> call(
    String rawUrl, {
    String? medium,
    AppLocalizations? l10n,
  }) async {
    final loc = l10n ?? AppLocalizationsEn();
    final url = _normalise(rawUrl, loc);
    final host = url.host;
    final isHttps = url.scheme == 'https';
    final hostIsIp = _isIpLiteral(host);
    final registrable = hostIsIp ? null : _registrableDomain(host);

    final fetchF = _inspector.fetch(url);
    final dnsF = hostIsIp
        ? Future<bool>.value(true)
        : _inspector.dnsResolves(host);
    final domainF = registrable == null
        ? Future<DomainInfo>.value(const DomainInfo.unavailable())
        : _inspector
              .domainInfo(registrable)
              .catchError((Object _) => const DomainInfo.unavailable());
    final portsF = url.hasPort
        ? Future<List<UrlPortResult>>.value(const [])
        : _inspector.checkPorts(host, _webPorts.map((p) => p.port).toList());
    final tlsF = isHttps
        ? _inspector.tlsInfo(host, url.hasPort ? url.port : 443)
        : Future<TlsInfo>.value(const TlsInfo.unavailable());
    final regionsF = _inspector
        .checkFromRegions(url)
        .timeout(
          const Duration(seconds: 18),
          onTimeout: () => const RegionReport.unavailable(),
        )
        .catchError((Object _) => const RegionReport.unavailable());
    final outageF = _inspector
        .crossCheckOutage(url)
        .timeout(
          const Duration(seconds: 18),
          onTimeout: () => const OutageReport.unavailable(),
        )
        .catchError((Object _) => const OutageReport.unavailable());

    final (fetch, dnsOk, domain, ports, tls, regions, outage) = await (
      fetchF,
      dnsF,
      domainF,
      portsF,
      tlsF,
      regionsF,
      outageF,
    ).wait;

    // Positive evidence the site genuinely exists, gathered from any source.
    // Used to stop one unreliable signal (e.g. an RDAP 404 for a registry
    // rdap.org does not cover, like .il) from producing a misleading verdict.
    final upElsewhere =
        regions.reachableFromSome ||
        (outage.available && (outage.isUp || outage.up > 0));
    final existsEvidence =
        dnsOk ||
        fetch.reached ||
        upElsewhere ||
        (domain.checked && domain.exists);

    // Exactly one conclusion: every source is reconciled into a single reason
    // with a single set of actions, so the user never has to choose between
    // several contradictory explanations of one failure.
    final conclusion = _conclude(
      loc: loc,
      url: url,
      hostIsIp: hostIsIp,
      dnsOk: dnsOk,
      fetch: fetch,
      tls: tls,
      domain: domain,
      regions: regions,
      outage: outage,
      upElsewhere: upElsewhere,
      existsEvidence: existsEvidence,
    );

    // Only extras that add something the conclusion does not already give.
    final extras = _extras(
      loc: loc,
      url: url,
      fetch: fetch,
      domain: domain,
      ports: ports,
      outage: outage,
    );

    return UrlCheckReport(
      url: url.toString(),
      reachable: fetch.isSuccess,
      headline: conclusion.headline,
      findings: [conclusion.finding, ...extras.findings],
      advice: [...conclusion.advice, ...extras.advice],
      log: _log(
        loc: loc,
        url: url,
        medium: medium,
        registrable: registrable,
        isHttps: isHttps,
        dnsOk: dnsOk,
        fetch: fetch,
        tls: tls,
        domain: domain,
        ports: ports,
        regions: regions,
        outage: outage,
      ),
    );
  }

  // ── Technical details ────────────────────────────────────────────────────

  /// The technical log, grouped under headings and listing every check that
  /// ran — including each vantage point the site was opened from — so the
  /// user can see exactly what was tested rather than a bare count.
  List<String> _log({
    required AppLocalizations loc,
    required Uri url,
    required String? medium,
    required String? registrable,
    required bool isHttps,
    required bool dnsOk,
    required HttpFetchResult fetch,
    required TlsInfo tls,
    required DomainInfo domain,
    required List<UrlPortResult> ports,
    required RegionReport regions,
    required OutageReport outage,
  }) {
    final elapsed = fetch.elapsedMs != null ? '${fetch.elapsedMs} ms' : '-';
    final registration = domain.checked
        ? loc.urlLogRegistrationDetail(
            _yesNo(loc, domain.exists),
            _yesNo(loc, domain.expired, goodWhenTrue: false),
            _date(domain.expiry),
          )
        : loc.urlLogNotChecked;
    final String certificate;
    if (!tls.checked) {
      certificate = loc.urlLogNotChecked;
    } else if (tls.valid) {
      certificate = loc.urlLogCertValid(_date(tls.expiry));
    } else {
      certificate = tls.issue != null
          ? loc.urlLogCertNotTrusted(tls.issue!)
          : loc.urlLogCertNotTrustedNoIssue;
    }
    final outageSummary = loc.urlLogOutageSummary(
      outage.verdict.isEmpty ? '-' : outage.verdict,
      outage.up,
      outage.total,
      outage.likelyBlocked,
    );
    return <String>[
      '## ${loc.urlLogHeadAddress}',
      '- ${loc.urlLogUrl(url.toString())}',
      '- ${loc.urlLogDnsResolves(_yesNo(loc, dnsOk))}',
      if (registrable != null)
        '- ${loc.urlLogRegistration(registrable, registration)}',
      '',
      '## ${loc.urlLogHeadFromDevice}',
      // First, because it qualifies everything under this heading: the same
      // address can be blocked on one medium and fine on the other.
      '- ${loc.urlLogTestedOver(medium ?? loc.urlLogNotKnown)}',
      '- ${loc.urlLogOpenedPage(_yesNo(loc, fetch.reached))}',
      '- ${loc.urlLogStatusCode(fetch.statusCode?.toString() ?? "-")}',
      '- ${loc.urlLogTimeToAnswer(elapsed)}',
      if (fetch.finalUrl != null)
        '- ${loc.urlLogFinalAddress(fetch.finalUrl!)}',
      if (fetch.error != null) '- ${loc.urlLogError(fetch.error!)}',
      if (isHttps) '- ${loc.urlLogCertificate(certificate)}',
      if (ports.isNotEmpty) ...[
        '',
        '## ${loc.urlLogHeadPorts}',
        for (final p in ports) _portLogLine(loc, p),
      ],
      '',
      '## ${loc.urlLogHeadFromCountries}',
      if (!regions.available)
        '- ${loc.urlLogNotAvailableForCheck}'
      else ...[
        '- ${loc.urlLogReachedFromLocations(regions.reachable, regions.total)}',
        for (final probe in regions.probes) _probeLine(loc, probe),
      ],
      '',
      '## ${loc.urlLogHeadOutageCheck(outage.source)}',
      if (!outage.available)
        '- ${loc.urlLogNotAvailableForCheck}'
      else ...[
        '- $outageSummary',
        for (final probe in outage.probes) _probeLine(loc, probe),
        if (outage.alternateHost != null) _alternateLine(loc, outage),
      ],
    ];
  }

  static String _portLogLine(AppLocalizations loc, UrlPortResult p) {
    final state = p.open ? loc.urlLogPortOpen : loc.urlLogPortClosed;
    return '- ${loc.urlLogPortLine(p.port, p.service, state)}';
  }

  static String _probeLine(AppLocalizations loc, RegionProbe probe) {
    final status = probe.statusCode != null
        ? loc.urlLogProbeStatusSuffix(probe.statusCode!)
        : '';
    final state = probe.reachable
        ? loc.urlLogProbeReached
        : loc.urlLogProbeFailed;
    return '  - ${loc.urlLogProbeLine(probe.location, state, status)}';
  }

  static String _alternateLine(AppLocalizations loc, OutageReport outage) {
    final state = outage.alternateHostUp
        ? loc.urlLogProbeReached
        : loc.urlLogProbeFailed;
    return '- ${loc.urlLogAlternate(outage.alternateHost!, state)}';
  }

  /// A yes/no answer with the mark on the *healthy* outcome rather than the
  /// affirmative one: a registration that has expired is bad news, so it reads
  /// "yes ❌" and a live one reads "no ✅".
  static String _yesNo(
    AppLocalizations loc,
    bool value, {
    bool goodWhenTrue = true,
  }) =>
      '${value ? loc.logYes : loc.logNo} '
      '${value == goodWhenTrue ? "✅" : "❌"}';

  static String _date(DateTime? value) =>
      value == null ? '-' : value.toIso8601String().split('T').first;

  // ── URL parsing ────────────────────────────────────────────────────────

  Uri _normalise(String raw, AppLocalizations loc) {
    var text = raw.trim();
    if (text.isEmpty) {
      throw InvalidUrlException(loc.urlErrorEmpty);
    }
    if (!text.contains('://')) text = 'https://$text';
    final uri = Uri.tryParse(text);
    if (uri == null || uri.host.isEmpty) {
      throw InvalidUrlException(loc.urlErrorInvalid);
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw InvalidUrlException(loc.urlErrorScheme);
    }
    return uri;
  }

  bool _isIpLiteral(String host) {
    if (host.contains(':')) return true; // IPv6 literal
    final parts = host.split('.');
    if (parts.length != 4) return false;
    return parts.every((p) {
      final n = int.tryParse(p);
      return n != null && n >= 0 && n <= 255;
    });
  }

  /// Common two-label public suffixes, so a host like `meuhedet.co.il` yields
  /// the registrable `meuhedet.co.il` and not the bare suffix `co.il`.
  static const Set<String> _multiLabelSuffixes = {
    'co.uk',
    'org.uk',
    'me.uk',
    'gov.uk',
    'ac.uk',
    'ltd.uk',
    'plc.uk',
    'co.il',
    'org.il',
    'net.il',
    'ac.il',
    'gov.il',
    'muni.il',
    'k12.il',
    'co.jp',
    'ne.jp',
    'or.jp',
    'go.jp',
    'ac.jp',
    'com.au',
    'net.au',
    'org.au',
    'edu.au',
    'gov.au',
    'com.br',
    'com.cn',
    'com.mx',
    'com.tr',
    'com.sg',
    'com.hk',
    'com.tw',
    'com.ua',
    'com.ar',
    'com.pl',
    'com.ph',
    'com.my',
    'com.vn',
    'com.eg',
    'co.nz',
    'co.za',
    'co.in',
    'co.kr',
    'co.id',
    'co.th',
  };

  String _registrableDomain(String host) {
    final labels = host.split('.').where((l) => l.isNotEmpty).toList();
    if (labels.length <= 2) return host;
    final lastTwo = labels.sublist(labels.length - 2).join('.');
    if (labels.length >= 3 && _multiLabelSuffixes.contains(lastTwo)) {
      return labels.sublist(labels.length - 3).join('.');
    }
    return lastTwo;
  }

  // ── Single conclusion ────────────────────────────────────────────────────

  /// Reconciles every probe into one reason plus the matching headline.
  ///
  /// The branches are mutually exclusive and ordered by how conclusive the
  /// evidence is, so a single failure can never produce two explanations: a
  /// name that resolves nowhere is a wrong address, a name that resolves but
  /// answers nobody is an outage, and a name that answers others but not us
  /// is a block on our side.
  Conclusion _conclude({
    required AppLocalizations loc,
    required Uri url,
    required bool hostIsIp,
    required bool dnsOk,
    required HttpFetchResult fetch,
    required TlsInfo tls,
    required DomainInfo domain,
    required RegionReport regions,
    required OutageReport outage,
    required bool upElsewhere,
    required bool existsEvidence,
  }) {
    // An untrusted certificate outranks everything else: it explains a
    // refused connection, and even on a page that did load it is the one
    // thing the user must know before typing a password.
    if (tls.checked && !tls.valid) {
      final issueSuffix = tls.issue != null
          ? loc.urlCertIssueSuffix(tls.issue!)
          : '';
      final consequence = fetch.isSuccess
          ? loc.urlCertConsequenceLoaded
          : loc.urlCertConsequenceRefused;
      return (
        finding: UrlFinding(
          severity: fetch.isSuccess ? UrlSeverity.warning : UrlSeverity.problem,
          title: loc.urlFindingCertTitle,
          detail: loc.urlFindingCertDetail(issueSuffix, consequence),
        ),
        headline: loc.urlHeadlineCertNotTrusted,
        advice: _certificateAdvice(loc),
      );
    }
    if (fetch.isSuccess) {
      return _workingConclusion(loc, fetch, regions, outage);
    }
    // The server itself answered: its status code is the reason, and no
    // outside opinion may contradict a reply we hold in our hands.
    if (fetch.reached && fetch.statusCode != null) {
      final status = _httpStatus(
        loc,
        fetch.statusCode!,
        fetch.retryAfterSeconds,
      );
      return (
        finding: status.finding,
        headline: loc.urlHeadlineAnswered(fetch.statusCode!),
        advice: status.advice,
      );
    }
    if (upElsewhere) return _blockedConclusion(loc, regions, outage);
    if (!hostIsIp && !dnsOk && !existsEvidence) {
      final registry = domain.checked && !domain.exists
          ? loc.urlRegistryNoRecord
          : '';
      return (
        finding: UrlFinding(
          severity: UrlSeverity.problem,
          title: loc.urlFindingNotFoundTitle,
          detail: loc.urlFindingNotFoundDetail(registry),
        ),
        headline: loc.urlHeadlineNotFound,
        advice: _noSuchAddressAdvice(loc),
      );
    }
    if (domain.expired) {
      return (
        finding: UrlFinding(
          severity: UrlSeverity.problem,
          title: loc.urlFindingExpiredTitle,
          detail: loc.urlFindingExpiredDetail(
            _expirySuffix(loc, domain.expiry),
          ),
        ),
        headline: loc.urlHeadlineExpired,
        advice: [loc.urlAdviceOwnerRenew],
      );
    }
    if (regions.downEverywhere || outage.downEverywhere) {
      final parts = <String>[
        if (regions.downEverywhere)
          loc.urlSourceTestLocations(regions.total),
        if (outage.downEverywhere)
          loc.urlSourceOutageRegions(outage.total, outage.source),
      ];
      final sources = parts.length == 2
          ? loc.urlSourceJoin(parts[0], parts[1])
          : parts.join();
      return (
        finding: UrlFinding(
          severity: UrlSeverity.problem,
          detail: loc.urlFindingDownEverywhereDetail(sources),
        ),
        headline: loc.urlHeadlineDownForEveryone,
        advice: [loc.urlAdviceWaitNothingToFix],
      );
    }
    final err = fetch.error != null
        ? loc.urlErrorParenthetical(fetch.error!)
        : '';
    return (
      finding: UrlFinding(
        severity: UrlSeverity.problem,
        detail: loc.urlFindingNotRespondingDetail(err),
      ),
      headline: loc.urlHeadlineNotResponding,
      advice: [loc.urlAdviceTryAgainMinutes, loc.urlAdviceTryMobileRuleOut],
    );
  }

  /// The site loaded for the user. Regional restrictions are reported as the
  /// single finding when present — a warning replaces the reassurance instead
  /// of sitting beside it, so a mixed result reads as one message.
  Conclusion _workingConclusion(
    AppLocalizations loc,
    HttpFetchResult fetch,
    RegionReport regions,
    OutageReport outage,
  ) {
    final code = fetch.statusCode!;
    final blockedCountries = regions.blockedCountries;
    final restricted = blockedCountries.isNotEmpty || outage.likelyBlocked > 0;
    if (restricted) {
      final where = blockedCountries.isNotEmpty
          ? loc.urlBlockedFromCountries(blockedCountries.join(', '))
          : loc.urlBlockedByOutage(
              outage.source,
              outage.likelyBlocked,
              outage.total,
            );
      return (
        finding: UrlFinding(
          severity: UrlSeverity.warning,
          title: loc.urlFindingWorksBlockedTitle,
          detail: loc.urlFindingWorksBlockedDetail(code, where),
        ),
        headline: loc.urlHeadlineWorksForYou,
        advice: const [],
      );
    }
    final elsewhere = outage.available && outage.up > 0
        ? loc.urlWorksAlsoOutage(outage.source, outage.up, outage.total)
        : regions.available && regions.reachableFromSome
        ? loc.urlWorksAlsoRegions(regions.reachable, regions.total)
        : '';
    return (
      finding: UrlFinding(
        severity: UrlSeverity.ok,
        detail: loc.urlFindingWorksDetail(code, elsewhere),
      ),
      headline: loc.urlHeadlineWorks,
      advice: const [],
    );
  }

  /// The site is proven up elsewhere but not for us: one message covers both
  /// readings of "you" — this device/network, and this country.
  Conclusion _blockedConclusion(
    AppLocalizations loc,
    RegionReport regions,
    OutageReport outage,
  ) {
    final parts = <String>[
      if (regions.available && regions.reachableFromSome)
        loc.urlEvidenceRegions(regions.reachable, regions.total),
      if (outage.available && outage.up > 0)
        loc.urlEvidenceOutage(outage.source, outage.up, outage.total),
    ];
    final evidence = parts.length == 2
        ? loc.urlEvidenceJoin(parts[0], parts[1])
        : parts.join();
    final blocked = regions.blockedCountries.isNotEmpty
        ? loc.urlAlsoFailedCountries(regions.blockedCountries.join(', '))
        : '';
    return (
      finding: UrlFinding(
        severity: UrlSeverity.warning,
        title: loc.urlFindingBlockedTitle,
        detail: loc.urlFindingBlockedDetail(evidence, blocked),
      ),
      headline: loc.urlHeadlineBlockedForYou,
      advice: _blockedAdvice(loc),
    );
  }

  /// Extra facts the conclusion does not cover: a slow but working site, an
  /// alternate address that does work, a service listening on an unusual port,
  /// and a registration about to lapse. Each one contributes an explanation, an
  /// instruction, or both — never a mixture of the two in one sentence.
  ({List<UrlFinding> findings, List<String> advice}) _extras({
    required AppLocalizations loc,
    required Uri url,
    required HttpFetchResult fetch,
    required DomainInfo domain,
    required List<UrlPortResult> ports,
    required OutageReport outage,
  }) {
    final findings = <UrlFinding>[];
    final advice = <String>[];
    final ms = fetch.elapsedMs;
    if (fetch.isSuccess && ms != null && ms > 8000) {
      findings.add(
        UrlFinding(
          severity: UrlSeverity.warning,
          title: loc.urlFindingSlowTitle,
          detail: loc.urlFindingSlowDetail((ms / 1000).toStringAsFixed(1)),
        ),
      );
      advice.add(loc.urlAdviceSlow);
    }
    if (!fetch.isSuccess) {
      final alt = outage.alternateHost;
      if (alt != null && outage.alternateHostUp) {
        findings.add(
          UrlFinding(
            severity: UrlSeverity.info,
            title: loc.urlFindingAltTitle,
            detail: loc.urlFindingAltDetail(alt),
          ),
        );
        advice.add(loc.urlAdviceOpenAlt(alt));
      }
      final port = _portHint(loc, url, ports);
      if (port != null) {
        findings.add(port.finding);
        advice.add(port.advice);
      }
    }
    if (fetch.isSuccess) findings.addAll(_expiryHint(loc, domain));
    return (findings: findings, advice: advice);
  }

  /// Suggests the alternate web port when the usual one is closed but the
  /// alternate is open — the only case where a port number helps the user.
  ({UrlFinding finding, String advice})? _portHint(
    AppLocalizations loc,
    Uri url,
    List<UrlPortResult> ports,
  ) {
    if (ports.isEmpty) return null;
    final isHttps = url.scheme == 'https';
    final mainPort = isHttps ? 443 : 80;
    final altPort = isHttps ? 8443 : 8080;
    final main = _portResult(ports, mainPort);
    final alt = _portResult(ports, altPort);
    if (main == null || main.open || alt == null || !alt.open) {
      return null;
    }
    return (
      finding: UrlFinding(
        severity: UrlSeverity.info,
        title: loc.urlFindingPortTitle,
        detail: loc.urlFindingPortDetail(mainPort, altPort),
      ),
      advice: loc.urlAdviceTryPort(
        '${url.scheme}://${url.host}:$altPort',
      ),
    );
  }

  /// Warns the owner-side risk of a registration lapsing within a month.
  List<UrlFinding> _expiryHint(AppLocalizations loc, DomainInfo domain) {
    final expiry = domain.expiry;
    if (!domain.checked || expiry == null || domain.expired) return const [];
    final days = expiry.difference(DateTime.now()).inDays;
    if (days < 0 || days > 30) return const [];
    return [
      UrlFinding(
        severity: UrlSeverity.info,
        title: loc.urlFindingExpiresSoonTitle,
        detail: loc.urlFindingExpiresSoonDetail(days),
      ),
    ];
  }

  /// What a status code means (the finding) and what to do about it (the
  /// advice), kept apart so the instruction is never buried in the
  /// explanation.
  ({UrlFinding finding, List<String> advice}) _httpStatus(
    AppLocalizations loc,
    int code,
    int? retryAfterSeconds,
  ) {
    switch (code) {
      case 401:
        return (
          finding: UrlFinding(
            severity: UrlSeverity.warning,
            title: loc.urlStatus401Title,
            detail: loc.urlStatus401Detail,
          ),
          advice: [loc.urlAdvice401],
        );
      case 403:
        return (
          finding: UrlFinding(
            severity: UrlSeverity.problem,
            title: loc.urlStatus403Title,
            detail: loc.urlStatus403Detail,
          ),
          advice: [loc.urlAdviceTryMobile, loc.urlAdviceVpn],
        );
      case 404:
        return (
          finding: UrlFinding(
            severity: UrlSeverity.warning,
            title: loc.urlStatus404Title,
            detail: loc.urlStatus404Detail,
          ),
          advice: [loc.urlAdvice404Typo, loc.urlAdvice404Home],
        );
      case 408:
        return (
          finding: UrlFinding(
            severity: UrlSeverity.warning,
            title: loc.urlStatus408Title,
            detail: loc.urlStatus408Detail,
          ),
          advice: [loc.urlAdvice408],
        );
      case 429:
        // The server usually says how long to wait; quoting its own number
        // beats a made-up "a minute".
        final wait = retryAfterSeconds == null
            ? loc.urlWaitGeneric
            : loc.urlWaitQuoted(_waitText(loc, retryAfterSeconds));
        return (
          finding: UrlFinding(
            severity: UrlSeverity.warning,
            title: loc.urlStatus429Title,
            detail: loc.urlStatus429Detail,
          ),
          advice: [wait, loc.urlAdvice429NoRefresh],
        );
      case 451:
        return (
          finding: UrlFinding(
            severity: UrlSeverity.warning,
            title: loc.urlStatus451Title,
            detail: loc.urlStatus451Detail,
          ),
          advice: [loc.urlAdvice451],
        );
      case 500:
      case 502:
      case 503:
      case 504:
        final wait = retryAfterSeconds == null
            ? loc.urlWaitGeneric
            : loc.urlWaitQuoted(_waitText(loc, retryAfterSeconds));
        return (
          finding: UrlFinding(
            severity: UrlSeverity.problem,
            title: loc.urlStatus5xxTitle,
            detail: loc.urlStatus5xxDetail(code),
          ),
          advice: [wait],
        );
      default:
        return (
          finding: UrlFinding(
            severity: UrlSeverity.info,
            title: loc.urlStatusDefaultTitle,
            detail: loc.urlStatusDefaultDetail(code),
          ),
          advice: [loc.urlAdviceDefaultStatus],
        );
    }
  }

  /// "45 seconds", "3 minutes", "2 hours" — the server's own wait, in words a
  /// person can act on.
  static String _waitText(AppLocalizations loc, int seconds) {
    if (seconds < 90) return loc.urlWaitSeconds(seconds);
    final minutes = (seconds / 60).round();
    if (minutes < 90) return loc.urlWaitMinutes(minutes);
    return loc.urlWaitHours((minutes / 60).round());
  }

  UrlPortResult? _portResult(List<UrlPortResult> ports, int port) {
    for (final p in ports) {
      if (p.port == port) return p;
    }
    return null;
  }

  String _expirySuffix(AppLocalizations loc, DateTime? expiry) {
    if (expiry == null) return '';
    return loc.urlExpirySuffix(_date(expiry));
  }
}
