import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:simply_internet/features/diagnostics/data/repositories/network_probe_impl.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/check_endpoints.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/popular_sites.dart';

/// The plugin channels the probe reads the device link through, plus our own
/// native actions channel. Mocked here so the link state can be scripted.
const _connectivity = MethodChannel('dev.fluttercommunity.plus/connectivity');
const _networkInfo = MethodChannel('dev.fluttercommunity.plus/network_info');
const _actions = MethodChannel('com.simplytools.simplyinternet/actions');

/// Round-trip times that arrive instantly, so latency tests measure behaviour
/// rather than the clock (and never shell out to `ping`).
Future<List<double>> _instantPing(
  String host, {
  required int count,
  required Duration interval,
}) async => List<double>.filled(count, 12);

/// An address reserved for documentation (RFC 5737) that no route can reach,
/// used where the probe's "nothing answered" path is what is under test.
const _unroutable = '192.0.2.1';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final actionCalls = <String>[];

  /// Scripts the device link: what `connectivity_plus` reports, what gateway
  /// `network_info_plus` knows, and what the native side says about flight
  /// mode and cellular signal.
  void mockDevice({
    List<String> connectivity = const ['wifi'],
    Object? gateway = '192.168.1.1',
    PlatformException? gatewayError,
    bool airplane = false,
    int? signalLevel,
  }) {
    messenger
      ..setMockMethodCallHandler(
        _connectivity,
        (call) async => call.method == 'check' ? connectivity : null,
      )
      ..setMockMethodCallHandler(_networkInfo, (call) async {
        if (gatewayError != null) throw gatewayError;
        return call.method == 'wifiGatewayAddress' ? gateway : null;
      })
      ..setMockMethodCallHandler(_actions, (call) async {
        actionCalls.add(call.method);
        switch (call.method) {
          case 'isAirplaneModeOn':
            return airplane;
          case 'mobileSignalLevel':
            return signalLevel;
          default:
            return null;
        }
      });
  }

  setUp(() {
    actionCalls.clear();
    mockDevice();
  });

  tearDown(() {
    for (final channel in [_connectivity, _networkInfo, _actions]) {
      messenger.setMockMethodCallHandler(channel, null);
    }
  });

  group('connectivity', () {
    test('picks the link the device is actually using', () async {
      const cases = {
        'wifi': ConnectivityKind.wifi,
        'ethernet': ConnectivityKind.ethernet,
        'mobile': ConnectivityKind.mobile,
        'vpn': ConnectivityKind.vpn,
        'none': ConnectivityKind.none,
        'bluetooth': ConnectivityKind.other,
      };
      for (final entry in cases.entries) {
        mockDevice(connectivity: [entry.key]);
        final status = await NetworkProbeImpl().connectivity();
        expect(status.kind, entry.value, reason: entry.key);
      }
    });

    test('prefers the fastest link when several are up', () async {
      // The order matters: a device on Wi-Fi behind a VPN is diagnosed as a
      // Wi-Fi device, because that is the link whose router we can test.
      mockDevice(connectivity: ['vpn', 'mobile', 'ethernet', 'wifi']);
      expect(
        (await NetworkProbeImpl().connectivity()).kind,
        ConnectivityKind.wifi,
      );
      mockDevice(connectivity: ['vpn', 'mobile', 'ethernet']);
      expect(
        (await NetworkProbeImpl().connectivity()).kind,
        ConnectivityKind.ethernet,
      );
      mockDevice(connectivity: ['vpn', 'mobile']);
      expect(
        (await NetworkProbeImpl().connectivity()).kind,
        ConnectivityKind.mobile,
      );
      mockDevice(connectivity: ['vpn']);
      expect(
        (await NetworkProbeImpl().connectivity()).kind,
        ConnectivityKind.vpn,
      );
    });

    test('a link named none alongside a real one is still that link', () async {
      mockDevice(connectivity: ['none', 'wifi']);
      final status = await NetworkProbeImpl().connectivity();
      expect(status.kind, ConnectivityKind.wifi);
      expect(status.hasLink, isTrue);
    });

    test('an empty answer means no link at all', () async {
      mockDevice(connectivity: []);
      final status = await NetworkProbeImpl().connectivity();
      expect(status.kind, ConnectivityKind.none);
      expect(status.hasLink, isFalse);
    });

    test('reports flight mode from the native side', () async {
      mockDevice(connectivity: ['none'], airplane: true);
      final status = await NetworkProbeImpl().connectivity();
      expect(status.airplaneMode, isTrue);
    });

    test('reads the cellular signal only on a cellular link', () async {
      // Asking on Wi-Fi would put a meaningless bar count in the report and
      // invite "move closer to the window" advice for a wired problem.
      mockDevice(connectivity: ['mobile'], signalLevel: 1);
      final mobile = await NetworkProbeImpl().connectivity();
      expect(mobile.mobileSignalLevel, 1);
      expect(mobile.mobileSignalWeak, isTrue);
      expect(actionCalls, contains('mobileSignalLevel'));

      actionCalls.clear();
      mockDevice(signalLevel: 4);
      final wifi = await NetworkProbeImpl().connectivity();
      expect(wifi.mobileSignalLevel, isNull);
      expect(actionCalls, isNot(contains('mobileSignalLevel')));
    });

    test('leaves the signal unknown when the platform cannot say', () async {
      mockDevice(connectivity: ['mobile']);
      final status = await NetworkProbeImpl().connectivity();
      expect(status.mobileSignalLevel, isNull);
      expect(status.mobileSignalWeak, isFalse);
      expect(status.mobileSignalGood, isFalse);
    });
  });

  group('gatewayIp', () {
    test('reports the router address the platform knows', () async {
      expect(await NetworkProbeImpl().gatewayIp(), '192.168.1.1');
    });

    test('is null when the platform has no address for us', () async {
      mockDevice(gateway: null);
      expect(await NetworkProbeImpl().gatewayIp(), isNull);
      // An empty string is not an address the probe can ping.
      mockDevice(gateway: '');
      expect(await NetworkProbeImpl().gatewayIp(), isNull);
    });

    test('is null — not an error — when the lookup fails', () async {
      // The gateway is simply unknown; the diagnosis continues with the checks
      // that do not need it rather than aborting the whole run.
      mockDevice(gatewayError: PlatformException(code: 'ERR'));
      expect(await NetworkProbeImpl().gatewayIp(), isNull);
    });
  });

  group('tcpReachable', () {
    test('is true for a port something is listening on', () async {
      final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0)
        ..listen((socket) => socket.destroy());
      addTearDown(server.close);

      expect(
        await NetworkProbeImpl().tcpReachable('127.0.0.1', server.port),
        isTrue,
      );
    });

    test('is false for a port nothing is listening on', () async {
      final closed = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      final port = closed.port;
      await closed.close();

      expect(
        await NetworkProbeImpl().tcpReachable('127.0.0.1', port),
        isFalse,
      );
    });
  });

  group('pingReachable', () {
    test('is false when neither ICMP nor TCP gets an answer', () async {
      // Falls all the way through: ping fails, then both TCP fallbacks fail.
      // A host that answers nothing must come back false rather than throwing.
      expect(await NetworkProbeImpl().pingReachable(_unroutable), isFalse);
    }, timeout: const Timeout(Duration(seconds: 60)));
  });

  group('checkCaptivePortal', () {
    /// A probe whose 204 endpoints are answered by [answer].
    NetworkProbeImpl probing(
      Future<http.StreamedResponse> Function(http.BaseRequest) answer,
    ) => NetworkProbeImpl(
      clientFactory: () =>
          MockClient.streaming((request, _) => answer(request)),
      pingRtts: _instantPing,
    );

    http.StreamedResponse response(
      int status, {
      String body = '',
      Map<String, String> headers = const {},
    }) => http.StreamedResponse(
      Stream.value(body.codeUnits),
      status,
      headers: headers,
    );

    test('a clean, empty 204 means real Internet access', () async {
      final result = await probing((_) async => response(204))
          .checkCaptivePortal();
      expect(result.internetOk, isTrue);
      expect(result.portalDetected, isFalse);
      expect(result.portalUrl, isNull);
    });

    test('a redirect is a portal, and names where it points', () async {
      final result = await probing(
        (_) async => response(
          302,
          headers: {'location': 'http://login.hotel.example/'},
        ),
      ).checkCaptivePortal();
      expect(result.internetOk, isFalse);
      expect(result.portalDetected, isTrue);
      expect(result.portalUrl, 'http://login.hotel.example/');
    });

    test('a redirect with no destination falls back to the probe', () async {
      final result = await probing((_) async => response(302))
          .checkCaptivePortal();
      expect(result.portalDetected, isTrue);
      expect(result.portalUrl, kCheck204Endpoints.first.url);
    });

    test('a login page served as 200 is a portal too', () async {
      final result = await probing(
        (_) async => response(200, body: '<html>Sign in</html>'),
      ).checkCaptivePortal();
      expect(result.portalDetected, isTrue);
      expect(result.portalUrl, kCheck204Endpoints.first.url);
    });

    test('a 204 that carries a body is not a clean 204', () async {
      // The status alone is easy for an intercepting proxy to copy; the empty
      // body is the part that actually proves nothing rewrote the answer.
      final result = await probing(
        (_) async => response(204, body: 'x'),
      ).checkCaptivePortal();
      expect(result.portalDetected, isTrue);
    });

    test('one endpoint answering cleanly is enough', () async {
      final result = await probing((request) async {
        if (request.url.host.contains('gstatic')) {
          throw const SocketException('refused');
        }
        return response(204);
      }).checkCaptivePortal();
      expect(result.internetOk, isTrue);
    });

    test('a portal beside a dead endpoint is still a portal', () async {
      final result = await probing((request) async {
        if (request.url.host.contains('gstatic')) {
          throw TimeoutException('too slow');
        }
        return response(302, headers: {'location': 'http://login.example/'});
      }).checkCaptivePortal();
      expect(result.portalDetected, isTrue);
      expect(result.portalUrl, 'http://login.example/');
    });

    test('nothing answering at all means no Internet, not a portal', () async {
      for (final error in <Exception>[
        TimeoutException('too slow'),
        http.ClientException('closed'),
        const SocketException('refused'),
      ]) {
        final result = await probing((_) async => throw error)
            .checkCaptivePortal();
        expect(result.internetOk, isFalse, reason: '$error');
        expect(result.portalDetected, isFalse, reason: '$error');
      }
    });

    test('lists every endpoint it probed, answered or not', () async {
      final probe = probing((_) async => throw const SocketException('no'));
      await probe.checkCaptivePortal();
      final records = probe.dataUsage().records;
      expect(records, hasLength(kCheck204Endpoints.length));
      expect(
        records.every((r) => r.test == 'Internet / captive-portal check'),
        isTrue,
      );
      expect(
        records.map((r) => r.target),
        kCheck204Endpoints.map((e) => Uri.parse(e.url).host),
      );
      // Nothing came back, so nothing is charged to the user's allowance.
      expect(probe.dataUsage().bytesReceived, 0);
    });

    test('counts the bytes an answer actually cost', () async {
      final probe = probing((_) async => response(200, body: 'hello'));
      await probe.checkCaptivePortal();
      expect(probe.dataUsage().bytesReceived, 5 * kCheck204Endpoints.length);
    });
  });

  group('dnsResolves', () {
    test('resolves a name the host itself knows, and records it', () async {
      final probe = NetworkProbeImpl();
      expect(await probe.dnsResolves('localhost'), isTrue);
      final record = probe.dataUsage().records.single;
      expect(record.test, 'DNS resolution');
      expect(record.target, 'localhost');
    });

    test('is false, never an error, for a name that cannot resolve', () async {
      expect(await NetworkProbeImpl().dnsResolves('..'), isFalse);
    });
  });

  group('measureLinkQuality', () {
    test('samples the router and the Internet separately', () async {
      final probe = NetworkProbeImpl(pingRtts: _instantPing);
      final quality = await probe.measureLinkQuality(gatewayIp: '192.168.1.1');

      expect(quality.gateway.sent, kLatencySamples);
      expect(quality.gateway.rttsMs, hasLength(kLatencySamples));
      expect(quality.internet.sent, kLatencySamples);
      expect(quality.internet.avgMs, 12);

      expect(
        probe.dataUsage().records.map((r) => '${r.test}|${r.target}'),
        ['Router latency|192.168.1.1', 'Internet latency|$kLatencyProbeHost'],
      );
    });

    test('skips the router when there is no address to ping', () async {
      final probe = NetworkProbeImpl(pingRtts: _instantPing);
      final quality = await probe.measureLinkQuality();

      expect(quality.gateway.sent, 0);
      expect(quality.gateway.rttsMs, isEmpty);
      expect(quality.internet.sent, kLatencySamples);
      // Only the Internet sample cost anything, so only it is listed.
      expect(
        probe.dataUsage().records.map((r) => r.test),
        ['Internet latency'],
      );
    });

    test('charges for what was sent, not for what came back', () async {
      // Half the probes are lost here; billing the user for ten replies that
      // never arrived would make the transparency list a fiction.
      final probe = NetworkProbeImpl(
        pingRtts: (host, {required count, required interval}) async =>
            List<double>.filled(count ~/ 2, 8),
      );
      await probe.measureLinkQuality();
      final record = probe.dataUsage().records.single;
      expect(record.bytesSent, 64 * kLatencySamples);
      expect(record.bytesReceived, 64 * (kLatencySamples ~/ 2));
    });

    test('a link that answered nothing still reports the attempt', () async {
      final probe = NetworkProbeImpl(
        pingRtts: (host, {required count, required interval}) async => [],
      );
      final quality = await probe.measureLinkQuality();
      expect(quality.internet.sent, kLatencySamples);
      expect(quality.internet.rttsMs, isEmpty);
      expect(probe.dataUsage().records.single.bytesReceived, 0);
    });
  });

  group('detectCountryCode', () {
    NetworkProbeImpl tracing(String body, {int status = 200}) =>
        NetworkProbeImpl(
          clientFactory: () =>
              MockClient((_) async => http.Response(body, status)),
          pingRtts: _instantPing,
        );

    test('reads the location out of the Cloudflare trace', () async {
      final probe = tracing('fl=abc\nip=1.2.3.4\nloc=IL\ncolo=TLV\n');
      expect(await probe.detectCountryCode(), 'IL');
      final record = probe.dataUsage().records.single;
      expect(record.test, 'Country detection');
      expect(record.target, 'www.cloudflare.com');
      expect(record.bytesReceived, greaterThan(0));
    });

    test('upper-cases and trims what the service sent', () async {
      expect(await tracing('loc=il  \n').detectCountryCode(), 'IL');
    });

    test('is null when no location was reported', () async {
      expect(await tracing('fl=abc\nip=1.2.3.4\n').detectCountryCode(), isNull);
      expect(await tracing('loc=\n').detectCountryCode(), isNull);
      expect(await tracing('').detectCountryCode(), isNull);
    });

    test('is null when the service refused', () async {
      expect(await tracing('loc=IL', status: 503).detectCountryCode(), isNull);
    });

    test('is null when the request never got through', () async {
      for (final error in <Exception>[
        TimeoutException('too slow'),
        http.ClientException('closed'),
        const SocketException('refused'),
      ]) {
        final probe = NetworkProbeImpl(
          clientFactory: () => MockClient((_) async => throw error),
          pingRtts: _instantPing,
        );
        expect(await probe.detectCountryCode(), isNull, reason: '$error');
      }
    });
  });

  group('tracePath', () {
    test('reports no route when the destination cannot be resolved', () async {
      // The trace never starts, so there is no last responding hop to name —
      // and the failure comes back as a result, not an exception.
      final probe = NetworkProbeImpl();
      final result = await probe.tracePath('..');
      expect(result.reachedDestination, isFalse);
      expect(result.lastRespondingHop, isNull);
      expect(result.firstDeadHop, isNull);
      // The attempt is listed even though it produced nothing.
      final record = probe.dataUsage().records.single;
      expect(record.test, 'Route to the Internet (traceroute)');
      expect(record.target, '..');
    });
  });

  group('probeCommonPorts', () {
    test('probes each well-known port and lists what it tried', () async {
      // Reachability depends on the network this runs on, so the assertions are
      // about which ports were probed and that each one was accounted for.
      final probe = NetworkProbeImpl();
      final results = await probe.probeCommonPorts();

      expect(
        results.map((r) => '${r.port}/${r.service}'),
        kPortProbeTargets.map((t) => '${t.port}/${t.service}'),
      );
      expect(
        probe.dataUsage().records.map((r) => r.target),
        kPortProbeTargets.map((t) => t.host),
      );
    }, timeout: const Timeout(Duration(seconds: 60)));
  });

  group('checkPopularSites', () {
    test('probes the sites chosen for the country it was given', () async {
      // As above: which sites were picked is the logic under test, not whether
      // this machine can currently reach them.
      final probe = NetworkProbeImpl();
      final results = await probe.checkPopularSites('GB');
      final expected = PopularSites.targetsFor('GB');

      expect(results.map((r) => r.host), expected.map((s) => s.host));
      expect(results.map((r) => r.label), expected.map((s) => s.label));
      final record = probe.dataUsage().records.single;
      expect(
        record.test,
        'Popular sites reachability (${expected.length})',
      );
      expect(record.target, 'port 443');
    }, timeout: const Timeout(Duration(seconds: 60)));

    test('falls back to the global baseline without a country', () async {
      final probe = NetworkProbeImpl();
      final results = await probe.checkPopularSites(null);
      expect(
        results.map((r) => r.host),
        PopularSites.targetsFor(null).map((s) => s.host),
      );
      expect(results, isNotEmpty);
    }, timeout: const Timeout(Duration(seconds: 60)));
  });
}
