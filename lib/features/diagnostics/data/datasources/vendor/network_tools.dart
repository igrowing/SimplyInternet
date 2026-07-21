import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'package:simply_internet/features/diagnostics/data/datasources/vendor/network_ports.dart';

/// Wrappers for diagnostic network tools.
/// Each returns a Stream<String> so callers can display output progressively.
class NetworkTools {
  // ── Ping ───────────────────────────────────────────────────────────────────
  /// [count] how many ICMP echo requests to send (default 10 per spec).
  static Stream<String> ping(String host, {int count = 10}) async* {
    yield '=== PING $host (${count}x) ===\n';
    try {
      final proc = await Process.start(
          'ping', ['-c', count.toString(), '-W', '2', host]);
      yield* proc.stdout.transform(const SystemEncoding().decoder);
      yield* proc.stderr.transform(const SystemEncoding().decoder);
      await proc.exitCode;
    } catch (e) {
      yield 'ping not available: $e\n';
      yield* _dartPing(host, count);
    }
  }

  static Stream<String> _dartPing(String host, int count) async* {
    for (var i = 1; i <= count; i++) {
      try {
        final sw   = Stopwatch()..start();
        final sock = await Socket.connect(host, 80,
            timeout: const Duration(seconds: 2));
        sock.destroy();
        sw.stop();
        yield 'Reply from $host: time=${sw.elapsedMilliseconds}ms\n';
      } catch (_) {
        yield 'Request timeout for $host\n';
      }
      if (i < count) await Future.delayed(const Duration(seconds: 1));
    }
  }

