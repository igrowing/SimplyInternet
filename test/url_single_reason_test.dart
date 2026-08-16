import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_facts.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';

import 'fakes.dart';

/// Findings the user reads as "something is wrong" — the count that must
/// never exceed one for a single failure.
int badFindings(UrlCheckReport report) => report.findings
    .where(
      (f) =>
          f.severity == UrlSeverity.problem ||
          f.severity == UrlSeverity.warning,
    )
    .length;

void main() {
  group('one failure, one reason', () {
    test('a dead domain produces a single reason, not five', () async {
      // kirgudubutbiya.net: nothing resolves, no registration, nobody
      // anywhere can reach it. Every source agrees, so the user sees one
      // message.
      final report = await CheckUrl(
        FakeUrlInspector(
          dns: false,
          fetchResult: const HttpFetchResult.failed('no host'),
          domain: const DomainInfo(checked: true),
          regions: const RegionReport(available: true, total: 12),
          outage: const OutageReport(
            available: true,
            verdict: 'down',
            total: 8,
          ),
        ),
      ).call('kirgudubutbiya.net');
      expect(report.findings.single.title, "The address doesn't exist");
      expect(report.headline, "This web address can't be found.");
      expect(report.findings.single.detail, contains('registry'));
    });

    test('a geo-block is one message, not two readings of "you"', () async {
      // iherb.com from Italy: our fetch dies, both external sources say up.
      final report = await CheckUrl(
        FakeUrlInspector(
          dns: false,
          fetchResult: const HttpFetchResult.failed('no route to host'),
          regions: const RegionReport(
            available: true,
            total: 12,
            reachable: 10,
            blockedCountries: ['IT', 'DE'],
          ),
          outage: const OutageReport(
            available: true,
            isUp: true,
            verdict: 'up',
            total: 8,
            up: 8,
          ),
        ),
      ).call('iherb.com');
      expect(badFindings(report), 1);
      expect(
        report.findings.single.title,
        'Blocked on your connection or in your country.',
      );
      expect(report.findings.single.detail, contains('IT, DE'));
    });

    test('a mixed working result keeps only the warning', () async {
      // meuhedet.co.il from Italy: it loads for the user but is refused in
      // some countries. One warning, no green messages beside it.
      final report = await CheckUrl(
        FakeUrlInspector(
          domain: const DomainInfo(checked: true), // RDAP 404 for .il
          regions: const RegionReport(
            available: true,
            total: 12,
            reachable: 9,
            blockedCountries: ['US', 'BR', 'SG'],
          ),
          outage: const OutageReport(
            available: true,
            isUp: true,
            verdict: 'up',
            total: 8,
            up: 8,
          ),
        ),
      ).call('meuhedet.co.il');
      expect(report.findings, hasLength(1));
      expect(report.findings.single.severity, UrlSeverity.warning);
      expect(
        report.findings.where((f) => f.severity == UrlSeverity.ok),
        isEmpty,
      );
    });

    test('every failure scenario yields exactly one reason', () async {
      final scenarios = <String, FakeUrlInspector>{
        'no response': FakeUrlInspector(
          fetchResult: const HttpFetchResult.failed('timed out'),
        ),
        '404': FakeUrlInspector(
          fetchResult: const HttpFetchResult(reached: true, statusCode: 404),
        ),
        '500': FakeUrlInspector(
          fetchResult: const HttpFetchResult(reached: true, statusCode: 500),
        ),
        '451': FakeUrlInspector(
          fetchResult: const HttpFetchResult(reached: true, statusCode: 451),
        ),
        'bad certificate': FakeUrlInspector(
          fetchResult: const HttpFetchResult.failed('handshake'),
          tls: const TlsInfo(checked: true, issue: 'certificate expired'),
        ),
        'expired domain': FakeUrlInspector(
          fetchResult: const HttpFetchResult.failed('refused'),
          domain: DomainInfo(
            checked: true,
            exists: true,
            expired: true,
            expiry: DateTime.now().subtract(const Duration(days: 3)),
          ),
        ),
        'down everywhere': FakeUrlInspector(
          fetchResult: const HttpFetchResult.failed('timed out'),
          regions: const RegionReport(available: true, total: 12),
        ),
        'dead domain': FakeUrlInspector(
          dns: false,
          fetchResult: const HttpFetchResult.failed('no host'),
          domain: const DomainInfo(checked: true),
        ),
      };
      for (final entry in scenarios.entries) {
        final report = await CheckUrl(entry.value).call('https://x.example');
        expect(
          badFindings(report),
          1,
          reason:
              '${entry.key} produced ${badFindings(report)} reasons: '
              '${report.findings.map((f) => f.title).join(" | ")}',
        );
      }
    });
  });

  group('technical details', () {
    test('lists every place the site was opened from', () async {
      final report = await CheckUrl(
        FakeUrlInspector(
          regions: const RegionReport(
            available: true,
            total: 2,
            reachable: 1,
            blockedCountries: ['DE'],
            probes: [
              RegionProbe(location: 'US', reachable: true),
              RegionProbe(location: 'DE', reachable: false),
            ],
          ),
          outage: const OutageReport(
            available: true,
            isUp: true,
            verdict: 'up',
            total: 2,
            up: 1,
            likelyBlocked: 1,
            probes: [
              RegionProbe(
                location: 'Europe (CDG)',
                reachable: true,
                statusCode: 200,
              ),
              RegionProbe(location: 'Asia East (Tokyo)', reachable: false),
            ],
          ),
        ),
      ).call('example.com');
      expect(report.log, contains('## From other countries (check-host.net)'));
      expect(report.log, contains('- US: reached'));
      expect(report.log, contains('- DE: failed'));
      expect(
        report.log,
        contains(
          '## Independent outage check '
          '(websitedown.org)',
        ),
      );
      expect(report.log, contains('- Europe (CDG): reached (200)'));
      expect(report.log, contains('- Asia East (Tokyo): failed'));
    });

    test('uses headings and bullets the copy button can reproduce', () async {
      final report = await CheckUrl(FakeUrlInspector()).call('example.com');
      expect(report.log.first, startsWith('## '));
      final content = report.log.where((l) => l.trim().isNotEmpty);
      expect(
        content.every((l) => l.startsWith('## ') || l.startsWith('- ')),
        isTrue,
        reason: report.log.join('\n'),
      );
    });
  });
}
