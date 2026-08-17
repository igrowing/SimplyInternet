import 'dart:async';

import 'package:simply_internet/features/diagnostics/domain/entities/capability.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/check_endpoints.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/data_usage.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/diagnosis_report.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/link_quality.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict_catalog.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/network_probe.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/assess_capability.dart';

/// Coarse progress phases surfaced to the UI. The individual probes now run
/// concurrently, so the UI only distinguishes "checking the link" from the
/// single comprehensive pass.
enum DiagnosisPhase { connection, running, done }

/// Runs the diagnosis and returns exactly one [DiagnosisReport].
///
/// The probes run in two concurrent waves. The first wave is the reachability
/// gate — router, captive portal, raw IP, DNS — which is nearly instant on a
/// working link; the slow measurements (route trace, throughput, latency
/// samples, popular sites) only start once that gate has been passed. That
/// ordering is what makes a dead WAN or a captive portal report in seconds:
/// running everything at once meant the user waited for the longest timeout in
/// the set to expire before hearing a verdict that was already decided.
///
/// Within each wave the probes are concurrent, and the gathered facts are fed
/// through the same ordered, short-circuiting decision tree — device link,
/// router, captive portal, ISP/WAN, DNS, ports, ISP path — so the verdict
/// categories stay mutually exclusive and deterministic regardless of the order
/// the probes happen to finish in.
///
/// When that tree finds nothing broken the connection is not declared "all
/// clear": the measured throughput, latency, jitter and packet loss are matched
/// against what everyday activities need, because a link can be perfectly
/// connected and still be unusable for a video call.
///
/// Mobile-data policy: every probe runs over the link the device is already
/// using and the diagnosis never switches the medium itself. Mobile data is
/// therefore only measured when Wi-Fi is not connected, or after the user has
/// deliberately switched to it to repeat the test.
class RunDiagnosis {
  const RunDiagnosis(this._probe, [this._assess = const AssessCapability()]);

  final NetworkProbe _probe;
  final AssessCapability _assess;

