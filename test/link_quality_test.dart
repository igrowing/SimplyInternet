import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/data/datasources/vendor/network_tools.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/data_usage.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/link_quality.dart';

void main() {
  group('LatencyStats', () {
    test('derives average, spread, jitter and loss from the samples', () {
      const stats = LatencyStats(sent: 5, rttsMs: [10, 20, 10, 20]);
      expect(stats.received, 4);
      expect(stats.avgMs, 15);
      expect(stats.minMs, 10);
      expect(stats.maxMs, 20);
      // Consecutive differences are 10, 10, 10.
      expect(stats.jitterMs, 10);
      expect(stats.lossPercent, 20);
      expect(stats.ok, isTrue);
    });

    test('reports nothing measurable when no probe answered', () {
      const stats = LatencyStats(sent: 10, rttsMs: []);
      expect(stats.ok, isFalse);
      expect(stats.avgMs, isNull);
      expect(stats.jitterMs, isNull);
      expect(stats.lossPercent, 100);
    });

    test('has no jitter with a single sample rather than a fake zero', () {
      const stats = LatencyStats(sent: 1, rttsMs: [12]);
      expect(stats.jitterMs, isNull);
    });

    test('unavailable stats claim nothing', () {
      const stats = LatencyStats.unavailable();
      expect(stats.ok, isFalse);
      expect(stats.lossPercent, isNull);
    });
  });

  group('LinkQuality', () {
    test('expresses load slowdown as a ratio of the idle latency', () {
      const quality = LinkQuality(
        gateway: LatencyStats(sent: 2, rttsMs: [2, 2]),
        internet: LatencyStats(sent: 2, rttsMs: [20, 20]),
        loadedRttMs: 200,
      );
      expect(quality.bufferbloatRatio, 10);
    });

    test('never reports a ratio below one, and none without a load sample', () {
      const faster = LinkQuality(
        gateway: LatencyStats.unavailable(),
        internet: LatencyStats(sent: 2, rttsMs: [20, 20]),
        loadedRttMs: 10,
      );
      expect(faster.bufferbloatRatio, 1);
      const idleOnly = LinkQuality(
        gateway: LatencyStats.unavailable(),
        internet: LatencyStats(sent: 2, rttsMs: [20, 20]),
      );
      expect(idleOnly.bufferbloatRatio, isNull);
    });
  });

  group('DataUsage', () {
    test('totals the payload of every recorded test', () {
      const usage = DataUsage([
        ProbeRecord(test: 'Download speed', target: 'cf', bytesReceived: 1000),
        ProbeRecord(test: 'Upload speed', target: 'cf', bytesSent: 500),
      ]);
      expect(usage.bytesReceived, 1000);
      expect(usage.bytesSent, 500);
    });

    test('formats sizes the way a non-technical reader expects', () {
      expect(DataUsage.formatBytes(640), '640 B');
      expect(DataUsage.formatBytes(64000), '64 kB');
      expect(DataUsage.formatBytes(6400000), '6.4 MB');
    });
  });

  group('NetworkTools.parsePingRtts', () {
    test('extracts every round-trip time from ping output', () {
      const output = '''
64 bytes from 1.1.1.1: icmp_seq=1 ttl=57 time=14.2 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=57 time=15 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=57 time<1 ms
''';
      expect(NetworkTools.parsePingRtts(output), [14.2, 15, 1]);
    });

    test('returns nothing when every probe was lost', () {
      const output = '''
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
--- 1.1.1.1 ping statistics ---
4 packets transmitted, 0 received, 100% packet loss, time 3070ms
''';
      expect(NetworkTools.parsePingRtts(output), isEmpty);
    });
  });
}
