import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Wrappers for diagnostic network tools.
class NetworkTools {
  // ── Traceroute ─────────────────────────────────────────────────────────────
  // Uses `ping -c 1 -t <ttl>` per hop.
  //
  // Why ping instead of traceroute binary or raw sockets?
  //   • `traceroute` binary: always fails with "Permission denied" on stock
  //     Android — requires CAP_NET_RAW which unprivileged apps don't have.
  //   • Raw sockets (RawDatagramSocket): dart:io UDP sockets cannot set the
  //     IP_TTL socket option, so TTL-based probing is impossible in pure Dart.
  //   • `ping -t <ttl>`: the system `ping` binary has the setuid bit / ambient
  //     capabilities on Android, so it CAN send ICMP with a controlled TTL.
  //     When TTL expires mid-route the intermediate router sends back an ICMP
  //     Time Exceeded packet. Android's ping prints that router's IP in the
  //     "From <ip>: icmp_seq=..." or "From <ip> icmp_type=11" line.
  //     This is exactly how real traceroute works, using the same ICMP
  //     Time Exceeded mechanism — we just drive it from ping instead of
  //     the traceroute binary.
  //
  // 3 probes per hop (like traceroute -q 3) run sequentially (ping -c 3)
  // to match standard traceroute output format.
  //
  // Hop detection logic:
  //   ping exit code 0  → destination reached (successful ICMP echo reply)
  //   "From <ip>" line  → intermediate router sent Time Exceeded; ip ≠ dest
  //   No reply / "*"    → hop is firewalled or dropped (timeout)
  //
  // Falls back to TCP-connect if ping -t is not supported (some old kernels).

  /// Structured variant of traceroute for the timeline UI. Emits one
  /// [TracertHop] per TTL as it is probed (reverse-DNS resolved). Completes
  /// after the destination is reached or [maxHops] is hit; throws
  /// [TracerouteException] when the host cannot be resolved.
  static Stream<TracertHop> tracerouteHops(
    String host, {
    int maxHops = 30,
  }) async* {
    String destIp;
    try {
      final addrs = await InternetAddress.lookup(
        host,
      ).timeout(const Duration(seconds: 4));
      destIp = addrs.first.address;
    } catch (e) {
      throw TracerouteException('DNS resolution failed: $e');
    }

    for (var ttl = 1; ttl <= maxHops; ttl++) {
      String? hopIp;
      var reached = false;
      final rtts = <double>[];

      // Send the three probes one-by-one and time each with a Stopwatch.
      // The kernel's "Time to live exceeded" reply for intermediate routers
      // carries no `time=` field, so the only way to show their latency is to
      // measure the round trip ourselves. For the destination we still prefer
      // the precise `time=` value from the echo reply when present.
      for (var probe = 0; probe < 3; probe++) {
        final sw = Stopwatch()..start();
        try {
          final result = await Process.run('ping', [
            '-c',
            '1',
            '-t',
            ttl.toString(),
            '-W',
            '2',
            destIp,
          ], runInShell: false).timeout(const Duration(seconds: 4));
          sw.stop();
          final hop = parseTracerouteHop(
            '${result.stdout}${result.stderr}',
            destIp,
          );
          if (hop.hopIp == null) continue; // no reply to this probe
          hopIp ??= hop.hopIp;
          reached = reached || hop.reached;

          final parsed = hop.times
              .where((t) => t != '*')
              .map((t) => double.tryParse(t.replaceAll('ms', '').trim()))
              .firstWhere((v) => v != null, orElse: () => null);
          rtts.add(parsed ?? sw.elapsedMicroseconds / 1000.0);
        } catch (_) {
          sw.stop();
        }
      }

      String? hostname;
      if (hopIp != null) {
        try {
          final rev = await InternetAddress(
            hopIp,
          ).reverse().timeout(const Duration(seconds: 1));
          if (rev.host != hopIp) hostname = rev.host;
        } catch (_) {}
      }

      reached = reached || hopIp == destIp;
      yield TracertHop(
        hop: ttl,
        ip: hopIp,
        hostname: hostname,
        rttsMs: rtts,
        reached: reached,
      );
      if (reached) return;
    }
  }

