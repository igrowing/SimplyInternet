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
