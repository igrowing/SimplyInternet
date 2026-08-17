import 'package:simply_internet/features/diagnostics/domain/entities/data_usage.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/link_quality.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';

/// Abstraction over every network measurement the diagnosis engine needs.
///
/// Kept in the domain layer as a pure interface so `RunDiagnosis` has no
/// dependency on Flutter, platform channels or `dart:io`; the data layer
/// implements it by reusing the ported SimplyNet functional classes.
abstract class NetworkProbe {
  /// Current link type and whether the device is in flight mode.
  Future<ConnectivityStatus> connectivity();

  /// The default gateway (router) IPv4 address, or null when undetectable.
  Future<String?> gatewayIp();

  /// Whether [host] answers an ICMP echo (falls back to a TCP handshake).
  Future<bool> pingReachable(String host);

  /// Whether a raw TCP handshake to [host]:[port] succeeds (no DNS needed
  /// when [host] is an IP literal).
  Future<bool> tcpReachable(String host, int port);

  /// Probe the HTTP-204 endpoints to distinguish clean Internet, a captive
  /// portal, and no Internet at all.
  Future<CaptivePortalResult> checkCaptivePortal();

  /// Whether [host] resolves via DNS.
  Future<bool> dnsResolves(String host);

  /// Probe the well-known outbound ports; a single blocked port among
  /// otherwise-open ones indicates a firewall.
  Future<List<PortProbeResult>> probeCommonPorts();

  /// Latency, jitter and packet loss towards the router (when [gatewayIp] is
  /// given) and towards the Internet. These are the plan-independent metrics
  /// the degradation verdicts are built on.
  Future<LinkQuality> measureLinkQuality({String? gatewayIp});

  /// Time-boxed download followed by a time-boxed upload, plus the round-trip
  /// time observed while the link was busy.
  Future<SpeedResult> measureThroughput();

  /// Trace the route to [host] and report where (if anywhere) it dies.
  Future<IspPathResult> tracePath(String host);

  /// The user's ISO-3166 alpha-2 country code from location, or null.
  Future<String?> detectCountryCode();

  /// Reachability of the popular sites relevant to [countryCode].
  Future<List<SiteReachability>> checkPopularSites(String? countryCode);

  /// The checks performed so far and the payload they moved, for the
  /// transparency section of the report.
  DataUsage dataUsage();

  /// Drop every recorded check so the next diagnosis starts from nothing.
  ///
  /// The probe outlives a single run, so without this the technical details
  /// would carry the previous run's tests into the current report — a run that
  /// stopped at "the router is not responding" would still list a 20 MB speed
  /// test from the run before it, which flatly contradicts its own verdict.
  void resetUsage();
}