  /// Sends [count] ICMP echoes to [host] and returns the round-trip times that
  /// came back, so the caller can derive latency, jitter and packet loss.
  ///
  /// One `ping -c <count> -i <interval>` process is preferred because it paces
  /// the probes itself; when the platform's ping rejects a sub-second interval
  /// the probes are sent one at a time instead. RTTs always come from ping's
  /// own `time=` field, never from wall-clock timing around the subprocess, so
  /// process start-up cost cannot inflate the jitter figure.
  static Future<List<double>> pingRtts(
    String host, {
    required int count,
    required Duration interval,
  }) async {
    final seconds = interval.inMilliseconds / 1000.0;
    final budget =
        Duration(milliseconds: interval.inMilliseconds * count) +
        const Duration(seconds: 6);
    try {
      final result = await Process.run('ping', [
        '-c',
        count.toString(),
        '-i',
        seconds.toString(),
        '-W',
        '2',
        host,
      ], runInShell: false).timeout(budget);
      final rtts = parsePingRtts('${result.stdout}${result.stderr}');
      if (rtts.isNotEmpty) return rtts;
    } on Exception {
      // Fall through to the one-probe-at-a-time path below.
    }

    final rtts = <double>[];
    for (var i = 0; i < count; i++) {
      try {
        final single = await Process.run('ping', [
          '-c',
          '1',
          '-W',
          '2',
          host,
        ], runInShell: false).timeout(const Duration(seconds: 4));
        rtts.addAll(parsePingRtts('${single.stdout}${single.stderr}'));
      } on Exception {
        // A probe that never came back is packet loss, counted by the caller.
      }
    }
    return rtts;
  }

  /// Extract every `time=<n> ms` value from ping [output].
  @visibleForTesting
  static List<double> parsePingRtts(String output) {
    final timeRe = RegExp(r'time[=<]\s*([\d.]+)\s*ms');
    final out = <double>[];
    for (final match in timeRe.allMatches(output)) {
      final value = double.tryParse(match.group(1)!);
      if (value != null) out.add(value);
    }
    return out;
  }

  /// Parse a single hop from a `ping -c 1 -t <TTL>` [output] against [destIp].
  /// Returns the replying hop IP (null if none), the per-probe RTT strings
  /// padded to three entries with '*' for non-responses, and whether the
  /// destination was reached. Pure — separated from the ping subprocess so the
  /// line-parsing branches can be tested directly.
  @visibleForTesting
  static ({String? hopIp, List<String> times, bool reached}) parseTracerouteHop(
    String output,
    String destIp,
  ) {
    final fromRe = RegExp(r'From ([\d.]+)[: ]');
    final timeRe = RegExp(r'time=([\d.]+)\s*ms');
    final byteRe = RegExp(r'bytes from ([\d.]+):');

    String? hopIp;
    final hopTimes = <String>[];
    bool reached = false;

    for (final line in output.split('\n')) {
      // Arrived at destination
      final byteMatch = byteRe.firstMatch(line);
      if (byteMatch != null) {
        hopIp = byteMatch.group(1)!;
        reached = (hopIp == destIp);
        final t = timeRe.firstMatch(line);
        if (t != null)
          hopTimes.add('${double.parse(t.group(1)!).toStringAsFixed(1)}ms');
      }
      // Time Exceeded from intermediate router
      final fromMatch = fromRe.firstMatch(line);
      if (fromMatch != null && hopIp == null) {
        hopIp = fromMatch.group(1)!;
        final t = timeRe.firstMatch(line);
        if (t != null)
          hopTimes.add('${double.parse(t.group(1)!).toStringAsFixed(1)}ms');
      }
    }

    // Count asterisks for non-responding probes
    final stars = 3 - hopTimes.length;
    for (var i = 0; i < stars; i++) {
      hopTimes.add('*');
    }

    return (hopIp: hopIp, times: hopTimes, reached: reached);
  }
}

/// One hop in a structured traceroute, consumed by the timeline UI.
class TracertHop {
  final int hop; // TTL / hop number (1-based)
  final String? ip; // replying router IP; null when nothing answered
  final String? hostname; // reverse-DNS name, null when unavailable
  final List<double> rttsMs; // RTTs (ms) of the probes that replied
  final bool reached; // true when this hop is the destination

  const TracertHop({
    required this.hop,
    this.ip,
    this.hostname,
    this.rttsMs = const [],
    this.reached = false,
  });

  /// No router replied to any probe (the classic `* * *`).
  bool get timedOut => ip == null;

  /// Mean RTT across the probes that replied, or null when none did.
  double? get avgMs =>
      rttsMs.isEmpty ? null : rttsMs.reduce((a, b) => a + b) / rttsMs.length;
}

/// Thrown by [NetworkTools.tracerouteHops] when the host cannot be resolved.
class TracerouteException implements Exception {
  final String message;
  const TracerouteException(this.message);
  @override
  String toString() => message;
}
