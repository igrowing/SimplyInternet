import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// Round-trip samples for one target, the raw material for latency, jitter and
/// packet-loss figures.
///
/// These three metrics are the only ones that are independent of the user's
/// subscription: a 1 Mbps line with no loss is healthy while any line with 8%
/// loss is broken, so degradation is judged from here and never from raw
/// throughput.
@immutable
class LatencyStats extends Equatable {
  const LatencyStats({required this.sent, required this.rttsMs});

  /// The samples could not be taken (no target, ping unavailable, blocked).
  const LatencyStats.unavailable() : sent = 0, rttsMs = const [];

  /// How many probes were sent.
  final int sent;

  /// Round-trip times (ms) of the probes that came back.
  final List<double> rttsMs;

  int get received => rttsMs.length;

  bool get ok => sent > 0 && rttsMs.isNotEmpty;

  /// Percentage of probes that never came back, or null when nothing was sent.
  double? get lossPercent => sent == 0 ? null : (sent - received) * 100 / sent;

  /// Mean round-trip time, or null when no probe answered.
  double? get avgMs =>
      rttsMs.isEmpty ? null : rttsMs.reduce((a, b) => a + b) / rttsMs.length;

  double? get minMs =>
      rttsMs.isEmpty ? null : rttsMs.reduce((a, b) => a < b ? a : b);

  double? get maxMs =>
      rttsMs.isEmpty ? null : rttsMs.reduce((a, b) => a > b ? a : b);

  /// Jitter as the mean absolute difference between consecutive samples
  /// (packet delay variation), or null with fewer than two answers.
  double? get jitterMs {
    if (rttsMs.length < 2) return null;
    var total = 0.0;
    for (var i = 1; i < rttsMs.length; i++) {
      total += (rttsMs[i] - rttsMs[i - 1]).abs();
    }
    return total / (rttsMs.length - 1);
  }

  @override
  List<Object?> get props => [sent, rttsMs];
}

/// Latency/jitter/loss for both hops that matter: the router (one radio hop,
/// no ISP involved) and the Internet beyond it.
///
/// [loadedRttMs] is sampled *during* the throughput transfer, so comparing it
/// with the idle [internet] average exposes a saturated or bufferbloated link
/// as a ratio rather than an absolute figure.
@immutable
class LinkQuality extends Equatable {
  const LinkQuality({
    required this.gateway,
    required this.internet,
    this.loadedRttMs,
  });

  const LinkQuality.unavailable()
    : gateway = const LatencyStats.unavailable(),
      internet = const LatencyStats.unavailable(),
      loadedRttMs = null;

  /// Samples against the default gateway; unavailable on links where no local
  /// router is involved (mobile data).
  final LatencyStats gateway;

  /// Samples against a public host.
  final LatencyStats internet;

  /// Mean round-trip time observed while the link was busy, if measured.
  final double? loadedRttMs;

  /// The same idle samples with the under-load figure attached, which is only
  /// known once the throughput transfer has finished.
  LinkQuality withLoadedRtt(double? loadedRtt) => LinkQuality(
    gateway: gateway,
    internet: internet,
    loadedRttMs: loadedRtt ?? loadedRttMs,
  );

  /// How much slower the link answers under load, as a multiple of its idle
  /// latency. Null when either figure is missing.
  double? get bufferbloatRatio {
    final idle = internet.avgMs;
    final loaded = loadedRttMs;
    if (idle == null || loaded == null || idle <= 0) return null;
    return math.max(1, loaded / idle);
  }

  @override
  List<Object?> get props => [gateway, internet, loadedRttMs];
}
