import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/capability.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/data_usage.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/link_quality.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';

import 'fakes.dart';

void main() {
  group('RunDiagnosis decision tree', () {
    test('reports notConnected when there is no link', () async {
      final probe = FakeNetworkProbe(
        connectivityResult: const ConnectivityStatus(
          kind: ConnectivityKind.none,
          airplaneMode: false,
        ),
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.notConnected);
      expect(report.solution, isNotNull);
    });

    test('reports notConnected (flight mode) before anything else', () async {
      final probe = FakeNetworkProbe(
        connectivityResult: const ConnectivityStatus(
          kind: ConnectivityKind.none,
          airplaneMode: true,
        ),
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.notConnected);
      expect(report.verdict.title.toLowerCase(), contains('flight'));
    });

    test('reports routerNotResponding when gateway is dead on wifi', () async {
      final probe = FakeNetworkProbe(gatewayReachable: false);
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.routerNotResponding);
      expect(report.verdict.detailArg, '192.168.1.1');
    });

    test('ignores gateway on mobile links', () async {
      final probe = FakeNetworkProbe(
        connectivityResult: const ConnectivityStatus(
          kind: ConnectivityKind.mobile,
          airplaneMode: false,
        ),
        gatewayReachable: false,
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.connectionGood);
    });

    test('reports captivePortal when a portal is detected', () async {
      final probe = FakeNetworkProbe(
        captiveResult: const CaptivePortalResult.portal('http://login.example'),
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.captivePortal);
    });

    test('reports dnsProblem when raw IPs work but names do not', () async {
      final probe = FakeNetworkProbe(
        captiveResult: const CaptivePortalResult.noInternet(),
        dnsOk: false,
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.dnsProblem);
    });

    test('reports noInternetIsp when nothing outbound is reachable', () async {
      final probe = FakeNetworkProbe(
        captiveResult: const CaptivePortalResult.noInternet(),
        rawReachable: false,
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.noInternetIsp);
    });

    test('reports mobileNoData when a cellular link passes no data', () async {
      final probe = FakeNetworkProbe(
        connectivityResult: const ConnectivityStatus(
          kind: ConnectivityKind.mobile,
          airplaneMode: false,
        ),
        captiveResult: const CaptivePortalResult.noInternet(),
        rawReachable: false,
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.mobileNoData);
    });

    test(
      'reports dnsProblem even when internet 204 works but DNS fails',
      () async {
        final probe = FakeNetworkProbe(dnsOk: false);
        final report = await RunDiagnosis(probe).call();
        expect(report.verdict.category, VerdictCategory.dnsProblem);
      },
    );

    test('reports portBlocked when one port is down among open ones', () async {
      final probe = FakeNetworkProbe(
        ports: const [
          PortProbeResult(port: 443, service: 'HTTPS', reachable: true),
          PortProbeResult(port: 80, service: 'HTTP', reachable: false),
        ],
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.portBlocked);
      expect(report.verdict.detailArg, '80');
    });

    test('a slow but clean link is judged by use case, not by speed', () async {
      // 8 Mbps down / 2 Mbps up with clean latency: plenty for browsing, HD
      // video and calls, short only for the most demanding activities. The old
      // absolute 1.5 Mbps rule judged speed in isolation and reported nothing
      // at all here.
      final probe = FakeNetworkProbe(
        speed: const SpeedResult(downloadMbps: 8, ok: true, uploadMbps: 2),
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.connectionMostlyGood);
      expect(
        report.capability!.supported.map((o) => o.name),
        containsAll(<String>['web browsing', 'HD video (1080p)']),
      );
      expect(report.verdict.title, contains('except'));
    });

    test('degrades to amber when the link is unstable, not slow', () async {
      // Fast, but the walk-outside case: heavy loss and jitter break the
      // real-time activities while raw throughput still looks fine.
      final probe = FakeNetworkProbe(
        quality: const LinkQuality(
          gateway: LatencyStats(sent: 10, rttsMs: [90, 200, 95, 300]),
          internet: LatencyStats(sent: 10, rttsMs: [180, 400, 190, 500]),
        ),
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.connectionDegraded);
      expect(report.solution, isNotNull);
      expect(report.capability, isNotNull);
    });

    test('reports ispPathProblem when traceroute never arrives', () async {
      final probe = FakeNetworkProbe(
        path: const IspPathResult(
          reachedDestination: false,
          lastRespondingHop: '10.20.30.40',
        ),
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.ispPathProblem);
      expect(report.verdict.detailArg, '10.20.30.40');
    });

    test(
      'reports noInternetIsp when every popular site is unreachable',
      () async {
        final probe = FakeNetworkProbe(
          sites: const [
            SiteReachability(host: 'a.com', label: 'A', reachable: false),
            SiteReachability(host: 'b.com', label: 'B', reachable: false),
          ],
        );
        final report = await RunDiagnosis(probe).call();
        expect(report.verdict.category, VerdictCategory.noInternetIsp);
        expect(report.verdict.detail, contains('router'));
      },
    );

    test(
      'reports noInternetIsp with carrier wording, not router wording, '
      'when every popular site is unreachable on mobile data',
      () async {
        final probe = FakeNetworkProbe(
          connectivityResult: const ConnectivityStatus(
            kind: ConnectivityKind.mobile,
            airplaneMode: false,
          ),
          sites: const [
            SiteReachability(host: 'a.com', label: 'A', reachable: false),
            SiteReachability(host: 'b.com', label: 'B', reachable: false),
          ],
        );
        final report = await RunDiagnosis(probe).call();
        expect(report.verdict.category, VerdictCategory.noInternetIsp);
        expect(report.verdict.detail, isNot(contains('router')));
        expect(report.verdict.detail, contains('carrier'));
        expect(report.solution!.message, isNot(contains('router')));
        expect(report.solution!.message, isNot(contains('DSL')));
      },
    );

    test('a healthy connection is reported by what it can do', () async {
      final report = await RunDiagnosis(FakeNetworkProbe()).call();
      expect(report.verdict.category, VerdictCategory.connectionGood);
      expect(report.solution, isNull);
      expect(report.capability!.kind, CapabilityCase.good);
      expect(report.verdict.title, isNot(contains('All clear')));
      expect(report.verdict.title, contains('Wi-Fi'));
      expect(report.log, isNotEmpty);
    });

    test('never shows a capability list on a broken connection', () async {
      final probe = FakeNetworkProbe(gatewayReachable: false);
      final report = await RunDiagnosis(probe).call();
      expect(report.capability, isNull);
    });

    test('logs the medium, the tests performed and the data used', () async {
      final probe = FakeNetworkProbe(
        usage: const DataUsage([
          ProbeRecord(
            test: 'Download speed',
            target: 'speed.cloudflare.com',
            bytesReceived: 6000000,
          ),
          ProbeRecord(
            test: 'Upload speed',
            target: 'speed.cloudflare.com',
            bytesSent: 3000000,
          ),
        ]),
      );
      final report = await RunDiagnosis(probe).call();
      final log = report.log.join('\n');
      expect(log, contains('Tested over: Wi-Fi'));
      expect(log, contains('Tests performed (2)'));
      // Each test names only the direction it moved data in, never "sent 0 B".
      expect(
        log,
        contains('Download speed → speed.cloudflare.com (received 6.0 MB)'),
      );
      expect(
        log,
        contains('Upload speed → speed.cloudflare.com (sent 3.0 MB)'),
      );
      expect(
        log,
        contains(
          'Total data used by this diagnosis: sent 3.0 MB, received 6.0 MB',
        ),
      );
      expect(log, contains('Upload: 20.0 Mbps'));
      expect(log, contains('Internet response time: 16 ms avg'));
    });

    test('states which medium mobile figures came from', () async {
      final probe = FakeNetworkProbe(
        connectivityResult: const ConnectivityStatus(
          kind: ConnectivityKind.mobile,
          airplaneMode: false,
        ),
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.title, contains('mobile data'));
      expect(
        report.log.join('\n'),
        contains('Mobile data was measured because it is the link in use'),
      );
    });

    test('samples idle latency before saturating the link', () async {
      final probe = FakeNetworkProbe();
      await RunDiagnosis(probe).call();
      expect(probe.calls, ['quality', 'throughput']);
    });

    test('compares the busy response time against the idle one', () async {
      final probe = FakeNetworkProbe(
        speed: const SpeedResult(
          downloadMbps: 50,
          ok: true,
          uploadMbps: 20,
          loadedRttMs: 160,
        ),
        quality: const LinkQuality(
          gateway: LatencyStats(sent: 4, rttsMs: [2, 2, 2, 2]),
          internet: LatencyStats(sent: 4, rttsMs: [16, 16, 16, 16]),
        ),
      );
      final report = await RunDiagnosis(probe).call();
      expect(
        report.log.join('\n'),
        contains('Response time while busy: 160 ms (10.0x idle)'),
      );
      // Everything measured still fits, so the verdict stays green: the load
      // figure is reported, not turned into an accusation.
      expect(report.verdict.category, VerdictCategory.connectionGood);
      expect(report.solution, isNull);
    });

    group('fails fast on a hard failure', () {
      test('skips every slow measurement behind a captive portal', () async {
        final probe = FakeNetworkProbe(
          captiveResult: const CaptivePortalResult.portal('http://login.local'),
        );
        final report = await RunDiagnosis(probe).call();
        expect(report.verdict.category, VerdictCategory.captivePortal);
        expect(probe.calls, isEmpty);
        expect(probe.tracePathCount, 0);
        expect(probe.portsCount, 0);
        expect(probe.popularSitesCount, 0);
      });

      test('skips the speed test when the Internet does not answer', () async {
        final probe = FakeNetworkProbe(
          captiveResult: const CaptivePortalResult.noInternet(),
          rawReachable: false,
        );
        final report = await RunDiagnosis(probe).call();
        expect(report.verdict.category, VerdictCategory.noInternetIsp);
        expect(probe.calls, isEmpty);
        expect(probe.portsCount, 0);
        // Nothing answers at IP level either, so there is no route worth
        // tracing: the trace is the slowest probe of all.
        expect(probe.tracePathCount, 0);
      });

      test('traces the route only where it decides the verdict', () async {
        final probe = FakeNetworkProbe(
          captiveResult: const CaptivePortalResult.noInternet(),
          path: const IspPathResult(reachedDestination: false),
        );
        final report = await RunDiagnosis(probe).call();
        expect(report.verdict.category, VerdictCategory.ispPathProblem);
        expect(probe.tracePathCount, 1);
        expect(probe.calls, isEmpty);
      });

      test('still lists the checks it performed', () async {
        final probe = FakeNetworkProbe(
          gatewayReachable: false,
          usage: const DataUsage([
            ProbeRecord(
              test: 'Router latency',
              target: '192.168.1.1',
              bytesSent: 640,
              bytesReceived: 64,
            ),
          ]),
        );
        final report = await RunDiagnosis(probe).call();
        expect(report.log, contains('## Tests performed (1)'));
        expect(
          report.log.join('\n'),
          contains('Total data used by this diagnosis'),
        );
      });
    });

    test('lists what the connection is and is not good for', () async {
      final probe = FakeNetworkProbe(
        speed: const SpeedResult(downloadMbps: 3, ok: true, uploadMbps: 0.4),
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.log, contains('## Good for'));
      expect(report.log, contains('## Not good enough for'));
      // A name in either list already says whether it fits, so no line
      // repeats the answer as a yes/no.
      final lists = report.log
          .skipWhile((l) => l != '## Good for')
          .where((l) => l.startsWith('- '));
      expect(lists.any((l) => l.endsWith(': yes')), isFalse);
      expect(lists.any((l) => l.contains(': no —')), isFalse);
    });

    group('starts each run from a clean technical log', () {
      test('drops the previous run tests before measuring anything', () async {
        final probe = FakeNetworkProbe()
          ..staleUsage = const DataUsage([
            ProbeRecord(
              test: 'Download speed',
              target: 'speed.cloudflare.com',
              bytesReceived: 20000000,
            ),
          ]);
        final report = await RunDiagnosis(probe).call();
        expect(probe.resetUsageCount, 1);
        expect(report.log.join('\n'), isNot(contains('Download speed')));
      });

      test('an early exit cannot inherit an earlier speed test', () async {
        // The reported contradiction: the router never answered, so nothing
        // was downloaded, yet the details listed 20 MB from the run before.
        final probe = FakeNetworkProbe(gatewayReachable: false)
          ..staleUsage = const DataUsage([
            ProbeRecord(
              test: 'Download speed',
              target: 'speed.cloudflare.com',
              bytesReceived: 20000000,
            ),
          ]);
        final report = await RunDiagnosis(probe).call();
        expect(report.verdict.category, VerdictCategory.routerNotResponding);
        final log = report.log.join('\n');
        expect(log, isNot(contains('Download speed')));
        expect(log, isNot(contains('20.0 MB')));
      });

      test('resets again on every repeat run', () async {
        final probe = FakeNetworkProbe();
        final diagnosis = RunDiagnosis(probe);
        await diagnosis.call();
        await diagnosis.call();
        expect(probe.resetUsageCount, 2);
      });
    });

    test('emits ordered phase callbacks', () async {
      final phases = <DiagnosisPhase>[];
      await RunDiagnosis(FakeNetworkProbe()).call(onPhase: phases.add);
      expect(phases.first, DiagnosisPhase.connection);
      expect(phases.last, DiagnosisPhase.done);
    });
  });
}
