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

/// Runs every URL probe concurrently and distils the raw facts into an
/// ordered list of plain-language findings plus a single headline verdict.
class CheckUrl {
  const CheckUrl(this._inspector);

  final UrlInspector _inspector;

  /// Standard web ports probed when the user did not specify one, so we can
  /// spot a service that is only listening on an alternate port.
  static const List<({int port, String service})> _webPorts = [
    (port: 80, service: 'HTTP'),
    (port: 443, service: 'HTTPS'),
    (port: 8080, service: 'HTTP-alt'),
    (port: 8443, service: 'HTTPS-alt'),
  ];

  Future<UrlCheckReport> call(String rawUrl) async {
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

    final elapsed = fetch.elapsedMs != null ? '${fetch.elapsedMs}ms' : '';
    final httpLine =
        'HTTP: reached=${fetch.reached} status=${fetch.statusCode ?? "-"} '
        'final=${fetch.finalUrl ?? "-"} $elapsed';
    final tlsLine =
        'TLS: checked=${tls.checked} valid=${tls.valid} '
        'expiry=${tls.expiry ?? "-"} ${tls.issue ?? ""}';
    final domainLine =
        'Domain($registrable): checked=${domain.checked} '
        'exists=${domain.exists} expired=${domain.expired} '
        'expiry=${domain.expiry ?? "-"}';
    final regionLine =
        'Regions: available=${regions.available} '
        '${regions.reachable}/${regions.total} reachable, '
        'blocked=${regions.blockedCountries.join(",")}';
    final outageLine =
        'Outage x-check (${outage.source}): available=${outage.available} '
        'verdict=${outage.verdict.isEmpty ? "-" : outage.verdict} '
        '${outage.up}/${outage.total} up, blocked=${outage.likelyBlocked}';
    final log = <String>[
      'URL: $url',
      'DNS resolves: $dnsOk',
      httpLine,
      if (fetch.error != null) 'HTTP error: ${fetch.error}',
      if (isHttps) tlsLine,
      if (registrable != null) domainLine,
      for (final p in ports)
        'Port ${p.port}/${p.service}: ${p.open ? "open" : "closed"}',
      regionLine,
      outageLine,
    ];

    final findings = <UrlFinding>[];

    _addDnsAndDomain(findings, host, hostIsIp, dnsOk, domain);
    _addHttp(findings, fetch);
    if (isHttps) _addTls(findings, tls);
    _addPorts(findings, url, ports);
    _addRegions(findings, fetch, regions);
    _addOutageCrossCheck(findings, fetch, outage);

    findings.sort((a, b) => b.severity.index.compareTo(a.severity.index));

    return UrlCheckReport(
      url: url.toString(),
      reachable: fetch.isSuccess,
      headline: _headline(fetch, dnsOk, domain, regions, outage),
      findings: findings,
      log: log,
    );
  }

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

  String _registrableDomain(String host) {
    final labels = host.split('.').where((l) => l.isNotEmpty).toList();
    if (labels.length <= 2) return host;
    return labels.sublist(labels.length - 2).join('.');
  }

  // ── Finding builders ─────────────────────────────────────────────────────

