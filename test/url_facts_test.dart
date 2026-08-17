import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_facts.dart';

void main() {
  group('HttpFetchResult.isSuccess', () {
    test('is true only for a 2xx that was actually reached', () {
      for (final code in [200, 201, 204, 299]) {
        expect(
          const HttpFetchResult(reached: true).copyStatus(code).isSuccess,
          isTrue,
          reason: '$code',
        );
      }
    });

    test('is false on either side of the 2xx range', () {
      for (final code in [199, 300, 301, 404, 500]) {
        expect(
          const HttpFetchResult(reached: true).copyStatus(code).isSuccess,
          isFalse,
          reason: '$code',
        );
      }
    });

    test('is false when nothing was reached or no code came back', () {
      expect(
        const HttpFetchResult(reached: false, statusCode: 200).isSuccess,
        isFalse,
      );
      expect(const HttpFetchResult(reached: true).isSuccess, isFalse);
    });
  });

  group('HttpFetchResult.failed', () {
    test('carries the reason and nothing else', () {
      const result = HttpFetchResult.failed('timed out');
      expect(result.reached, isFalse);
      expect(result.error, 'timed out');
      expect(result.statusCode, isNull);
      expect(result.finalUrl, isNull);
      expect(result.elapsedMs, isNull);
      expect(result.retryAfterSeconds, isNull);
      expect(result.isSuccess, isFalse);
    });

    test('compares by value', () {
      expect(
        const HttpFetchResult.failed('timed out'),
        const HttpFetchResult.failed('timed out'),
      );
      expect(
        const HttpFetchResult.failed('timed out'),
        isNot(const HttpFetchResult.failed('refused')),
      );
      expect(
        const HttpFetchResult(reached: true, statusCode: 200, elapsedMs: 12),
        const HttpFetchResult(reached: true, statusCode: 200, elapsedMs: 12),
      );
    });
  });

  group('DomainInfo', () {
    test('unavailable means nothing was learned, not "does not exist"', () {
      const info = DomainInfo.unavailable();
      expect(info.checked, isFalse);
      expect(info.exists, isFalse);
      expect(info.expired, isFalse);
      expect(info.expiry, isNull);
      expect(info.error, isNull);
    });

    test('a checked lookup that found nothing differs from unavailable', () {
      // "The registry has no such domain" is a finding; "we could not ask" is
      // not, and the two must never compare equal.
      expect(
        const DomainInfo(checked: true),
        isNot(const DomainInfo.unavailable()),
      );
    });

    test('compares by value including the expiry date', () {
      final when = DateTime.utc(2030);
      expect(
        DomainInfo(checked: true, exists: true, expiry: when),
        DomainInfo(checked: true, exists: true, expiry: DateTime.utc(2030)),
      );
      expect(
        DomainInfo(checked: true, exists: true, expiry: when),
        isNot(
          DomainInfo(checked: true, exists: true, expiry: DateTime.utc(2031)),
        ),
      );
    });
  });

  group('TlsInfo', () {
    test('unavailable is not the same as an invalid certificate', () {
      const unavailable = TlsInfo.unavailable();
      expect(unavailable.checked, isFalse);
      expect(unavailable.valid, isFalse);
      expect(unavailable.issue, isNull);
      expect(
        unavailable,
        isNot(const TlsInfo(checked: true, issue: 'certificate expired')),
      );
    });

    test('compares by value', () {
      expect(
        const TlsInfo(checked: true, valid: true),
        const TlsInfo(checked: true, valid: true),
      );
      expect(
        const TlsInfo(checked: true, issue: 'expired'),
        isNot(const TlsInfo(checked: true, issue: 'not trusted')),
      );
    });
  });

  group('UrlPortResult', () {
    test('compares by value', () {
      expect(
        const UrlPortResult(port: 443, service: 'HTTPS', open: true),
        const UrlPortResult(port: 443, service: 'HTTPS', open: true),
      );
      expect(
        const UrlPortResult(port: 443, service: 'HTTPS', open: true),
        isNot(const UrlPortResult(port: 443, service: 'HTTPS', open: false)),
      );
    });
  });

  group('RegionProbe', () {
    test('keeps a status code apart from none at all', () {
      const withCode = RegionProbe(
        location: 'DE',
        reachable: true,
        statusCode: 200,
      );
      const without = RegionProbe(location: 'DE', reachable: true);
      expect(without.statusCode, isNull);
      expect(withCode, isNot(without));
    });
  });

  group('RegionReport', () {
    test('an unavailable report claims nothing at all', () {
      const report = RegionReport.unavailable();
      expect(report.available, isFalse);
      expect(report.total, 0);
      expect(report.reachable, 0);
      expect(report.blockedCountries, isEmpty);
      expect(report.probes, isEmpty);
      // With no data, neither "up everywhere" nor "down everywhere" may be
      // claimed — an unavailable service is not evidence of an outage.
      expect(report.reachableFromSome, isFalse);
      expect(report.reachableFromAll, isFalse);
      expect(report.downEverywhere, isFalse);
    });

    test('reachable from all when every node got through', () {
      const report = RegionReport(available: true, total: 4, reachable: 4);
      expect(report.reachableFromSome, isTrue);
      expect(report.reachableFromAll, isTrue);
      expect(report.downEverywhere, isFalse);
    });

    test('down everywhere when no node got through', () {
      const report = RegionReport(
        available: true,
        total: 4,
        blockedCountries: ['CN', 'RU'],
      );
      expect(report.reachableFromSome, isFalse);
      expect(report.reachableFromAll, isFalse);
      expect(report.downEverywhere, isTrue);
    });

    test('a partial result is neither all nor nothing', () {
      const report = RegionReport(available: true, total: 4, reachable: 1);
      expect(report.reachableFromSome, isTrue);
      expect(report.reachableFromAll, isFalse);
      expect(report.downEverywhere, isFalse);
    });

    test('zero nodes is never treated as an answer', () {
      // An "available" report with nothing in it would otherwise read as
      // "down everywhere" and blame a site that was never probed.
      const report = RegionReport(available: true);
      expect(report.reachableFromAll, isFalse);
      expect(report.downEverywhere, isFalse);
    });

    test('compares by value, probe list included', () {
      RegionReport build({bool reachable = true}) => RegionReport(
        available: true,
        total: 1,
        reachable: 1,
        blockedCountries: const ['DE'],
        probes: [RegionProbe(location: 'DE', reachable: reachable)],
      );
      expect(build(), build());
      expect(build(), isNot(build(reachable: false)));
      expect(build(), isNot(const RegionReport.unavailable()));
    });
  });

  group('OutageReport', () {
    test('an unavailable report claims nothing at all', () {
      const report = OutageReport.unavailable();
      expect(report.available, isFalse);
      expect(report.isUp, isFalse);
      expect(report.verdict, '');
      expect(report.summary, '');
      expect(report.total, 0);
      expect(report.up, 0);
      expect(report.likelyBlocked, 0);
      expect(report.alternateHost, isNull);
      expect(report.alternateHostUp, isFalse);
      expect(report.probes, isEmpty);
      expect(report.downEverywhere, isFalse);
      expect(report.upEverywhere, isFalse);
      // Named even when nothing was learned, so the report can say who it
      // asked.
      expect(report.source, 'websitedown.org');
    });

    test('up everywhere when every region reached the site', () {
      const report = OutageReport(
        available: true,
        isUp: true,
        verdict: 'up',
        total: 6,
        up: 6,
      );
      expect(report.upEverywhere, isTrue);
      expect(report.downEverywhere, isFalse);
    });

    test('down everywhere when no region reached the site', () {
      const report = OutageReport(
        available: true,
        verdict: 'down',
        total: 6,
        likelyBlocked: 6,
      );
      expect(report.downEverywhere, isTrue);
      expect(report.upEverywhere, isFalse);
    });

    test('a partial outage is neither', () {
      const report = OutageReport(available: true, total: 6, up: 2);
      expect(report.downEverywhere, isFalse);
      expect(report.upEverywhere, isFalse);
    });

    test('zero regions is never treated as an answer', () {
      const report = OutageReport(available: true);
      expect(report.downEverywhere, isFalse);
      expect(report.upEverywhere, isFalse);
    });

    test('compares by value', () {
      expect(
        const OutageReport(available: true, total: 3, up: 3),
        const OutageReport(available: true, total: 3, up: 3),
      );
      expect(
        const OutageReport(available: true, total: 3, up: 3),
        isNot(const OutageReport(available: true, total: 3, up: 2)),
      );
    });
  });

  group('UrlCheckReport.worst', () {
    test('is ok when there is nothing to report', () {
      const report = UrlCheckReport(
        url: 'https://example.com',
        reachable: true,
        headline: 'The website works',
        findings: [],
      );
      expect(report.worst, UrlSeverity.ok);
      expect(report.advice, isEmpty);
      expect(report.log, isEmpty);
    });

    test('takes the most severe finding, wherever it sits in the list', () {
      const report = UrlCheckReport(
        url: 'https://example.com',
        reachable: false,
        headline: 'Something is wrong',
        findings: [
          UrlFinding(severity: UrlSeverity.problem, detail: 'dead'),
          UrlFinding(severity: UrlSeverity.info, detail: 'fyi'),
          UrlFinding(severity: UrlSeverity.warning, detail: 'hmm'),
        ],
      );
      expect(report.worst, UrlSeverity.problem);
    });

    test('does not promote past the worst it actually saw', () {
      const report = UrlCheckReport(
        url: 'https://example.com',
        reachable: true,
        headline: 'Mostly fine',
        findings: [
          UrlFinding(severity: UrlSeverity.ok, detail: 'fine'),
          UrlFinding(severity: UrlSeverity.info, detail: 'fyi'),
        ],
      );
      expect(report.worst, UrlSeverity.info);
    });

    test('compares by value, findings and advice included', () {
      UrlCheckReport build({String advice = 'Try again in a minute.'}) =>
          UrlCheckReport(
            url: 'https://example.com',
            reachable: false,
            headline: 'Something is wrong',
            findings: const [
              UrlFinding(severity: UrlSeverity.problem, detail: 'dead'),
            ],
            advice: [advice],
            log: const ['## Request'],
          );
      expect(build(), build());
      expect(build(), isNot(build(advice: 'Check the address.')));
    });

    test('severities are ordered least to most alarming', () {
      expect(
        UrlSeverity.values,
        [
          UrlSeverity.ok,
          UrlSeverity.info,
          UrlSeverity.warning,
          UrlSeverity.problem,
        ],
      );
    });
  });

  group('UrlFinding', () {
    test('a title is optional and part of its identity', () {
      const titled = UrlFinding(
        severity: UrlSeverity.warning,
        title: 'Page not found (404).',
        detail: 'The server is up but this page does not exist.',
      );
      const untitled = UrlFinding(
        severity: UrlSeverity.warning,
        detail: 'The server is up but this page does not exist.',
      );
      expect(untitled.title, isNull);
      expect(titled, isNot(untitled));
      expect(
        titled,
        const UrlFinding(
          severity: UrlSeverity.warning,
          title: 'Page not found (404).',
          detail: 'The server is up but this page does not exist.',
        ),
      );
    });
  });
}

/// Rebuilds a reached result with a different status code, so the 2xx boundary
/// can be swept without repeating the constructor at every code.
extension on HttpFetchResult {
  HttpFetchResult copyStatus(int code) =>
      HttpFetchResult(reached: reached, statusCode: code);
}
