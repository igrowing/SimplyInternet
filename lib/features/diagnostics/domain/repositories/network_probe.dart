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

  /// A quick download throughput sample used only to flag possible shaping.
  Future<SpeedResult> measureSpeed();

  /// Trace the route to [host] and report where (if anywhere) it dies.
  Future<IspPathResult> tracePath(String host);

  /// The user's ISO-3166 alpha-2 country code from location, or null.
  Future<String?> detectCountryCode();

  /// Reachability of the popular sites relevant to [countryCode].
  Future<List<SiteReachability>> checkPopularSites(String? countryCode);
}
