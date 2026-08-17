import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_facts.dart';
import 'package:simply_internet/features/urlcheck/domain/repositories/url_inspector.dart';

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
class CheckUrl {
  const CheckUrl(this._inspector);

  final UrlInspector _inspector;

  /// Instruction sets held as constants because the lint rules forbid
  /// wrapped strings inside a list literal, and every one of these is longer
  /// than a single line.
  static const List<String> _certificateAdvice = [
    'Do not enter passwords or card details on this site.',
    _clockAdvice,
    'If the clock is right, only the site owner can fix it.',
  ];
  static const String _clockAdvice =
      'Check that your phone date and time are correct — a wrong clock makes '
      'good certificates look broken.';
  static const List<String> _noSuchAddressAdvice = [
    'Check the spelling of the address.',
    _unregisteredAdvice,
  ];
  static const String _unregisteredAdvice =
      'If it is spelled correctly, the name is no longer registered — there '
      'is nothing to fix on your side.';
  static const List<String> _expiredAdvice = [_ownerRenewAdvice];
  static const String _ownerRenewAdvice =
      'Nothing on your side can fix this — only the site owner can renew the '
      'name.';
  static const List<String> _blockedAdvice = [_tryMobileAdvice, _vpnAdvice];
  static const List<String> _refusedAdvice = [_tryMobileAdvice, _vpnAdvice];
  static const String _tryMobileAdvice =
      'Try the same address over mobile data: that skips your Wi-Fi network '
      'and its filters.';
  static const String _vpnAdvice =
      'If it still fails, only a VPN set to another country gets around it.';

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
  Future<UrlCheckReport> call(String rawUrl, {String? medium}) async {
    final url = _normalise(rawUrl);
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
        ? 'exists ${_yesNo(domain.exists)}, '
              'expired ${_yesNo(domain.expired, goodWhenTrue: false)}, '
              'expiry ${_date(domain.expiry)}'
        : 'not checked';
    final String certificate;
    if (!tls.checked) {
      certificate = 'not checked';
    } else if (tls.valid) {
      certificate = 'valid, expires ${_date(tls.expiry)}';
    } else {
      certificate = 'not trusted${tls.issue != null ? " (${tls.issue})" : ""}';
    }
    final outageSummary =
        'verdict ${outage.verdict.isEmpty ? "-" : outage.verdict}, '
        'reached from ${outage.up} of ${outage.total} regions, '
        'likely blocked in ${outage.likelyBlocked}';
    return <String>[
      '## Address',
      '- URL: $url',
      '- Name resolves (DNS): ${_yesNo(dnsOk)}',
      if (registrable != null) '- Registration ($registrable): $registration',
      '',
      '## From this device',
      // First, because it qualifies everything under this heading: the same
      // address can be blocked on one medium and fine on the other.
      '- Tested over: ${medium ?? "not known"}',
      '- Opened the page: ${_yesNo(fetch.reached)}',
      '- Status code: ${fetch.statusCode ?? "-"}',
      '- Time to answer: $elapsed',
      if (fetch.finalUrl != null) '- Final address: ${fetch.finalUrl}',
      if (fetch.error != null) '- Error: ${fetch.error}',
      if (isHttps) '- Certificate: $certificate',
      if (ports.isNotEmpty) ...[
        '',
        '## Ports',
        for (final p in ports)
          '- ${p.port} (${p.service}): ${p.open ? "open ✅" : "closed ❌"}',
      ],
      '',
      '## From other countries (check-host.net)',
      if (!regions.available)
        '- Not available for this check'
      else ...[
        '- Reached from ${regions.reachable} of ${regions.total} locations',
        for (final probe in regions.probes) _probeLine(probe),
      ],
      '',
      '## Independent outage check (${outage.source})',
      if (!outage.available)
        '- Not available for this check'
      else ...[
        '- Summary: $outageSummary',
        for (final probe in outage.probes) _probeLine(probe),
        if (outage.alternateHost != null) _alternateLine(outage),
      ],
    ];
  }

  static String _probeLine(RegionProbe probe) {
    final status = probe.statusCode != null ? ' (${probe.statusCode})' : '';
    return '  - ${probe.location}: '
        '${probe.reachable ? "reached ✅" : "failed ❌"}$status';
  }

  static String _alternateLine(OutageReport outage) =>
      '- Alternate address ${outage.alternateHost}: '
      '${outage.alternateHostUp ? "reached ✅" : "failed ❌"}';

