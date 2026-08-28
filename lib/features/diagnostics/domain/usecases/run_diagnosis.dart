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
import 'package:simply_internet/l10n/app_localizations.dart';
import 'package:simply_internet/l10n/app_localizations_en.dart';

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
///
/// Every user-facing string in the verdict and the technical log is resolved
/// from [AppLocalizations]; when [call] is invoked without one it falls back to
/// English so the pure decision-tree tests need no localization setup.
class RunDiagnosis {
  const RunDiagnosis(this._probe, [this._assess = const AssessCapability()]);

  final NetworkProbe _probe;
  final AssessCapability _assess;

  Future<DiagnosisReport> call({
    void Function(DiagnosisPhase phase)? onPhase,
    AppLocalizations? l10n,
  }) async {
    final loc = l10n ?? AppLocalizationsEn();

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
      _noteTests(loc, note, head, _probe.dataUsage());
      return DiagnosisReport(
        verdict: r.verdict,
        solution: r.solution,
        log: log,
      );
    }

    // ── 1. Device link (fast, local gate) ────────────────────────────────
    phase(DiagnosisPhase.connection);
    head(loc.logHeadDeviceLink);
    final conn = await _probe.connectivity();
    note(
      loc.logConnectivity(
        conn.kind.name,
        conn.airplaneMode ? loc.logFlightOn : loc.logFlightOff,
      ),
    );
    if (conn.airplaneMode) {
      return report(VerdictCatalog.notConnected(loc, airplane: true));
    }
    if (!conn.hasLink) {
      return report(VerdictCatalog.notConnected(loc, airplane: false));
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
    head(loc.logHeadRouter);
    note(loc.logGateway(gateway ?? loc.logUnknown));
    if (gateway != null && gatewayMatters) {
      note(loc.logGatewayReachable(_yesNo(loc, gwReachable)));
      if (!gwReachable) {
        return report(VerdictCatalog.routerNotResponding(loc, gateway));
      }
    }

    head(loc.logHeadInternetReachability);
    note(
      loc.logInternet(
        captive.internetOk
            ? loc.logInternetReachableYes
            : loc.logInternetReachableNo,
      ),
    );
    sub(
      loc.logCaptiveSignIn(
        _yesNo(loc, captive.portalDetected, goodWhenTrue: false),
      ),
    );
    if (captive.portalDetected) {
      return report(VerdictCatalog.captivePortal(loc, captive.portalUrl));
    }

    if (!captive.internetOk) {
      // The 204 endpoints did not confirm Internet. Decide between a DNS
      // fault, an ISP path fault and a plain WAN outage using raw IP probes.
      sub(loc.logRawIpReachable(_yesNo(loc, rawReachable)));
      if (rawReachable) {
        sub(loc.logNameResolves(kDnsProbeHost, _yesNo(loc, dnsOk)));
        if (!dnsOk) {
          return report(VerdictCatalog.dnsProblem(loc, medium: conn.kind));
        }
        // Traced only here, where the answer decides between an ISP path
        // fault and a plain outage: it is the slowest check there is, and on
        // a working link nothing depends on it.
        final path = await _probe.tracePath(kPathProbeHost);
        sub(loc.logRouteReached(_yesNo(loc, path.reachedDestination)));
        if (!path.reachedDestination) {
          return report(
            VerdictCatalog.ispPathProblem(loc, path, medium: conn.kind),
          );
        }
      }
      // On a cellular link there is no router/ISP line to blame: a dead data
      // path means the mobile data itself is not passing traffic (roaming
      // off, no allowance, carrier outage) rather than a home ISP outage.
      if (conn.kind == ConnectivityKind.mobile) {
        return report(
          VerdictCatalog.mobileDataNoInternet(
            loc,
            signalWeak: conn.mobileSignalWeak,
            signalGood: conn.mobileSignalGood,
          ),
        );
      }
      return report(VerdictCatalog.noInternetIsp(loc, medium: conn.kind));
    }

    // Internet works at IP/HTTP level from here on.
    sub(loc.logNameResolves(kDnsProbeHost, _yesNo(loc, dnsOk)));
    if (!dnsOk) {
      return report(VerdictCatalog.dnsProblem(loc, medium: conn.kind));
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

    head(loc.logHeadPorts);
    for (final p in ports) {
      note(
        loc.logPortLine(
          p.port,
          p.service,
          p.reachable ? loc.logPortOpen : loc.logPortBlocked,
        ),
      );
    }
    final anyOpen = ports.any((p) => p.reachable);
    final blocked = ports.where((p) => !p.reachable).toList();
    if (anyOpen && blocked.isNotEmpty) {
      return report(
        VerdictCatalog.portBlocked(loc, blocked.first, medium: conn.kind),
      );
    }

    note(
      loc.logRouteReachedHop(
        _yesNo(loc, path.reachedDestination),
        path.lastRespondingHop ?? loc.logNotApplicable,
      ),
    );
    if (!path.reachedDestination) {
      return report(
        VerdictCatalog.ispPathProblem(loc, path, medium: conn.kind),
      );
    }

    head(loc.logHeadPopularSites);
    note(loc.logPopularCountry(siteReport.country ?? loc.logUnknown));
    final sites = siteReport.sites;
    final reachable = sites.where((s) => s.reachable).length;
    final allSitesOk = sites.isNotEmpty && reachable == sites.length;
    note(
      loc.logPopularReachable(
        reachable,
        sites.length,
        allSitesOk ? '✅' : '⚠️',
      ),
    );
    if (sites.isNotEmpty && reachable == 0) {
      // Every real destination failed although the anycast checks passed —
      // treat as an ISP/WAN content-path outage rather than "all clear".
      return report(VerdictCatalog.noInternetIsp(loc, medium: conn.kind));
    }

    // ── 5. Nothing is broken: judge what the connection can actually do ───
    final capability = _assess(
      speed: speed,
      quality: linkQuality,
      l10n: loc,
    );
    _noteQuality(loc, note, head, conn, speed, linkQuality, capability);
    _noteTests(loc, note, head, _probe.dataUsage());

    final outcome = VerdictCatalog.capability(
      loc,
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
    AppLocalizations l10n,
    void Function(String) note,
    void Function(String) head,
    ConnectivityStatus conn,
    SpeedResult speed,
    LinkQuality quality,
    CapabilityAssessment capability,
  ) {
    final medium = VerdictCatalog.mediumLabel(l10n, conn.kind);
    head(l10n.logHeadMeasurements);
    note(l10n.logTestedOver(medium));
    if (conn.kind == ConnectivityKind.mobile) {
      note(l10n.logMobileMeasuredReason);
      final level = conn.mobileSignalLevel;
      note(
        level == null
            ? l10n.logCellularSignalMissing
            : l10n.logCellularSignalReported(level),
      );
    }
    final down = speed.ok
        ? l10n.logMbps(speed.downloadMbps.toStringAsFixed(1))
        : l10n.logNotMeasured;
    final up = speed.uploadMbps == null
        ? l10n.logNotMeasured
        : l10n.logMbps(speed.uploadMbps!.toStringAsFixed(1));
    note(l10n.logDownloadLine(down));
    note(l10n.logUploadLine(up));
    // Printed next to the rates so the figures here and the totals in "Tests
    // performed" can be checked against each other.
    note(
      l10n.logSpeedTestMoved(
        DataUsage.formatBytes(speed.bytesReceived),
        DataUsage.formatBytes(speed.bytesSent),
      ),
    );
    _noteLatency(l10n, note, l10n.logLabelRouter, quality.gateway);
    _noteLatency(l10n, note, l10n.logLabelInternet, quality.internet);
    final loaded = speed.loadedRttMs;
    if (loaded != null) {
      final ratio = quality.bufferbloatRatio;
      note(
        ratio == null
            ? l10n.logResponseWhileBusy(loaded.round())
            : l10n.logResponseWhileBusyRatio(
                loaded.round(),
                ratio.toStringAsFixed(1),
              ),
      );
    }
    // Two plain lists rather than one list of yes/no answers: a name under
    // "Good for" already says it fits, and the reason only matters for the
    // activities that do not.
    final supported = capability.supported;
    if (supported.isNotEmpty) {
      head(l10n.logHeadGoodFor);
      for (final outcome in supported) {
        note(l10n.useCaseName(outcome.id.name));
      }
    }
    final unsupported = capability.unsupported;
    if (unsupported.isNotEmpty) {
      head(l10n.logHeadNotGoodFor);
      for (final outcome in unsupported) {
        final short = outcome.shortfalls.map((s) => s.text).join(', ');
        note(l10n.logNotGoodForItem(l10n.useCaseName(outcome.id.name), short));
      }
    }
  }

  /// A yes/no answer with the mark on the *healthy* outcome rather than the
  /// affirmative one. Most answers here are good news when they are "yes", but
  /// a captive sign-in page is the opposite: finding one is the problem, so
  /// "no ❌" would tell the user their working connection had failed a check.
  static String _yesNo(
    AppLocalizations l10n,
    bool value, {
    bool goodWhenTrue = true,
  }) =>
      '${value ? l10n.logYes : l10n.logNo} '
      '${value == goodWhenTrue ? "✅" : "❌"}';

  void _noteLatency(
    AppLocalizations l10n,
    void Function(String) note,
    String label,
    LatencyStats stats,
  ) {
    if (!stats.ok) {
      note(l10n.logLatencyNoReply(label, stats.sent));
      return;
    }
    note(
      l10n.logLatencyLine(
        label,
        stats.avgMs!.round(),
        stats.minMs!.round(),
        stats.maxMs!.round(),
        stats.jitterMs?.round().toString() ?? l10n.logNotApplicable,
        stats.lossPercent!.round(),
        stats.received,
        stats.sent,
      ),
    );
  }

  /// Lists exactly which tests ran and what they cost in data.
  void _noteTests(
    AppLocalizations l10n,
    void Function(String) note,
    void Function(String) head,
    DataUsage usage,
  ) {
    if (usage.records.isEmpty) return;
    head(l10n.logHeadTestsPerformed(usage.records.length));
    for (final r in usage.records) {
      final traffic = _formatTraffic(l10n, r.bytesSent, r.bytesReceived);
      note(
        l10n.logTestRecord(
          _localizedTestName(l10n, r.test),
          r.target,
          traffic.isEmpty ? '' : ' ($traffic)',
        ),
      );
    }
    final total = _formatTraffic(l10n, usage.bytesSent, usage.bytesReceived);
    if (total.isNotEmpty) {
      note(l10n.logTotalData(total));
      // Says what the total covers: it is the sum of every test above, so it
      // is legitimately larger than the speed test figures alone.
      note(l10n.logTotalCovers);
    }
  }

  /// Localizes the probe label recorded by the data layer. `ProbeRecord.test`
  /// is written in English there (it doubles as a stable key), so the
  /// transparency list is translated here, at the point it is turned into a
  /// log line, the same way every other line under this heading is. An
  /// unrecognised label — currently just the per-port checks, whose text is
  /// `Port 443/HTTPS` and already language-neutral — is passed through as-is.
  static String _localizedTestName(AppLocalizations l10n, String test) {
    switch (test) {
      case 'DNS resolution':
        return l10n.probeDnsResolution;
      case 'Internet / captive-portal check':
        return l10n.probeCaptivePortalCheck;
      case 'Route to the Internet (traceroute)':
        return l10n.probeRouteToInternet;
      case 'Country detection':
        return l10n.probeCountryDetection;
      case 'Router latency':
        return l10n.probeRouterLatency;
      case 'Internet latency':
        return l10n.probeInternetLatency;
      case 'Response time while the line is busy':
        return l10n.probeResponseWhileBusy;
      case 'Download speed':
        return l10n.probeDownloadSpeed;
      case 'Upload speed':
        return l10n.probeUploadSpeed;
    }
    final popular = RegExp(
      r'^Popular sites reachability \((\d+)\)$',
    ).firstMatch(test);
    if (popular != null) {
      return l10n.probePopularSitesReachability(int.parse(popular.group(1)!));
    }
    return test;
  }

  /// "sent 1.2 kB, received 3 kB", dropping either half when it is zero so
  /// tests that only send or only receive don't read as "received 0 B".
  String _formatTraffic(
    AppLocalizations l10n,
    int bytesSent,
    int bytesReceived,
  ) {
    final parts = [
      if (bytesSent > 0) l10n.logTrafficSent(DataUsage.formatBytes(bytesSent)),
      if (bytesReceived > 0)
        l10n.logTrafficReceived(DataUsage.formatBytes(bytesReceived)),
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
