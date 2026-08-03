import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_facts.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';

import 'fakes.dart';

UrlFinding? findingWithTitle(UrlCheckReport r, String title) {
  for (final f in r.findings) {
    if (f.title == title) return f;
  }
  return null;
}

void main() {
  group('CheckUrl', () {
    test('adds https and reports success for a healthy site', () async {
      final report = await CheckUrl(FakeUrlInspector()).call('example.com');
      expect(report.url, 'https://example.com');
      expect(report.reachable, isTrue);
      expect(report.headline, 'The website works');
      expect(report.worst, UrlSeverity.ok);
    });

    test('still reports success when the region probe throws', () async {
      final report = await CheckUrl(
        FakeUrlInspector(throwOnRegions: true),
      ).call('example.com');
      expect(report.reachable, isTrue);
      expect(report.headline, 'The website works');
    });

    test('explains a 403 as access denied', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          fetchResult: const HttpFetchResult(reached: true, statusCode: 403),
        ),
      ).call('https://blocked.example');
      expect(report.reachable, isFalse);
      expect(report.worst, UrlSeverity.problem);
      expect(findingWithTitle(report, 'Access denied (403)'), isNotNull);
    });

    test('flags a non-existent address when DNS fails', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          dns: false,
          fetchResult: const HttpFetchResult.failed('no host'),
          domain: const DomainInfo.unavailable(),
        ),
      ).call('nope.invalid');
      expect(report.headline, "This web address can't be found");
      expect(findingWithTitle(report, "The address doesn't exist"), isNotNull);
    });

    test('reports an expired domain registration', () async {
      final expiry = DateTime.now().subtract(const Duration(days: 5));
      final report = await CheckUrl(
        FakeUrlInspector(
          fetchResult: const HttpFetchResult.failed('refused'),
          domain: DomainInfo(
            checked: true,
            exists: true,
            expired: true,
            expiry: expiry,
          ),
        ),
      ).call('expired.example');
      expect(report.headline, 'The site domain has expired');
      expect(
        findingWithTitle(report, 'Domain registration has expired'),
        isNotNull,
      );
    });

    test(
      'suggests an alternate port when 443 is closed but 8443 open',
      () async {
        final report = await CheckUrl(
          FakeUrlInspector(
            fetchResult: const HttpFetchResult.failed('refused'),
            ports: const [
              UrlPortResult(port: 80, service: 'HTTP', open: false),
              UrlPortResult(port: 443, service: 'HTTPS', open: false),
              UrlPortResult(port: 8080, service: 'HTTP-alt', open: false),
              UrlPortResult(port: 8443, service: 'HTTPS-alt', open: true),
            ],
          ),
        ).call('https://svc.example');
        expect(findingWithTitle(report, 'Try adding a port number'), isNotNull);
      },
    );

    test('detects a site that is blocked for you but up elsewhere', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          fetchResult: const HttpFetchResult.failed('refused'),
          regions: const RegionReport(
            available: true,
            total: 5,
            reachable: 4,
            blockedCountries: ['DE'],
          ),
        ),
      ).call('https://geo.example');
      expect(report.headline, 'The website seems blocked for you');
      expect(
        findingWithTitle(report, 'Blocked for you, but up elsewhere'),
        isNotNull,
      );
    });

    test('detects a site that is down for everyone', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          fetchResult: const HttpFetchResult.failed('timed out'),
          regions: const RegionReport(available: true, total: 6),
        ),
      ).call('https://dead.example');
      expect(report.headline, 'The website is down for everyone');
      expect(findingWithTitle(report, 'Down for everyone'), isNotNull);
    });

    test('still reports success when the outage cross-check throws', () async {
      final report = await CheckUrl(
        FakeUrlInspector(throwOnOutage: true),
      ).call('example.com');
      expect(report.reachable, isTrue);
      expect(report.headline, 'The website works');
    });

    test(
      'outage cross-check confirms blocked-for-you when up worldwide',
      () async {
        final report = await CheckUrl(
          FakeUrlInspector(
            fetchResult: const HttpFetchResult.failed('refused'),
            outage: const OutageReport(
              available: true,
              isUp: true,
              verdict: 'up',
              total: 8,
              up: 8,
            ),
          ),
        ).call('https://geo.example');
        expect(report.headline, 'The website seems blocked for you');
        expect(
          findingWithTitle(report, 'Up worldwide, but not for you'),
          isNotNull,
        );
      },
    );

    test('outage cross-check confirms down for everyone', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          fetchResult: const HttpFetchResult.failed('timed out'),
          outage: const OutageReport(
            available: true,
            verdict: 'down',
            total: 8,
          ),
        ),
      ).call('https://dead.example');
      expect(report.headline, 'The website is down for everyone');
      expect(
        findingWithTitle(report, 'Independent check agrees: down for everyone'),
        isNotNull,
      );
    });

    test('outage cross-check flags geo-fencing on a working site', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          outage: const OutageReport(
            available: true,
            isUp: true,
            verdict: 'partial',
            total: 8,
            up: 6,
            likelyBlocked: 2,
          ),
        ),
      ).call('https://geo-ok.example');
      expect(report.reachable, isTrue);
      expect(findingWithTitle(report, 'Restricted in some regions'), isNotNull);
    });

    test('outage cross-check suggests a working alternate host', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          fetchResult: const HttpFetchResult.failed('refused'),
          outage: const OutageReport(
            available: true,
            verdict: 'partial',
            total: 8,
            up: 4,
            alternateHost: 'www.alt.example',
            alternateHostUp: true,
          ),
        ),
      ).call('https://alt.example');
      expect(
        findingWithTitle(report, 'Try the "www.alt.example" address'),
        isNotNull,
      );
    });

    test('a healthy site confirmed worldwide stays green', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          outage: const OutageReport(
            available: true,
            isUp: true,
            verdict: 'up',
            total: 8,
            up: 8,
          ),
        ),
      ).call('example.com');
      expect(report.headline, 'The website works');
      expect(report.worst, UrlSeverity.ok);
      expect(
        findingWithTitle(report, 'Confirmed working worldwide'),
        isNotNull,
      );
    });

    // Regression: rdap.org returns 404 for registries it does not cover
    // (e.g. .il), which must NOT be reported as "not registered" when the
    // site clearly loads (the meuhedet.co.il case).
    test('working site is not marked unregistered on an RDAP 404', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          domain: const DomainInfo(checked: true), // exists == false (404)
          outage: const OutageReport(
            available: true,
            isUp: true,
            verdict: 'up',
            total: 8,
            up: 8,
          ),
        ),
      ).call('meuhedet.co.il');
      expect(report.headline, 'The website works');
      expect(report.worst, UrlSeverity.ok);
      expect(findingWithTitle(report, 'Domain is not registered'), isNull);
    });

    // Regression: a hard geo-block shows up locally as DNS + connection
    // failures, but RDAP confirms the domain and the cross-check says it is
    // up worldwide (the iherb.com case). We must not say "can't be found".
    test('hard geo-block reads as blocked, not a dead address', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          dns: false,
          fetchResult: const HttpFetchResult.failed('no route to host'),
          outage: const OutageReport(
            available: true,
            isUp: true,
            verdict: 'up',
            total: 8,
            up: 8,
          ),
        ),
      ).call('iherb.com');
      expect(report.headline, 'The website seems blocked for you');
      expect(findingWithTitle(report, "The address doesn't exist"), isNull);
      expect(findingWithTitle(report, 'Domain is not registered'), isNull);
      expect(findingWithTitle(report, 'The website did not respond'), isNull);
      expect(
        findingWithTitle(report, 'Up worldwide, but not for you'),
        isNotNull,
      );
      // A block on the user's side is a warning, not a scary red "broken".
      expect(report.worst, UrlSeverity.warning);
    });

    // A real 4xx must stay a 4xx even when the host is up elsewhere — the
    // server answered, so this is not a network block.
    test('a 404 is not mistaken for a geo-block', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          fetchResult: const HttpFetchResult(reached: true, statusCode: 404),
          outage: const OutageReport(
            available: true,
            isUp: true,
            verdict: 'up',
            total: 8,
            up: 8,
          ),
        ),
      ).call('https://httpstat.us/404');
      expect(report.headline, 'The website answered with a problem (404)');
      expect(findingWithTitle(report, 'Page not found (404)'), isNotNull);
    });

    test('uses the registrable domain under a multi-label suffix', () async {
      final fake = FakeUrlInspector();
      await CheckUrl(fake).call('www.meuhedet.co.il');
      expect(fake.lastDomainQueried, 'meuhedet.co.il');
    });

    test('flags a bad TLS certificate', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          tls: const TlsInfo(checked: true, issue: 'certificate expired'),
        ),
      ).call('https://badcert.example');
      expect(
        findingWithTitle(report, 'Security certificate problem'),
        isNotNull,
      );
    });

    test('rejects an empty or invalid address', () async {
      final check = CheckUrl(FakeUrlInspector());
      expect(() => check.call('   '), throwsA(isA<InvalidUrlException>()));
      expect(
        () => check.call('ftp://example.com'),
        throwsA(isA<InvalidUrlException>()),
      );
    });
  });
}