  Future<DiagnosisReport> call({
    void Function(DiagnosisPhase phase)? onPhase,
  }) async {
    // The probe is a singleton that outlives one run, so the checks it recorded
    // last time are dropped before anything new is measured. Every report then
    // describes only its own run: an early exit at "the router is not
    // responding" can no longer list a speed test that never ran this time.
    _probe.resetUsage();

    // The log uses a small Markdown subset (`## heading`, `- item`, `  - item`
    // for a detail belonging to the line above) that the Technical details
    // view renders and copies verbatim.
    final log = <String>[];
    void note(String s) => log.add('- $s');
    void sub(String s) => log.add('  - $s');
    void head(String s) {
      if (log.isNotEmpty) log.add('');
      log.add('## $s');
    }

    void phase(DiagnosisPhase p) => onPhase?.call(p);

    // Every exit, including the early ones, lists what actually ran: a
    // diagnosis that stopped at "no Internet" still performed several checks,
    // and empty technical details make it look as if it did nothing.
    DiagnosisReport report(({Verdict verdict, Solution solution}) r) {
      _noteTests(note, head, _probe.dataUsage());
      return DiagnosisReport(
        verdict: r.verdict,
        solution: r.solution,
        log: log,
      );
    }

    // ── 1. Device link (fast, local gate) ────────────────────────────────
    phase(DiagnosisPhase.connection);
    head('Device link');
    final conn = await _probe.connectivity();
    note(
      'Connectivity: ${conn.kind.name}, '
      'flight mode: ${conn.airplaneMode ? "on ✈️" : "off ✅"}',
    );
    if (conn.airplaneMode) {
      return report(VerdictCatalog.notConnected(airplane: true));
    }
    if (!conn.hasLink) {
      return report(VerdictCatalog.notConnected(airplane: false));
    }

    // ── 2. First wave: the reachability gate ─────────────────────────────
    phase(DiagnosisPhase.running);
    final gatewayMatters =
        conn.kind == ConnectivityKind.wifi ||
        conn.kind == ConnectivityKind.ethernet;

    final captiveF = _probe.checkCaptivePortal();
    final rawF = _anyRawReachable();
    final dnsF = _probe.dnsResolves(kDnsProbeHost);

    // Gateway reachability depends on the gateway IP, so resolve it first;
    // the ping still overlaps with all the probes started above.
    final gateway = await _probe.gatewayIp();
    final gwReachableF = (gateway != null && gatewayMatters)
        ? _probe.pingReachable(gateway)
        : Future<bool>.value(true);

    final (gwReachable, captive, rawReachable, dnsOk) = await (
      gwReachableF,
      captiveF,
      rawF,
      dnsF,
    ).wait;

    // ── 3. Evaluate the ordered decision tree over the gathered facts ─────
    head('Router');
    note('Gateway: ${gateway ?? "unknown"}');
    if (gateway != null && gatewayMatters) {
      note('Gateway reachable: ${_yesNo(gwReachable)}');
      if (!gwReachable) {
        return report(VerdictCatalog.routerNotResponding(gateway));
      }
    }

    head('Internet reachability');
    note('Internet: ${captive.internetOk ? "reachable ✅" : "no answer ❌"}');
    sub('Captive sign-in page: ${_yesNo(captive.portalDetected)}');
    if (captive.portalDetected) {
      return report(VerdictCatalog.captivePortal(captive.portalUrl));
    }

    if (!captive.internetOk) {
      // The 204 endpoints did not confirm Internet. Decide between a DNS
      // fault, an ISP path fault and a plain WAN outage using raw IP probes.
      sub('Raw IP address reachable: ${_yesNo(rawReachable)}');
      if (rawReachable) {
        sub('Name resolves ($kDnsProbeHost): ${_yesNo(dnsOk)}');
        if (!dnsOk) {
          return report(VerdictCatalog.dnsProblem());
        }
        // Traced only here, where the answer decides between an ISP path
        // fault and a plain outage: it is the slowest check there is, and on
        // a working link nothing depends on it.
        final path = await _probe.tracePath(kPathProbeHost);
        sub('Route reached the Internet: ${_yesNo(path.reachedDestination)}');
        if (!path.reachedDestination) {
          return report(VerdictCatalog.ispPathProblem(path));
        }
      }
      // On a cellular link there is no router/ISP line to blame: a dead data
      // path means the mobile data itself is not passing traffic (roaming
      // off, no allowance, carrier outage) rather than a home ISP outage.
      if (conn.kind == ConnectivityKind.mobile) {
        return report(
          VerdictCatalog.mobileDataNoInternet(
            signalWeak: conn.mobileSignalWeak,
            signalGood: conn.mobileSignalGood,
          ),
        );
      }
      return report(VerdictCatalog.noInternetIsp());
    }

    // Internet works at IP/HTTP level from here on.
    sub('Name resolves ($kDnsProbeHost): ${_yesNo(dnsOk)}');
    if (!dnsOk) {
      return report(VerdictCatalog.dnsProblem());
    }

    // ── 4. Second wave: measurements, only now that the link is usable ────
    final portsF = _probe.probeCommonPorts();
    final pathF = _probe.tracePath(kPathProbeHost);
    final sitesF = _checkPopularSites();
    // Kept separate from the reachability ping above on purpose: that one falls
    // back to a TCP handshake so an ICMP-filtering router is not accused of
    // being dead, while these samples must stay pure ICMP to mean anything as
    // latency, jitter and loss.
    final qualityF = _probe.measureLinkQuality(
      gatewayIp: gatewayMatters ? gateway : null,
    );
    // The throughput test deliberately starts only once the idle samples are
    // in: saturating the link first would inflate the very baseline the
    // under-load figure is compared against. Both still overlap the port,
    // route and popular-site probes, so no wall-clock time is added.
    final speedF = qualityF.then((_) => _probe.measureThroughput());

    final (ports, speed, path, siteReport, quality) = await (
      portsF,
      speedF,
      pathF,
      sitesF,
      qualityF,
    ).wait;
    final linkQuality = quality.withLoadedRtt(speed.loadedRttMs);

    head('Ports');
    for (final p in ports) {
      note(
        'Port ${p.port}/${p.service}: '
        '${p.reachable ? "open ✅" : "blocked ❌"}',
      );
    }
    final anyOpen = ports.any((p) => p.reachable);
    final blocked = ports.where((p) => !p.reachable).toList();
    if (anyOpen && blocked.isNotEmpty) {
      return report(VerdictCatalog.portBlocked(blocked.first));
    }

    note(
      'Route reached the Internet: ${_yesNo(path.reachedDestination)} '
      '(last hop: ${path.lastRespondingHop ?? "n/a"})',
    );
    if (!path.reachedDestination) {
      return report(VerdictCatalog.ispPathProblem(path));
    }

    head('Popular sites');
    note('Country: ${siteReport.country ?? "unknown"}');
    final sites = siteReport.sites;
    final reachable = sites.where((s) => s.reachable).length;
    final allSitesOk = sites.isNotEmpty && reachable == sites.length;
    note(
      'Popular sites reachable: $reachable/${sites.length} '
      '${allSitesOk ? "✅" : "⚠️"}',
    );
    if (sites.isNotEmpty && reachable == 0) {
      // Every real destination failed although the anycast checks passed —
      // treat as an ISP/WAN content-path outage rather than "all clear".
      return report(VerdictCatalog.noInternetIsp());
    }

    // ── 5. Nothing is broken: judge what the connection can actually do ───
    final capability = _assess(speed: speed, quality: linkQuality);
    _noteQuality(note, head, conn, speed, linkQuality, capability);
    _noteTests(note, head, _probe.dataUsage());

    final outcome = VerdictCatalog.capability(
      assessment: capability,
      medium: conn.kind,
      speed: speed,
      quality: linkQuality,
    );

    phase(DiagnosisPhase.done);
    return DiagnosisReport(
      verdict: outcome.verdict,
      solution: outcome.solution,
      capability: capability,
      log: log,
    );
  }

