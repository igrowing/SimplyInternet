import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/data/datasources/vendor/network_tools.dart';

/// Parsing tests for the vendored [NetworkTools]. The subprocess wrappers
/// (`pingRtts`, `tracerouteHops`) shell out to the system `ping` and are
/// exercised through the probes that inject them; what is testable — and what
/// every hop line in the report depends on — is the parsing, so that is what is
/// pinned here.
void main() {
  group('parsePingRtts', () {
    test('collects every time= value in the order ping printed them', () {
      const output = '''
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=57 time=12.3 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=57 time=9 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=57 time=15.75 ms
''';
      expect(NetworkTools.parsePingRtts(output), [12.3, 9.0, 15.75]);
    });

    test('reads the sub-millisecond "time<1 ms" form', () {
      // A LAN gateway answers faster than ping's resolution and prints `<`
      // instead of `=`; dropping those samples made a perfect local link look
      // like total packet loss.
      expect(NetworkTools.parsePingRtts('time<1 ms'), [1.0]);
    });

    test('reads the form without a space before the unit', () {
      expect(NetworkTools.parsePingRtts('rtt time=0.42ms done'), [0.42]);
    });

    test('returns nothing when no probe came back', () {
      const output = '''
PING 10.0.0.9 (10.0.0.9) 56(84) bytes of data.

--- 10.0.0.9 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2043ms
''';
      expect(NetworkTools.parsePingRtts(output), isEmpty);
    });

    test('ignores a time= field that is not a number', () {
      expect(NetworkTools.parsePingRtts('time=... ms'), isEmpty);
    });
  });

  group('parseTracerouteHop', () {
    test('reports the destination as reached on an echo reply', () {
      final hop = NetworkTools.parseTracerouteHop(
        '64 bytes from 1.1.1.1: icmp_seq=1 ttl=57 time=12.34 ms',
        '1.1.1.1',
      );
      expect(hop.hopIp, '1.1.1.1');
      expect(hop.reached, isTrue);
      // One probe answered; the other two slots are padded so the row always
      // has three columns.
      expect(hop.times, ['12.3ms', '*', '*']);
    });

    test('an echo reply from another address is not the destination', () {
      final hop = NetworkTools.parseTracerouteHop(
        '64 bytes from 9.9.9.9: icmp_seq=1 ttl=57 time=5.0 ms',
        '1.1.1.1',
      );
      expect(hop.hopIp, '9.9.9.9');
      expect(hop.reached, isFalse);
    });

    test('reads an intermediate router from a colon-form From line', () {
      final hop = NetworkTools.parseTracerouteHop(
        'From 192.168.1.1: icmp_seq=1 Time to live exceeded',
        '1.1.1.1',
      );
      expect(hop.hopIp, '192.168.1.1');
      expect(hop.reached, isFalse);
      // The kernel's Time Exceeded reply carries no time= field, so the row is
      // all stars and the caller falls back to its own stopwatch.
      expect(hop.times, ['*', '*', '*']);
    });

    test('reads an intermediate router from a space-form From line', () {
      final hop = NetworkTools.parseTracerouteHop(
        'From 10.0.0.1 icmp_seq=1 Time to live exceeded',
        '1.1.1.1',
      );
      expect(hop.hopIp, '10.0.0.1');
      expect(hop.reached, isFalse);
    });

    test('keeps a time= value printed beside a Time Exceeded reply', () {
      final hop = NetworkTools.parseTracerouteHop(
        'From 10.0.0.1: icmp_seq=1 Time to live exceeded time=5.06 ms',
        '1.1.1.1',
      );
      expect(hop.hopIp, '10.0.0.1');
      expect(hop.times.first, '5.1ms');
    });

    test('prefers the echo reply over a Time Exceeded line beside it', () {
      // Both lines can appear in one output when the last TTL both expires and
      // arrives; the arrival is the fact that decides the hop.
      final hop = NetworkTools.parseTracerouteHop('''
From 10.0.0.1: icmp_seq=1 Time to live exceeded
64 bytes from 1.1.1.1: icmp_seq=1 ttl=57 time=20.0 ms
''', '1.1.1.1');
      expect(hop.hopIp, '1.1.1.1');
      expect(hop.reached, isTrue);
    });

    test('reports no hop at all when nothing answered', () {
      final hop = NetworkTools.parseTracerouteHop(
        'PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.\n\n'
        '--- 1.1.1.1 ping statistics ---\n'
        '1 packets transmitted, 0 received, 100% packet loss',
        '1.1.1.1',
      );
      expect(hop.hopIp, isNull);
      expect(hop.reached, isFalse);
      expect(hop.times, ['*', '*', '*']);
    });

    test('pads to three columns however many probes replied', () {
      final hop = NetworkTools.parseTracerouteHop('''
64 bytes from 1.1.1.1: icmp_seq=1 ttl=57 time=1.0 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=57 time=2.0 ms
''', '1.1.1.1');
      expect(hop.times, ['1.0ms', '2.0ms', '*']);
    });
  });

  group('TracertHop', () {
    test('a hop nothing answered is the classic timeout', () {
      const hop = TracertHop(hop: 4);
      expect(hop.timedOut, isTrue);
      expect(hop.avgMs, isNull);
      expect(hop.rttsMs, isEmpty);
      expect(hop.reached, isFalse);
      expect(hop.hostname, isNull);
    });

    test('averages only the probes that replied', () {
      const hop = TracertHop(
        hop: 2,
        ip: '10.0.0.1',
        hostname: 'gw.example.net',
        rttsMs: [10, 20, 30],
      );
      expect(hop.timedOut, isFalse);
      expect(hop.avgMs, 20);
    });

    test('a single reply averages to itself', () {
      const hop = TracertHop(hop: 1, ip: '10.0.0.1', rttsMs: [7.5]);
      expect(hop.avgMs, 7.5);
    });
  });

  test('TracerouteException prints its own message', () {
    const e = TracerouteException('DNS resolution failed: nope');
    expect(e.toString(), 'DNS resolution failed: nope');
  });
}