  /// A yes/no answer with the mark on the *healthy* outcome rather than the
  /// affirmative one: a registration that has expired is bad news, so it reads
  /// "yes ❌" and a live one reads "no ✅".
  static String _yesNo(bool value, {bool goodWhenTrue = true}) =>
      '${value ? "yes" : "no"} ${value == goodWhenTrue ? "✅" : "❌"}';

  static String _date(DateTime? value) =>
      value == null ? '-' : value.toIso8601String().split('T').first;

  // ── URL parsing ────────────────────────────────────────────────────────

  Uri _normalise(String raw) {
    var text = raw.trim();
    if (text.isEmpty) {
      throw const InvalidUrlException('Please paste a website address first.');
    }
    if (!text.contains('://')) text = 'https://$text';
    final uri = Uri.tryParse(text);
    if (uri == null || uri.host.isEmpty) {
      throw const InvalidUrlException(
        'That does not look like a valid web address.',
      );
    }
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      throw const InvalidUrlException(
        'Only http and https addresses can be checked.',
      );
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
      final consequence = fetch.isSuccess
          ? 'The page still loaded, but nothing you send to it is safe.'
          : 'The connection was refused because of it.';
      return (
        finding: UrlFinding(
          severity: fetch.isSuccess ? UrlSeverity.warning : UrlSeverity.problem,
          title: 'Security certificate problem.',
          detail:
              'The site HTTPS certificate could not be trusted'
              '${tls.issue != null ? " (${tls.issue})" : ""}. $consequence',
        ),
        headline: 'The site security certificate is not trusted',
        advice: _certificateAdvice,
      );
    }
    if (fetch.isSuccess) return _workingConclusion(fetch, regions, outage);
    // The server itself answered: its status code is the reason, and no
    // outside opinion may contradict a reply we hold in our hands.
    if (fetch.reached && fetch.statusCode != null) {
      final status = _httpStatus(fetch.statusCode!, fetch.retryAfterSeconds);
      return (
        finding: status.finding,
        headline: 'The website answered with a problem (${fetch.statusCode}).',
        advice: status.advice,
      );
    }
    if (upElsewhere) return _blockedConclusion(regions, outage);
    if (!hostIsIp && !dnsOk && !existsEvidence) {
      final registry = domain.checked && !domain.exists
          ? ' The domain registry has no registration for it either.'
          : '';
      return (
        finding: UrlFinding(
          severity: UrlSeverity.problem,
          title: "The address doesn't exist",
          detail:
              'The website name could not be found anywhere on the Internet.'
              '$registry',
        ),
        headline: "This web address can't be found.",
        advice: _noSuchAddressAdvice,
      );
    }
    if (domain.expired) {
      return (
        finding: UrlFinding(
          severity: UrlSeverity.problem,
          title: 'Domain registration has expired.',
          detail:
              'The owner let the domain lapse'
              '${_expirySuffix(domain.expiry)}. Until they renew it, the '
              'site will not work for anyone.',
        ),
        headline: 'The site domain has expired',
        advice: _expiredAdvice,
      );
    }
    if (regions.downEverywhere || outage.downEverywhere) {
      final byRegions = '${regions.total} test locations';
      final byOutage = '${outage.total} regions of ${outage.source}';
      final sources = <String>[
        if (regions.downEverywhere) byRegions,
        if (outage.downEverywhere) byOutage,
      ].join(' and ');
      return (
        finding: UrlFinding(
          severity: UrlSeverity.problem,
          detail:
              'It could not be opened from $sources either, so the site is '
              'down for everyone — not just you.',
        ),
        headline: 'The website is down for everyone',
        advice: const [
          'Wait and try again later — there is nothing to fix on your side.',
        ],
      );
    }
    return (
      finding: UrlFinding(
        severity: UrlSeverity.problem,
        detail:
            'The address exists, but no reply came back from the server'
            '${fetch.error != null ? " (${fetch.error})" : ""}. It is either '
            'switched off or unreachable right now.',
      ),
      headline: 'The website is not responding',
      advice: const [
        'Try again in a few minutes.',
        'Try the same address over mobile data to rule out your network.',
      ],
    );
  }

  /// The site loaded for the user. Regional restrictions are reported as the
  /// single finding when present — a warning replaces the reassurance instead
  /// of sitting beside it, so a mixed result reads as one message.
  Conclusion _workingConclusion(
    HttpFetchResult fetch,
    RegionReport regions,
    OutageReport outage,
  ) {
    final blockedCountries = regions.blockedCountries;
    final restricted = blockedCountries.isNotEmpty || outage.likelyBlocked > 0;
    if (restricted) {
      final where = blockedCountries.isNotEmpty
          ? ' It was refused from ${blockedCountries.join(", ")}.'
          : ' An independent check (${outage.source}) found it blocked in '
                '${outage.likelyBlocked} of its ${outage.total} regions.';
      return (
        finding: UrlFinding(
          severity: UrlSeverity.warning,
          title: 'Works for you, but blocked in some countries.',
          detail:
              'The page opened normally on your device (code '
              '${fetch.statusCode}), so nothing is wrong with your '
              'connection.$where If someone abroad cannot open it, that is '
              'the site geo-fencing them, not a fault either of you can '
              'fix.',
        ),
        headline: 'The website works for you',
        advice: const [],
      );
    }
    final elsewhere = outage.available && outage.up > 0
        ? ' An independent check (${outage.source}) also reached it from '
              '${outage.up} of ${outage.total} regions.'
        : regions.available && regions.reachableFromSome
        ? ' It also loads from ${regions.reachable} of ${regions.total} other '
              'countries.'
        : '';
    return (
      finding: UrlFinding(
        severity: UrlSeverity.ok,
        detail:
            'The page answered normally (code ${fetch.statusCode}) from your '
            'device.$elsewhere',
      ),
      headline: 'The website works',
      advice: const [],
    );
  }

  /// The site is proven up elsewhere but not for us: one message covers both
  /// readings of "you" — this device/network, and this country.
  Conclusion _blockedConclusion(RegionReport regions, OutageReport outage) {
    final byRegions =
        'it loads from ${regions.reachable} of ${regions.total} other '
        'countries';
    final byOutage =
        'an independent check (${outage.source}) reached it from '
        '${outage.up} of ${outage.total} regions';
    final evidence = <String>[
      if (regions.available && regions.reachableFromSome) byRegions,
      if (outage.available && outage.up > 0) byOutage,
    ].join(', and ');
    final blocked = regions.blockedCountries.isNotEmpty
        ? ' Countries where it also failed: '
              '${regions.blockedCountries.join(", ")}.'
        : '';
    return (
      finding: UrlFinding(
        severity: UrlSeverity.warning,
        title: 'Blocked on your connection or in your country.',
        detail:
            'The site is up — $evidence — but nothing came back on your '
            'connection.$blocked Either the site refuses visitors from your '
            'country, or your network blocks it.',
      ),
      headline: 'The website seems blocked for you',
      advice: _blockedAdvice,
    );
  }

  /// Extra facts the conclusion does not cover: a slow but working site, an
  /// alternate address that does work, a service listening on an unusual port,
  /// and a registration about to lapse. Each one contributes an explanation, an
  /// instruction, or both — never a mixture of the two in one sentence.
  ({List<UrlFinding> findings, List<String> advice}) _extras({
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
          title: 'The website is very slow.',
          detail:
              'It took ${(ms / 1000).toStringAsFixed(1)} seconds to respond. '
              'The site or your connection may be congested.',
        ),
      );
      advice.add('Try again later, or over a different network.');
    }
    if (!fetch.isSuccess) {
      final alt = outage.alternateHost;
      if (alt != null && outage.alternateHostUp) {
        findings.add(
          UrlFinding(
            severity: UrlSeverity.info,
            title: 'A similar address does work.',
            detail:
                'The exact address did not work, but "$alt" did. You may '
                'have left off (or added) a "www.".',
          ),
        );
        advice.add('Open $alt instead.');
      }
      final port = _portHint(url, ports);
      if (port != null) {
        findings.add(port.finding);
        advice.add(port.advice);
      }
    }
    if (fetch.isSuccess) findings.addAll(_expiryHint(domain));
    return (findings: findings, advice: advice);
  }

  /// Suggests the alternate web port when the usual one is closed but the
  /// alternate is open — the only case where a port number helps the user.
  ({UrlFinding finding, String advice})? _portHint(
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
        title: 'The service may be on an unusual port.',
        detail:
            'The usual port $mainPort is closed, but port $altPort is open.',
      ),
      advice:
          'Try the address with the port added: '
          '${url.scheme}://${url.host}:$altPort',
    );
  }

  /// Warns the owner-side risk of a registration lapsing within a month.
  List<UrlFinding> _expiryHint(DomainInfo domain) {
    final expiry = domain.expiry;
    if (!domain.checked || expiry == null || domain.expired) return const [];
    final days = expiry.difference(DateTime.now()).inDays;
    if (days < 0 || days > 30) return const [];
    return [
      UrlFinding(
        severity: UrlSeverity.info,
        title: 'Domain expires soon.',
        detail:
            'The domain registration expires in $days day(s). That is the '
            'site owner concern, not a fault on your side.',
      ),
    ];
  }

  /// What a status code means (the finding) and what to do about it (the
  /// advice), kept apart so the instruction is never buried in the
  /// explanation.
  ({UrlFinding finding, List<String> advice}) _httpStatus(
    int code,
    int? retryAfterSeconds,
  ) {
    switch (code) {
      case 401:
        return (
          finding: const UrlFinding(
            severity: UrlSeverity.warning,
            title: 'The site works but needs you to log in first.',
            detail: 'Sign-in required (401).',
          ),
          advice: const ['Open it in a browser and sign in with your account.'],
        );
      case 403:
        return (
          finding: const UrlFinding(
            severity: UrlSeverity.problem,
            title: 'The server refused the request',
            detail:
                'Access denied (403). This is often geo-fencing, a '
                'network/firewall block, or a block on automated access.',
          ),
          advice: _refusedAdvice,
        );
      case 404:
        return (
          finding: const UrlFinding(
            severity: UrlSeverity.warning,
            title: 'Page not found (404).',
            detail: 'The server is up but this exact page does not exist.',
          ),
          advice: const [
            'Check the address for a typo.',
            'Open the site home page and navigate from there.',
          ],
        );
      case 408:
        return (
          finding: const UrlFinding(
            severity: UrlSeverity.warning,
            title: 'Request timed out (408).',
            detail: 'The server was too slow to accept the request.',
          ),
          advice: const [
            'Try again; if it keeps timing out the site is overloaded.',
          ],
        );
      case 429:
        // The server usually says how long to wait; quoting its own number
        // beats a made-up "a minute".
        final wait = retryAfterSeconds == null
            ? 'Wait a minute and try again.'
            : 'Wait ${_waitText(retryAfterSeconds)} — that is how long the '
                  'site asked — and try again.';
        return (
          finding: const UrlFinding(
            severity: UrlSeverity.warning,
            title: 'The site is refusing this many requests from you.',
            detail: 'Too many requests (429).',
          ),
          advice: [wait, 'Avoid refreshing repeatedly in the meantime.'],
        );
      case 451:
        return (
          finding: const UrlFinding(
            severity: UrlSeverity.warning,
            title: 'The site is legally barred from serving your region.',
            detail:
                'Blocked for legal reasons (451). The site is not broken and '
                'nothing on your side is wrong.',
          ),
          advice: const [
            'A VPN set to another country is the only way around it.',
          ],
        );
      case 500:
      case 502:
      case 503:
      case 504:
        final wait = retryAfterSeconds == null
            ? 'Wait a few minutes and try again.'
            : 'Wait ${_waitText(retryAfterSeconds)} — that is how long the '
                  'site asked — and try again.';
        return (
          finding: UrlFinding(
            severity: UrlSeverity.problem,
            title: 'The problem is on the website end, not yours.',
            detail:
                'The website has a server error ($code). It may be down or '
                'under maintenance.',
          ),
          advice: [wait],
        );
      default:
        return (
          finding: UrlFinding(
            severity: UrlSeverity.info,
            title: 'The site answered with an unusual code.',
            detail: 'Unexpected response ($code).',
          ),
          advice: const ['Try opening it in a normal browser — it may work.'],
        );
    }
  }

  /// "45 seconds", "3 minutes", "2 hours" — the server's own wait, in words a
  /// person can act on.
  static String _waitText(int seconds) {
    if (seconds < 90) return '$seconds seconds';
    final minutes = (seconds / 60).round();
    if (minutes < 90) return '$minutes minutes';
    return '${(minutes / 60).round()} hours';
  }

  UrlPortResult? _portResult(List<UrlPortResult> ports, int port) {
    for (final p in ports) {
      if (p.port == port) return p;
    }
    return null;
  }

  String _expirySuffix(DateTime? expiry) {
    if (expiry == null) return '';
    final d = expiry.toIso8601String().split('T').first;
    return ' (expired on $d)';
  }
}