  /// Writes the measured figures into the technical log, saying which medium
  /// they came from and which activities they do or do not support.
  void _noteQuality(
    void Function(String) note,
    void Function(String) head,
    ConnectivityStatus conn,
    SpeedResult speed,
    LinkQuality quality,
    CapabilityAssessment capability,
  ) {
    final medium = VerdictCatalog.mediumLabel(conn.kind);
    head('Measurements');
    note('Tested over: $medium');
    if (conn.kind == ConnectivityKind.mobile) {
      note(
        'Mobile data was measured because it is the link in use '
        '(Wi-Fi not connected, or you chose to retest over mobile)',
      );
      final level = conn.mobileSignalLevel;
      note(
        'Cellular signal: '
        '${level == null ? "not reported" : "$level of 4"}',
      );
    }
    final down = speed.ok
        ? '${speed.downloadMbps.toStringAsFixed(1)} Mbps'
        : 'not measured';
    final up = speed.uploadMbps == null
        ? 'not measured'
        : '${speed.uploadMbps!.toStringAsFixed(1)} Mbps';
    note('Download: $down');
    note('Upload: $up');
    // Printed next to the rates so the figures here and the totals in "Tests
    // performed" can be checked against each other.
    note(
      'Moved by the speed test: '
      'received ${DataUsage.formatBytes(speed.bytesReceived)}, '
      'sent ${DataUsage.formatBytes(speed.bytesSent)}',
    );
    _noteLatency(note, 'Router', quality.gateway);
    _noteLatency(note, 'Internet', quality.internet);
    final loaded = speed.loadedRttMs;
    if (loaded != null) {
      final ratio = quality.bufferbloatRatio;
      note(
        'Response time while busy: ${loaded.round()} ms'
        '${ratio == null ? "" : " (${ratio.toStringAsFixed(1)}x idle)"}',
      );
    }
    // Two plain lists rather than one list of yes/no answers: a name under
    // "Good for" already says it fits, and the reason only matters for the
    // activities that do not.
    final supported = capability.supported;
    if (supported.isNotEmpty) {
      head('Good for');
      for (final outcome in supported) {
        note(outcome.name);
      }
    }
    final unsupported = capability.unsupported;
    if (unsupported.isNotEmpty) {
      head('Not good enough for');
      for (final outcome in unsupported) {
        final short = outcome.shortfalls.map((s) => s.text).join(', ');
        note('${outcome.name} — $short');
      }
    }
  }

  static String _yesNo(bool value) => value ? 'yes ✅' : 'no ❌';

  void _noteLatency(
    void Function(String) note,
    String label,
    LatencyStats stats,
  ) {
    if (!stats.ok) {
      note('$label response time: no reply to ${stats.sent} probes');
      return;
    }
    note(
      '$label response time: ${stats.avgMs!.round()} ms avg '
      '(min ${stats.minMs!.round()}, max ${stats.maxMs!.round()}), '
      'jitter ${stats.jitterMs?.round() ?? "n/a"} ms, '
      'loss ${stats.lossPercent!.round()}% '
      '(${stats.received}/${stats.sent} replies)',
    );
  }

  /// Lists exactly which tests ran and what they cost in data.
  void _noteTests(
    void Function(String) note,
    void Function(String) head,
    DataUsage usage,
  ) {
    if (usage.records.isEmpty) return;
    head('Tests performed (${usage.records.length})');
    for (final r in usage.records) {
      final traffic = _formatTraffic(r.bytesSent, r.bytesReceived);
      note('${r.test} → ${r.target}${traffic.isEmpty ? "" : " ($traffic)"}');
    }
    final total = _formatTraffic(usage.bytesSent, usage.bytesReceived);
    if (total.isNotEmpty) {
      note('Total data used by this diagnosis: $total');
      // Says what the total covers: it is the sum of every test above, so it
      // is legitimately larger than the speed test figures alone.
      note('That total covers every test above, not only the speed test');
    }
  }

  /// "sent 1.2 kB, received 3 kB", dropping either half when it is zero so
  /// tests that only send or only receive don't read as "received 0 B".
  String _formatTraffic(int bytesSent, int bytesReceived) {
    final parts = [
      if (bytesSent > 0) 'sent ${DataUsage.formatBytes(bytesSent)}',
      if (bytesReceived > 0) 'received ${DataUsage.formatBytes(bytesReceived)}',
    ];
    return parts.join(', ');
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
}
