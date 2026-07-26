import 'package:simply_internet/features/diagnostics/domain/entities/check_endpoints.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/diagnosis_report.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict_catalog.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/network_probe.dart';

/// Progress phases surfaced to the UI while the diagnosis runs.
enum DiagnosisPhase {
  connection,
  router,
  internet,
  dns,
  ports,
  speed,
  path,
  sites,
  done,
}

/// Human-readable label for a [DiagnosisPhase].
String diagnosisPhaseLabel(DiagnosisPhase phase) {
  switch (phase) {
    case DiagnosisPhase.connection:
      return 'Checking your connection…';
    case DiagnosisPhase.router:
      return 'Checking your router…';
    case DiagnosisPhase.internet:
      return 'Checking Internet access…';
    case DiagnosisPhase.dns:
      return 'Checking name resolution (DNS)…';
    case DiagnosisPhase.ports:
      return 'Checking for blocked ports…';
    case DiagnosisPhase.speed:
      return 'Measuring speed…';
    case DiagnosisPhase.path:
      return 'Tracing the route to the Internet…';
    case DiagnosisPhase.sites:
      return 'Checking popular websites…';
    case DiagnosisPhase.done:
      return 'Done';
  }
}

/// Runs the ordered, short-circuiting diagnosis and returns exactly one
/// [DiagnosisReport]. The ordering — device link, router, captive portal,
/// ISP/WAN, DNS, ports, throttling, ISP path — guarantees the verdict
/// categories stay mutually exclusive: each check only runs when all the
/// checks "closer" to the device have already passed.
class RunDiagnosis {
  const RunDiagnosis(this._probe);

  final NetworkProbe _probe;

