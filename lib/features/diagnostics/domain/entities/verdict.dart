import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// The reliable, mutually-exclusive categories a diagnosis can conclude with.
///
/// Ordered from "closest to the device" outward to the ISP so the diagnosis
/// engine can evaluate them as a short-circuiting decision tree and always
/// return exactly one category.
enum VerdictCategory {
  /// Wi-Fi and mobile data are both off (or the device is in flight mode).
  notConnected,

  /// Connected to a link, but the local router/gateway does not answer.
  routerNotResponding,

  /// A captive portal (hotel/airport/cafe sign-in page) intercepts traffic.
  captivePortal,

  /// The router answers but there is no reachable Internet (ISP/WAN down).
  noInternetIsp,

  /// Raw IPs are reachable but name resolution fails — fixable via DNS.
  dnsProblem,

  /// A specific port is blocked by a firewall while others work.
  portBlocked,

  /// Throughput is suspiciously low — throttling is possible (not certain).
  trafficShaping,

  /// A hop inside the ISP/backbone drops traffic before the destination.
  ispPathProblem,

  /// Every check passed — the connection is healthy.
  allClear,
}

/// Immutable outcome of a diagnosis: one [VerdictCategory] with human-facing
/// title and detail text. A [detailArg] carries the single concrete fact the
/// category names (a port number, a hop address, a throughput figure).
@immutable
class Verdict extends Equatable {
  const Verdict({
    required this.category,
    required this.title,
    required this.detail,
    this.detailArg,
  });

  final VerdictCategory category;
  final String title;
  final String detail;

  /// The concrete value some verdicts must name (e.g. "443", "10.0.0.1").
  final String? detailArg;

  bool get isHealthy => category == VerdictCategory.allClear;

  @override
  List<Object?> get props => [category, title, detail, detailArg];
}
