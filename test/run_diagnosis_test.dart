import 'package:flutter_test/flutter_test.dart';
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
      expect(report.verdict.category, VerdictCategory.allClear);
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

    test('reports trafficShaping when speed is suspiciously low', () async {
      final probe = FakeNetworkProbe(
        speed: const SpeedResult(downloadMbps: 0.4, ok: true),
      );
      final report = await RunDiagnosis(probe).call();
      expect(report.verdict.category, VerdictCategory.trafficShaping);
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
      },
    );

    test('reports allClear on a healthy connection', () async {
      final report = await RunDiagnosis(FakeNetworkProbe()).call();
      expect(report.verdict.category, VerdictCategory.allClear);
      expect(report.solution, isNull);
      expect(report.log, isNotEmpty);
    });

    test('emits ordered phase callbacks', () async {
      final phases = <DiagnosisPhase>[];
      await RunDiagnosis(FakeNetworkProbe()).call(onPhase: phases.add);
      expect(phases.first, DiagnosisPhase.connection);
      expect(phases.last, DiagnosisPhase.done);
    });
  });
}