  Future<DiagnosisReport> call({
    void Function(DiagnosisPhase phase)? onPhase,
  }) async {
    final log = <String>[];
    void note(String s) => log.add(s);
    void phase(DiagnosisPhase p) => onPhase?.call(p);

    // ── 1. Device link ───────────────────────────────────────────────────
    phase(DiagnosisPhase.connection);
    final conn = await _probe.connectivity();
    note(
      'Connectivity: ${conn.kind.name}, '
      'flight mode: ${conn.airplaneMode ? "on" : "off"}',
    );
    if (conn.airplaneMode) {
      return _report(VerdictCatalog.notConnected(airplane: true), log);
    }
    if (!conn.hasLink) {
      return _report(VerdictCatalog.notConnected(airplane: false), log);
    }

    // ── 2. Router / gateway ──────────────────────────────────────────────
    phase(DiagnosisPhase.router);
    final gateway = await _probe.gatewayIp();
    note('Gateway: ${gateway ?? "unknown"}');
    final gatewayMatters =
        conn.kind == ConnectivityKind.wifi ||
        conn.kind == ConnectivityKind.ethernet;
    if (gateway != null && gatewayMatters) {
      final gwOk = await _probe.pingReachable(gateway);
      note('Gateway reachable: $gwOk');
      if (!gwOk) {
        return _report(VerdictCatalog.routerNotResponding(gateway), log);
      }
    }

    // ── 3. Internet access / captive portal ──────────────────────────────
    phase(DiagnosisPhase.internet);
    final captive = await _probe.checkCaptivePortal();
    note(
      'Captive check: internetOk=${captive.internetOk}, '
      'portal=${captive.portalDetected}',
    );
    if (captive.portalDetected) {
      return _report(VerdictCatalog.captivePortal(captive.portalUrl), log);
    }

    if (!captive.internetOk) {
      // The 204 endpoints did not confirm Internet. Decide between a DNS
      // fault, an ISP path fault and a plain WAN outage using raw IP probes.
      final rawOk = await _anyRawReachable(note);
      note('Raw IP reachable: $rawOk');
      if (rawOk) {
        phase(DiagnosisPhase.dns);
        final dnsOk = await _probe.dnsResolves(kDnsProbeHost);
        note('DNS resolves $kDnsProbeHost: $dnsOk');
        if (!dnsOk) {
          return _report(VerdictCatalog.dnsProblem(), log);
        }
        phase(DiagnosisPhase.path);
        final path = await _probe.tracePath(kPathProbeHost);
        note('Path reached destination: ${path.reachedDestination}');
        if (!path.reachedDestination) {
          return _report(VerdictCatalog.ispPathProblem(path), log);
        }
      }
      // On a cellular link there is no router/ISP line to blame: a dead data
      // path means the mobile data itself is not passing traffic (roaming
      // off, no allowance, carrier outage) rather than a home ISP outage.
      if (conn.kind == ConnectivityKind.mobile) {
        return _report(VerdictCatalog.mobileDataNoInternet(), log);
      }
      return _report(VerdictCatalog.noInternetIsp(), log);
    }

    // ── 4. DNS (internet works at IP/HTTP level) ─────────────────────────
    phase(DiagnosisPhase.dns);
    final dnsOk = await _probe.dnsResolves(kDnsProbeHost);
    note('DNS resolves $kDnsProbeHost: $dnsOk');
    if (!dnsOk) {
      return _report(VerdictCatalog.dnsProblem(), log);
    }

    // ── 5. Blocked ports ─────────────────────────────────────────────────
    phase(DiagnosisPhase.ports);
    final ports = await _probe.probeCommonPorts();
    for (final p in ports) {
      note(
        'Port ${p.port}/${p.service}: '
        '${p.reachable ? "open" : "blocked"}',
      );
    }
    final anyOpen = ports.any((p) => p.reachable);
    final blocked = ports.where((p) => !p.reachable).toList();
    if (anyOpen && blocked.isNotEmpty) {
      return _report(VerdictCatalog.portBlocked(blocked.first), log);
    }

    // ── 6. Throttling / shaping (flagged as *possible*) ──────────────────
    phase(DiagnosisPhase.speed);
    final speed = await _probe.measureSpeed();
    note('Download: ${speed.ok ? "${speed.downloadMbps} Mbps" : "n/a"}');
    if (speed.ok && speed.downloadMbps < kThrottleSuspicionMbps) {
      return _report(VerdictCatalog.trafficShaping(speed.downloadMbps), log);
    }

    // ── 7. ISP path ──────────────────────────────────────────────────────
    phase(DiagnosisPhase.path);
    final path = await _probe.tracePath(kPathProbeHost);
    note(
      'Path reached destination: ${path.reachedDestination} '
      '(last hop: ${path.lastRespondingHop ?? "n/a"})',
    );
    if (!path.reachedDestination) {
      return _report(VerdictCatalog.ispPathProblem(path), log);
    }

    // ── 8. Popular-site reachability (enrichment) ────────────────────────
    phase(DiagnosisPhase.sites);
    final country = await _probe.detectCountryCode();
    note('Country: ${country ?? "unknown"}');
    final sites = await _probe.checkPopularSites(country);
    final reachable = sites.where((s) => s.reachable).length;
    note('Popular sites reachable: $reachable/${sites.length}');
    if (sites.isNotEmpty && reachable == 0) {
      // Every real destination failed although the anycast checks passed —
      // treat as an ISP/WAN content-path outage rather than "all clear".
      return _report(VerdictCatalog.noInternetIsp(), log);
    }

    phase(DiagnosisPhase.done);
    return DiagnosisReport(verdict: VerdictCatalog.allClear(), log: log);
  }

  Future<bool> _anyRawReachable(void Function(String) note) async {
    for (final t in kRawReachabilityTargets) {
      final ok = await _probe.tcpReachable(t.ip, t.port);
      note('TCP ${t.ip}:${t.port}: $ok');
      if (ok) return true;
    }
    return false;
  }

  DiagnosisReport _report(
    ({Verdict verdict, Solution solution}) r,
    List<String> log,
  ) {
    return DiagnosisReport(verdict: r.verdict, solution: r.solution, log: log);
  }
}