  // ── NSLookup ───────────────────────────────────────────────────────────────
  // Auto-detects direction based on input:
  //   • IPv4 literal  →  reverse lookup  (PTR record: IP → FQDN)
  //   • Anything else →  forward lookup  (A/AAAA: name → IPs)
  // Falls back to the system `nslookup` binary for extra detail either way.
  static final _ipRegex = RegExp(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$');

  static Stream<String> nslookup(String host) async* {
    final input   = host.trim();
    final isIp    = _ipRegex.hasMatch(input);
    yield '=== ${isIp ? "REVERSE " : ""}NSLOOKUP $input ===\n';

    if (isIp) {
      // ── Reverse lookup: IP → FQDN ────────────────────────────────────────
      // Method 1: dart:io PTR query (cleanest)
      bool gotResult = false;
      try {
        final ia  = InternetAddress(input);
        final rev = await ia.reverse().timeout(const Duration(seconds: 4));
        if (rev.host.isNotEmpty && rev.host != input) {
          yield 'PTR record : ${rev.host}\n';
          gotResult = true;
        }
      } catch (_) {}

      // Method 2: system nslookup (shows full PTR chain)
      try {
        final proc = await Process.start('nslookup', [input]);
        final out  = await proc.stdout
            .transform(const SystemEncoding().decoder)
            .join()
            .timeout(const Duration(seconds: 5));
        await proc.exitCode;
        // Filter for the "name =" line which carries the FQDN
        for (final line in out.split('\n')) {
          final t = line.trim();
          if (t.contains('name =') || t.startsWith('Non-authoritative')) {
            yield '$t\n';
            gotResult = true;
          }
        }
      } catch (_) {}

      if (!gotResult) yield 'No PTR record found for $input\n';
    } else {
      // ── Forward lookup: name → IPs ───────────────────────────────────────
      // Method 1: dart:io A/AAAA lookup
      try {
        final addrs = await InternetAddress.lookup(input)
            .timeout(const Duration(seconds: 4));
        for (final a in addrs) {
          yield '${a.type == InternetAddressType.IPv6 ? "AAAA" : "A   "} : ${a.address}\n';
        }
      } catch (e) {
        yield 'Lookup failed: $e\n';
      }

      // Method 2: system nslookup for full answer (TTL, authoritative server)
      try {
        final proc = await Process.start('nslookup', [input]);
        final out  = await proc.stdout
            .transform(const SystemEncoding().decoder)
            .join()
            .timeout(const Duration(seconds: 5));
        await proc.exitCode;
        // Show the answer section (lines after the blank line)
        bool inAnswer = false;
        for (final line in out.split('\n')) {
          final t = line.trim();
          if (t.isEmpty) { inAnswer = true; continue; }
          if (inAnswer && t.isNotEmpty) yield '$t\n';
        }
      } catch (_) {}
    }
  }

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

  static Stream<String> traceroute(String host, {int maxHops = 30}) async* {
    yield '=== TRACEROUTE $host ===\n';

    // Resolve destination once so we can detect arrival
    String destIp = host;
    try {
      final addrs = await InternetAddress.lookup(host)
          .timeout(const Duration(seconds: 4));
      destIp = addrs.first.address;
      if (destIp != host) yield 'Resolved: $host → $destIp\n';
    } catch (e) {
      yield 'DNS resolution failed: $e\n';
      return;
    }
    yield '\n';

    // Regex to extract the replying IP from a Time Exceeded line.
    // Android ping prints:  "From 192.168.1.1 icmp_seq=1 Time to live exceeded"
    // Some versions print:  "From 192.168.1.1: icmp_seq=1 Time to live exceeded"
    for (var ttl = 1; ttl <= maxHops; ttl++) {
      final sw = Stopwatch()..start();

      // ping -c 3 -t <ttl> -W 2: 3 packets, TTL=ttl, 2s wait per packet
      String? hopIp;
      final hopTimes = <String>[];
      bool reached = false;

      try {
        final result = await Process.run(
          'ping', ['-c', '3', '-t', ttl.toString(), '-W', '2', destIp],
          runInShell: false,
        ).timeout(const Duration(seconds: 9)); // 3 packets × 2s + buffer

        final out = '${result.stdout}${result.stderr}';
        final hop = parseTracerouteHop(out, destIp);
        hopIp = hop.hopIp;
        hopTimes.addAll(hop.times);
        reached = hop.reached;
      } catch (_) {
        hopTimes.addAll(['*', '*', '*']);
      }

      sw.stop();

      // Reverse-DNS the hop IP
      String label = hopIp ?? '*';
      if (hopIp != null) {
        try {
          final rev = await InternetAddress(hopIp)
              .reverse()
              .timeout(const Duration(seconds: 1));
          if (rev.host != hopIp) label = '${rev.host} ($hopIp)';
        } catch (_) {}
      }

      final hopNum = ttl.toString().padLeft(2);
      yield '$hopNum  $label  ${hopTimes.join("  ")}\n';

      if (reached) {
        yield '\nReached destination in $ttl hop${ttl == 1 ? "" : "s"}.\n';
        return;
      }

      // If we got the destination IP directly at this hop (exit code 0), stop
      if (hopIp == destIp) {
        yield '\nReached destination in $ttl hop${ttl == 1 ? "" : "s"}.\n';
        return;
      }
    }
    yield '\nMax hops ($maxHops) reached.\n';
  }

  /// Structured variant of [traceroute] for the timeline UI. Emits one
  /// [TracertHop] per TTL as it is probed (reverse-DNS resolved). Completes
  /// after the destination is reached or [maxHops] is hit; throws
  /// [TracerouteException] when the host cannot be resolved.
  static Stream<TracertHop> tracerouteHops(String host,
      {int maxHops = 30}) async* {
    String destIp;
    try {
      final addrs = await InternetAddress.lookup(host)
          .timeout(const Duration(seconds: 4));
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
          final result = await Process.run(
            'ping', ['-c', '1', '-t', ttl.toString(), '-W', '2', destIp],
            runInShell: false,
          ).timeout(const Duration(seconds: 4));
          sw.stop();
          final hop =
              parseTracerouteHop('${result.stdout}${result.stderr}', destIp);
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
          final rev = await InternetAddress(hopIp)
              .reverse()
              .timeout(const Duration(seconds: 1));
          if (rev.host != hopIp) hostname = rev.host;
        } catch (_) {}
      }

      reached = reached || hopIp == destIp;
      yield TracertHop(
        hop:      ttl,
        ip:       hopIp,
        hostname: hostname,
        rttsMs:   rtts,
        reached:  reached,
      );
      if (reached) return;
    }
  }

  /// Parse a single hop from a `ping -c 1 -t <TTL>` [output] against [destIp].
  /// Returns the replying hop IP (null if none), the per-probe RTT strings
  /// padded to three entries with '*' for non-responses, and whether the
  /// destination was reached. Pure — separated from the ping subprocess so the
  /// line-parsing branches can be tested directly.
  @visibleForTesting
  static ({String? hopIp, List<String> times, bool reached}) parseTracerouteHop(
      String output, String destIp) {
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
        hopIp   = byteMatch.group(1)!;
        reached = (hopIp == destIp);
        final t = timeRe.firstMatch(line);
        if (t != null) hopTimes.add('${double.parse(t.group(1)!).toStringAsFixed(1)}ms');
      }
      // Time Exceeded from intermediate router
      final fromMatch = fromRe.firstMatch(line);
      if (fromMatch != null && hopIp == null) {
        hopIp = fromMatch.group(1)!;
        final t = timeRe.firstMatch(line);
        if (t != null) hopTimes.add('${double.parse(t.group(1)!).toStringAsFixed(1)}ms');
      }
    }

    // Count asterisks for non-responding probes
    final stars = 3 - hopTimes.length;
    for (var i = 0; i < stars; i++) {
      hopTimes.add('*');
    }

    return (hopIp: hopIp, times: hopTimes, reached: reached);
  }

  // ── Port Scan ──────────────────────────────────────────────────────────────

  /// Well-known ports dictionary: port number → service name.
  /// Defined centrally in [NetworkPorts]; aliased here so existing callers
  /// (`NetworkTools.wellKnownPortNames`) keep working unchanged.
  /// Use .keys.toList() wherever a List<int> of port numbers is needed.
  static const wellKnownPortNames = NetworkPorts.wellKnownPortNames;

  // Legacy aliases — keep existing callers compiling without changes.
  static List<int> get wellKnownPorts => wellKnownPortNames.keys.toList();

  static Stream<String> portScan(
    String host, {
    List<int>? ports,
    int rangeStart = 1,
    int rangeEnd = 2048,
    bool useTcp = true,
    bool useUdp = false,
    void Function(int done, int total)? onProgress,
  }) async* {
    // Resolve hostname to IP once (needed for UDP RawDatagramSocket)
    String resolvedIp = host;
    try {
      final addrs = await InternetAddress.lookup(host)
          .timeout(const Duration(seconds: 4));
      resolvedIp = addrs.first.address;
    } catch (_) {}

    final scanPorts = ports ?? List.generate(
      rangeEnd - rangeStart + 1,
      (i) => rangeStart + i,
    );
    yield '=== PORT SCAN $host'
        ' [${useTcp ? "TCP" : ""}${useTcp && useUdp ? "+" : ""}${useUdp ? "UDP" : ""}]'
        ' ports ${scanPorts.first}–${scanPorts.last} (${scanPorts.length} ports) ===\n';

    // ── Concurrent scanning ──────────────────────────────────────────────────
    // Run up to 128 probes in parallel (semaphore-limited).
    // Results are emitted as they arrive, not in port-order.
    // A StreamController bridges the parallel futures → the async* stream.

    final openPorts = <int>[];
    final controller = StreamController<String>();
    int done = 0;
    int pending = scanPorts.length * (useTcp && useUdp ? 2 : 1);
    if (pending == 0) pending = 1; // safety

    final sem = _Semaphore(128);

    void finish() {
      if (done >= pending && !controller.isClosed) {
        if (openPorts.isEmpty) controller.add('No open ports found.\n');
        controller.add('\nDone. ${openPorts.length} open port(s) found.\n');
        controller.close();
      }
    }

    for (final port in scanPorts) {
      if (useTcp) {
        sem.run(() async {
          try {
            final sock = await Socket.connect(resolvedIp, port,
                timeout: const Duration(milliseconds: 600));
            sock.destroy();
            final name = wellKnownPortNames[port] ?? '';
            controller.add('OPEN  $port/tcp  $name\n');
            openPorts.add(port);
          } catch (_) {}
          done++;
          onProgress?.call(done ~/ (useTcp && useUdp ? 2 : 1), scanPorts.length);
          finish();
        });
      }

      if (useUdp) {
        sem.run(() async {
          // UDP detection strategy:
          // 1. Send a protocol-appropriate probe payload (not empty — many
          //    services ignore empty UDP datagrams entirely).
          // 2. Listen for any response (reply = open) for 600ms.
          // 3. ICMP Port Unreachable would come as a socket error; absence of
          //    error + response = probably open. This is best-effort on Android
          //    because the kernel may suppress ICMP errors to non-root sockets.
          try {
            final udp = await RawDatagramSocket.bind(
                InternetAddress.anyIPv4, 0,
                reuseAddress: true);
            udp.readEventsEnabled = true;
            // Send a probe: DNS query for UDP 53, otherwise empty
            final probe = port == 53
                ? Uint8List.fromList([
                    0x00, 0x01, 0x01, 0x00, 0x00, 0x01, 0x00, 0x00,
                    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01
                  ])
                : Uint8List(4); // 4-zero bytes — enough to trigger a reply
            udp.send(probe, InternetAddress(resolvedIp), port);

            bool gotReply = false;
            final timer = Timer(const Duration(milliseconds: 600), () {
              if (!gotReply) udp.close();
            });
            try {
              await for (final ev in udp) {
                if (ev == RawSocketEvent.read) {
                  gotReply = true;
                  break;
                }
              }
            } catch (_) {}
            timer.cancel();
            try { udp.close(); } catch (_) {}

            if (gotReply) {
              final name = wellKnownPortNames[port] ?? '';
              controller.add('OPEN  $port/udp  $name\n');
              openPorts.add(port);
            }
          } catch (_) {}
          done++;
          onProgress?.call(done ~/ (useTcp && useUdp ? 2 : 1), scanPorts.length);
          finish();
        });
      }
    }

    // Yield from the controller stream
    yield* controller.stream;
  }

  // ── IP Camera Scan ─────────────────────────────────────────────────────────
  // Moved to lib/services/ip_camera_detector.dart (IpCameraDetector.scanSubnet).
  // The multi-signal detection model (specific ports, manufacturer, HTTP
  // banner, WS-Discovery) lives there and replaces the old plain port-check.
}

// ── Semaphore for concurrent port scanning ───────────────────────────────────

class _Semaphore {
  int _count;
  final _queue = <Completer<void>>[];
  _Semaphore(this._count);

  Future<void> run(Future<void> Function() fn) async {
    if (_count <= 0) {
      final c = Completer<void>();
      _queue.add(c);
      await c.future;
    }
    _count--;
    try {
      await fn();
    } finally {
      _count++;
      if (_queue.isNotEmpty) _queue.removeAt(0).complete();
    }
  }
}

/// One hop in a structured traceroute, consumed by the timeline UI.
class TracertHop {
  final int hop;             // TTL / hop number (1-based)
  final String? ip;          // replying router IP; null when nothing answered
  final String? hostname;    // reverse-DNS name, null when unavailable
  final List<double> rttsMs; // RTTs (ms) of the probes that replied
  final bool reached;        // true when this hop is the destination

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