  void _addDnsAndDomain(
    List<UrlFinding> out,
    String host,
    bool hostIsIp,
    bool dnsOk,
    DomainInfo domain,
  ) {
    if (!hostIsIp && !dnsOk) {
      out.add(
        const UrlFinding(
          severity: UrlSeverity.problem,
          title: "The address doesn't exist",
          detail:
              'The website name could not be found on the Internet. Check '
              'the spelling of the address. If it is correct, the site may '
              'have shut down or its domain may have lapsed.',
        ),
      );
    }
    if (!domain.checked) return;
    if (!domain.exists) {
      out.add(
        const UrlFinding(
          severity: UrlSeverity.problem,
          title: 'Domain is not registered',
          detail:
              'No registration exists for this domain. It was likely typed '
              'wrong, or the previous owner let it expire and it is now free.',
        ),
      );
      return;
    }
    if (domain.expired) {
      out.add(
        UrlFinding(
          severity: UrlSeverity.problem,
          title: 'Domain registration has expired',
          detail:
              'The owner appears to have let the domain lapse'
              '${_expirySuffix(domain.expiry)}. Until they renew it, the '
              'site will not work for anyone. There is nothing you can fix.',
        ),
      );
      return;
    }
    final expiry = domain.expiry;
    if (expiry != null) {
      final days = expiry.difference(DateTime.now()).inDays;
      if (days >= 0 && days <= 30) {
        out.add(
          UrlFinding(
            severity: UrlSeverity.info,
            title: 'Domain expires soon',
            detail:
                'The domain registration expires in $days day(s). This is '
                'the domain owner concern, not a fault on your side.',
          ),
        );
      }
    }
  }

  void _addHttp(List<UrlFinding> out, HttpFetchResult fetch) {
    if (fetch.isSuccess) {
      out.add(
        UrlFinding(
          severity: UrlSeverity.ok,
          title: 'The website loaded',
          detail:
              'The page answered normally (code ${fetch.statusCode}) from '
              'your device, so the service itself is up for you.',
        ),
      );
      final ms = fetch.elapsedMs;
      if (ms != null && ms > 8000) {
        out.add(
          UrlFinding(
            severity: UrlSeverity.warning,
            title: 'The website is very slow',
            detail:
                'It took ${(ms / 1000).toStringAsFixed(1)} seconds to '
                'respond. The site or your connection may be congested; try '
                'again later or on a different network.',
          ),
        );
      }
      return;
    }
    if (!fetch.reached) {
      out.add(
        UrlFinding(
          severity: UrlSeverity.problem,
          title: 'The website did not respond',
          detail:
              'No reply came back from the server'
              '${fetch.error != null ? " (${fetch.error})" : ""}. The other '
              'checks below help tell whether it is down, blocked, or a '
              'wrong address/port.',
        ),
      );
      return;
    }
    out.add(_httpStatusFinding(fetch.statusCode!));
  }

