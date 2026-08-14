import 'dart:async';

import 'package:simply_internet/features/diagnostics/domain/entities/check_endpoints.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/diagnosis_report.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict_catalog.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/network_probe.dart';

/// Coarse progress phases surfaced to the UI. The individual probes now run
/// concurrently, so the UI only distinguishes "checking the link" from the
/// single comprehensive pass.
enum DiagnosisPhase { connection, running, done }

/// Runs the diagnosis and returns exactly one [DiagnosisReport].
///
/// After a fast local connectivity gate, every network probe is fired off
/// concurrently to minimise total wait time; the gathered facts are then fed
/// through the same ordered, short-circuiting decision tree — device link,
/// router, captive portal, ISP/WAN, DNS, ports, throttling, ISP path — so the
/// verdict categories stay mutually exclusive and deterministic regardless of
/// the order the probes happen to finish in.
class RunDiagnosis {
  const RunDiagnosis(this._probe);

  final NetworkProbe _probe;

  Future<DiagnosisReport> call({
    void Function(DiagnosisPhase phase)? onPhase,
  }) async {
    final log = <String>[];
    void note(String s) => log.add(s);
    void phase(DiagnosisPhase p) => onPhase?.call(p);

    // ── 1. Device link (fast, local gate) ────────────────────────────────
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

    // ── 2. Fire every remaining probe concurrently ───────────────────────
    phase(DiagnosisPhase.running);
    final gatewayMatters =
        conn.kind == ConnectivityKind.wifi ||
        conn.kind == ConnectivityKind.ethernet;

    final captiveF = _probe.checkCaptivePortal();
    final rawF = _anyRawReachable();
    final dnsF = _probe.dnsResolves(kDnsProbeHost);
    final portsF = _probe.probeCommonPorts();
    final speedF = _probe.measureSpeed();
    final pathF = _probe.tracePath(kPathProbeHost);
    final sitesF = _checkPopularSites();

    // Gateway reachability depends on the gateway IP, so resolve it first;
    // the ping still overlaps with all the probes started above.
    final gateway = await _probe.gatewayIp();
    final gwReachableF = (gateway != null && gatewayMatters)
        ? _probe.pingReachable(gateway)
        : Future<bool>.value(true);

    final (
      gwReachable,
      captive,
      rawReachable,
      dnsOk,
      ports,
      speed,
      path,
      siteReport,
    ) = await (
      gwReachableF,
      captiveF,
      rawF,
      dnsF,
      portsF,
      speedF,
      pathF,
      sitesF,
    ).wait;

    // ── 3. Evaluate the ordered decision tree over the gathered facts ─────
    note('Gateway: ${gateway ?? "unknown"}');
    if (gateway != null && gatewayMatters) {
      note('Gateway reachable: $gwReachable');
      if (!gwReachable) {
        return _report(VerdictCatalog.routerNotResponding(gateway), log);
      }
    }

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
      note('Raw IP reachable: $rawReachable');
      if (rawReachable) {
        note('DNS resolves $kDnsProbeHost: $dnsOk');
        if (!dnsOk) {
          return _report(VerdictCatalog.dnsProblem(), log);
        }
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

    // Internet works at IP/HTTP level from here on.
    note('DNS resolves $kDnsProbeHost: $dnsOk');
    if (!dnsOk) {
      return _report(VerdictCatalog.dnsProblem(), log);
    }

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

    note('Download: ${speed.ok ? "${speed.downloadMbps} Mbps" : "n/a"}');
    if (speed.ok && speed.downloadMbps < kThrottleSuspicionMbps) {
      return _report(VerdictCatalog.trafficShaping(speed.downloadMbps), log);
    }

    note(
      'Path reached destination: ${path.reachedDestination} '
      '(last hop: ${path.lastRespondingHop ?? "n/a"})',
    );
    if (!path.reachedDestination) {
      return _report(VerdictCatalog.ispPathProblem(path), log);
    }

    note('Country: ${siteReport.country ?? "unknown"}');
    final sites = siteReport.sites;
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

  Future<bool> _anyRawReachable() async {
    final probes = kRawReachabilityTargets
        .map((t) => _probe.tcpReachable(t.ip, t.port))
        .toList();
    final outcomes = await Future.wait(probes);
    return outcomes.any((ok) => ok);
  }

  Future<({String? country, List<SiteReachability> sites})>
  _checkPopularSites() async {
    final country = await _probe.detectCountryCode();
    final sites = await _probe.checkPopularSites(country);
    return (country: country, sites: sites);
  }

  DiagnosisReport _report(
    ({Verdict verdict, Solution solution}) r,
    List<String> log,
  ) {
    return DiagnosisReport(verdict: r.verdict, solution: r.solution, log: log);
  }
}
