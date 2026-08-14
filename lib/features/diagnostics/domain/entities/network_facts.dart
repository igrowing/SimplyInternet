import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// The active link type the device is using.
enum ConnectivityKind { wifi, mobile, ethernet, vpn, other, none }

/// Snapshot of the device's link state at the start of a diagnosis.
@immutable
class ConnectivityStatus extends Equatable {
  const ConnectivityStatus({required this.kind, required this.airplaneMode});

  final ConnectivityKind kind;
  final bool airplaneMode;

  bool get hasLink =>
      kind != ConnectivityKind.none && kind != ConnectivityKind.other;

  @override
  List<Object?> get props => [kind, airplaneMode];
}

/// Result of probing the well-known HTTP 204 captive-portal endpoints.
@immutable
class CaptivePortalResult extends Equatable {
  const CaptivePortalResult({
    required this.internetOk,
    required this.portalDetected,
    this.portalUrl,
  });

  /// Clean 204 (empty) response — real, unintercepted Internet access.
  const CaptivePortalResult.clear()
    : internetOk = true,
      portalDetected = false,
      portalUrl = null;

  /// No endpoint answered at all (no Internet path).
  const CaptivePortalResult.noInternet()
    : internetOk = false,
      portalDetected = false,
      portalUrl = null;

  /// An endpoint answered with a redirect/body instead of 204 — a portal.
  const CaptivePortalResult.portal(String url)
    : internetOk = false,
      portalDetected = true,
      portalUrl = url;

  final bool internetOk;
  final bool portalDetected;
  final String? portalUrl;

  @override
  List<Object?> get props => [internetOk, portalDetected, portalUrl];
}

/// Result of probing a single well-known outbound port to a public host.
@immutable
class PortProbeResult extends Equatable {
  const PortProbeResult({
    required this.port,
    required this.service,
    required this.reachable,
  });

  final int port;
  final String service;
  final bool reachable;

  @override
  List<Object?> get props => [port, service, reachable];
}

/// Outcome of a lightweight throughput measurement.
@immutable
class SpeedResult extends Equatable {
  const SpeedResult({required this.downloadMbps, required this.ok});

  /// The measurement could not be taken (no server, error).
  const SpeedResult.unavailable() : downloadMbps = 0, ok = false;

  final double downloadMbps;
  final bool ok;

  @override
  List<Object?> get props => [downloadMbps, ok];
}

/// Outcome of tracing the route to a public destination.
@immutable
class IspPathResult extends Equatable {
  const IspPathResult({
    required this.reachedDestination,
    this.lastRespondingHop,
    this.firstDeadHop,
  });

  final bool reachedDestination;

  /// The last hop that answered before the path went dark.
  final String? lastRespondingHop;

  /// The hop number at which replies stopped (1-based), if any.
  final int? firstDeadHop;

  @override
  List<Object?> get props => [
    reachedDestination,
    lastRespondingHop,
    firstDeadHop,
  ];
}

/// Reachability outcome for one popular website.
@immutable
class SiteReachability extends Equatable {
  const SiteReachability({
    required this.host,
    required this.label,
    required this.reachable,
  });

  final String host;
  final String label;
  final bool reachable;

  @override
  List<Object?> get props => [host, label, reachable];
}