  UrlFinding _httpStatusFinding(int code) {
    switch (code) {
      case 401:
        return const UrlFinding(
          severity: UrlSeverity.warning,
          title: 'Sign-in required (401)',
          detail:
              'The site works but needs you to log in first. Open it in a '
              'browser and sign in with your account.',
        );
      case 403:
        return const UrlFinding(
          severity: UrlSeverity.problem,
          title: 'Access denied (403)',
          detail:
              'The server refused the request. This is often geo-blocking, '
              'a network/firewall block, or a block on automated access. '
              'Try a different network, mobile data, or a VPN.',
        );
      case 404:
        return const UrlFinding(
          severity: UrlSeverity.warning,
          title: 'Page not found (404)',
          detail:
              'The server is up but this exact page does not exist. Check '
              'the address, or open the site home page and navigate from '
              'there.',
        );
      case 408:
        return const UrlFinding(
          severity: UrlSeverity.warning,
          title: 'Request timed out (408)',
          detail:
              'The server was too slow to accept the request. Try again; if '
              'it persists the site is overloaded.',
        );
      case 429:
        return const UrlFinding(
          severity: UrlSeverity.warning,
          title: 'Too many requests (429)',
          detail:
              'The site is rate-limiting you. Wait a minute and try again, '
              'and avoid refreshing repeatedly.',
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return UrlFinding(
          severity: UrlSeverity.problem,
          title: 'The website has a server error ($code)',
          detail:
              'The problem is on the website end, not yours. It may be '
              'down or under maintenance. Wait and try again later.',
        );
      default:
        if (code >= 500) {
          return UrlFinding(
            severity: UrlSeverity.problem,
            title: 'Server error ($code)',
            detail:
                'The website returned a server-side error. This is on their '
                'side; try again later.',
          );
        }
        if (code >= 400) {
          return UrlFinding(
            severity: UrlSeverity.warning,
            title: 'The request was rejected ($code)',
            detail:
                'The server did not accept the request. Double-check the '
                'address; the page may have moved or require login.',
          );
        }
        return UrlFinding(
          severity: UrlSeverity.info,
          title: 'Unexpected response ($code)',
          detail:
              'The site answered with an unusual code. It may still work in '
              'a normal browser.',
        );
    }
  }

  void _addTls(List<UrlFinding> out, TlsInfo tls) {
    if (!tls.checked) return;
    if (!tls.valid) {
      out.add(
        UrlFinding(
          severity: UrlSeverity.problem,
          title: 'Security certificate problem',
          detail:
              'The site HTTPS certificate could not be trusted'
              '${tls.issue != null ? " (${tls.issue})" : ""}. Do not enter '
              'passwords. Check that your device date and time are correct; '
              'if they are, the site is misconfigured.',
        ),
      );
      return;
    }
    final expiry = tls.expiry;
    if (expiry != null) {
      final days = expiry.difference(DateTime.now()).inDays;
      if (days >= 0 && days <= 14) {
        out.add(
          UrlFinding(
            severity: UrlSeverity.warning,
            title: 'Certificate expires soon',
            detail:
                'The security certificate expires in $days day(s). The site '
                'still works for now; the owner should renew it.',
          ),
        );
      }
    }
  }

  void _addPorts(List<UrlFinding> out, Uri url, List<UrlPortResult> ports) {
    if (ports.isEmpty) return;
    final isHttps = url.scheme == 'https';
    final mainPort = isHttps ? 443 : 80;
    final altPort = isHttps ? 8443 : 8080;
    final main = _portResult(ports, mainPort);
    final alt = _portResult(ports, altPort);
    if (main != null && !main.open && alt != null && alt.open) {
      out.add(
        UrlFinding(
          severity: UrlSeverity.info,
          title: 'Try adding a port number',
          detail:
              'The usual port $mainPort is closed, but port $altPort is '
              'open. The service may live at '
              '${url.scheme}://${url.host}:$altPort — try adding ":$altPort" '
              'to the address.',
        ),
      );
    }
  }

  void _addRegions(
    List<UrlFinding> out,
    HttpFetchResult fetch,
    RegionReport regions,
  ) {
    if (!regions.available || regions.total == 0) return;
    if (regions.downEverywhere) {
      out.add(
        const UrlFinding(
          severity: UrlSeverity.problem,
          title: 'Down for everyone',
          detail:
              'The site could not be reached from any of the test locations '
              'around the world, so it is almost certainly down for '
              'everyone — not just you. Wait and try later.',
        ),
      );
      return;
    }
    if (!fetch.isSuccess && regions.reachableFromSome) {
      final where = regions.blockedCountries.isNotEmpty
          ? ' (blocked from: ${regions.blockedCountries.join(", ")})'
          : '';
      out.add(
        UrlFinding(
          severity: UrlSeverity.problem,
          title: 'Blocked for you, but up elsewhere',
          detail:
              'The site loads from other countries but not from your '
              'connection$where. This points to geo-blocking or a block on '
              'your network/ISP. A VPN, mobile data, or a different DNS '
              'often gets around it.',
        ),
      );
      return;
    }
    if (fetch.isSuccess && regions.blockedCountries.isNotEmpty) {
      out.add(
        UrlFinding(
          severity: UrlSeverity.info,
          title: 'Restricted in some regions',
          detail:
              'It works for you, but was blocked from '
              '${regions.blockedCountries.join(", ")}. If someone elsewhere '
              'cannot open it, that is likely geo-restriction.',
        ),
      );
    }
  }

  /// Cross-checks our own fetch result against an independent outage service
  /// (websitedown.org), which probes from several continents. This confirms
  /// "down for everyone" vs "blocked just for you" and flags geo-fencing.
  void _addOutageCrossCheck(
    List<UrlFinding> out,
    HttpFetchResult fetch,
    OutageReport o,
  ) {
    if (!o.available || o.total == 0) return;
    final scope = '${o.up} of ${o.total} regions';
    if (fetch.isSuccess) {
      if (o.likelyBlocked > 0) {
        out.add(
          UrlFinding(
            severity: UrlSeverity.info,
            title: 'Restricted in some regions',
            detail:
                'It works for you, but an independent outage service '
                '(${o.source}) found it blocked in ${o.likelyBlocked} of its '
                '${o.total} test regions. If someone abroad cannot open it, '
                'that is likely geo-restriction, not a fault on your side.',
          ),
        );
        return;
      }
      out.add(
        UrlFinding(
          severity: UrlSeverity.ok,
          title: 'Confirmed working worldwide',
          detail:
              'An independent outage service (${o.source}) also reached the '
              'site from $scope, so it is genuinely up — not just cached for '
              'you.',
        ),
      );
      return;
    }
    if (o.downEverywhere) {
      out.add(
        UrlFinding(
          severity: UrlSeverity.problem,
          title: 'Independent check agrees: down for everyone',
          detail:
              'An independent outage service (${o.source}) could not reach the '
              'site from any of its ${o.total} test regions either. The site '
              'is down for everyone, not just you — there is nothing to fix on '
              'your side; wait and try later.',
        ),
      );
      return;
    }
    if (o.upEverywhere) {
      out.add(
        UrlFinding(
          severity: UrlSeverity.problem,
          title: 'Up worldwide, but not for you',
          detail:
              'An independent outage service (${o.source}) reached the site '
              'from all $scope, yet it failed on your connection. That '
              'strongly points to a block on your network/ISP or a '
              'geo-restriction. Try mobile data, a different DNS, or a VPN.',
        ),
      );
      _maybeSuggestAlternate(out, o);
      return;
    }
    if (o.likelyBlocked > 0) {
      out.add(
        UrlFinding(
          severity: UrlSeverity.problem,
          title: 'Blocked in some regions (geo-restriction)',
          detail:
              'An independent outage service (${o.source}) reached the site '
              'from $scope but found it blocked in ${o.likelyBlocked} of them. '
              'This is a sign of geo-fencing; a VPN set to an allowed country '
              'usually gets around it.',
        ),
      );
      _maybeSuggestAlternate(out, o);
      return;
    }
    out.add(
      UrlFinding(
        severity: UrlSeverity.info,
        title: 'Second opinion from $scope',
        detail:
            'An independent outage service (${o.source}) reports: '
            '"${o.summary}".',
      ),
    );
    _maybeSuggestAlternate(out, o);
  }

  void _maybeSuggestAlternate(List<UrlFinding> out, OutageReport o) {
    final alt = o.alternateHost;
    if (alt == null || !o.alternateHostUp) return;
    out.add(
      UrlFinding(
        severity: UrlSeverity.info,
        title: 'Try the "$alt" address',
        detail:
            'The exact address did not work, but "$alt" did. You may have '
            'left off (or added) a "www." — open $alt instead.',
      ),
    );
  }

  String _headline(
    HttpFetchResult fetch,
    bool dnsOk,
    DomainInfo domain,
    RegionReport regions,
    OutageReport outage,
  ) {
    if (fetch.isSuccess) return 'The website works';
    if (domain.checked && !domain.exists) {
      return 'This web address is not registered';
    }
    if (domain.expired) return 'The site domain has expired';
    if (!dnsOk) return "This web address can't be found";
    if (regions.downEverywhere || outage.downEverywhere) {
      return 'The website is down for everyone';
    }
    if (!fetch.reached && (regions.reachableFromSome || outage.upEverywhere)) {
      return 'The website seems blocked for you';
    }
    if (fetch.reached && fetch.statusCode != null) {
      return 'The website answered with a problem (${fetch.statusCode})';
    }
    return 'The website is not responding';
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
