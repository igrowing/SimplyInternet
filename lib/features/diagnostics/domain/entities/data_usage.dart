import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// One test that was actually performed, with the payload it moved.
///
/// Recorded for transparency: the user can see exactly which checks ran and how
/// much data each one cost. Byte counts are payload only (protocol headers are
/// not counted), and a test that transfers nothing measurable reports zero.
@immutable
class ProbeRecord extends Equatable {
  const ProbeRecord({
    required this.test,
    required this.target,
    this.bytesSent = 0,
    this.bytesReceived = 0,
  });

  /// Human-facing name of the check, e.g. 'Download speed'.
  final String test;

  /// What it was run against, e.g. 'speed.cloudflare.com'.
  final String target;

  final int bytesSent;
  final int bytesReceived;

  @override
  List<Object?> get props => [test, target, bytesSent, bytesReceived];
}

/// Everything the diagnosis did on the network, and what it cost.
@immutable
class DataUsage extends Equatable {
  const DataUsage(this.records);

  const DataUsage.empty() : records = const [];

  final List<ProbeRecord> records;

  int get bytesSent => records.fold(0, (sum, r) => sum + r.bytesSent);

  int get bytesReceived => records.fold(0, (sum, r) => sum + r.bytesReceived);

  /// Compact size for display: bytes below 1 kB, then kB, then MB.
  static String formatBytes(int bytes) {
    if (bytes < 1000) return '$bytes B';
    if (bytes < 1000 * 1000) return '${(bytes / 1000).round()} kB';
    return '${(bytes / (1000 * 1000)).toStringAsFixed(1)} MB';
  }

  @override
  List<Object?> get props => [records];
}
