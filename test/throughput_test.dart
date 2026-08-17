import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:simply_internet/features/diagnostics/data/repositories/network_probe_impl.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/check_endpoints.dart';

/// Serves [payload] for the download and accepts every upload, recording the
/// order of the requests so the sequence can be asserted.
MockClient _server({
  required List<int> payload,
  required List<String> hits,
  int downloadStatus = 200,
}) {
  return MockClient((request) async {
    hits.add('${request.method} ${request.url.path}');
    if (request.url.path.contains('__down')) {
      return http.Response.bytes(payload, downloadStatus);
    }
    return http.Response('ok', 200);
  });
}

/// Round-trip times that arrive instantly, so the tests measure behaviour
/// rather than the clock.
///
/// The download probe pings while the line is busy and waits for the answer, so
/// replacing only the HTTP client leaves the tests shelling out to `ping`
/// against a public address. Where ICMP is dropped — CI runners typically drop
/// it — one sample set falls back to ten sequential probes and costs tens of
/// seconds of timeouts, which is what pushed these tests past the 30 s limit
/// while they passed on a developer machine.
const double kFakeRttMs = 12;

Future<List<double>> _instantPing(
  String host, {
  required int count,
  required Duration interval,
}) async => List<double>.filled(count, kFakeRttMs);

/// A body that starts arriving and then dies, the way a connection dropped
/// part way through a transfer does. The status line was already 200, so the
/// probe has committed to measuring before anything goes wrong.
Stream<List<int>> _dyingBody() async* {
  yield Uint8List(1000);
  throw http.ClientException('connection closed mid-stream');
}

/// A probe wired to the mock server and the instant pinger — no real network.
NetworkProbeImpl _probe({
  required List<int> payload,
  List<String>? hits,
  int downloadStatus = 200,
  PingRtts? pingRtts,
}) {
  return NetworkProbeImpl(
    clientFactory: () => _server(
      payload: payload,
      hits: hits ?? <String>[],
      downloadStatus: downloadStatus,
    ),
    pingRtts: pingRtts ?? _instantPing,
  );
}

void main() {
  group('measureThroughput', () {
    test('reports the rate of the bytes that actually arrived', () async {
      final probe = _probe(payload: Uint8List(2 * 1000 * 1000));
      final result = await probe.measureThroughput();
      expect(result.ok, isTrue);
      expect(result.downloadMbps, greaterThan(0));
      expect(result.bytesReceived, greaterThanOrEqualTo(2 * 1000 * 1000));
      expect(result.uploadMbps, isNotNull);
      expect(result.bytesSent, greaterThanOrEqualTo(kUploadChunkBytes));
      // Sampled while the transfer was running, so it is the busy figure the
      // bufferbloat comparison is built on.
      expect(result.loadedRttMs, kFakeRttMs);
    });

    test('downloads before uploading, never both at once', () async {
      final hits = <String>[];
      final probe = _probe(payload: Uint8List(2 * 1000 * 1000), hits: hits);
      await probe.measureThroughput();
      final firstUpload = hits.indexWhere((h) => h.contains('__up'));
      final lastDownload = hits.lastIndexWhere((h) => h.contains('__down'));
      expect(firstUpload, greaterThan(lastDownload));
    });

    test('a refused request is not reported as a very slow link', () async {
      // The service answers oversized requests with 403 and a one-byte body.
      // Counting that body as the sample yielded a bogus 0.0 Mbps and a
      // "your Wi-Fi is too weak" verdict on a perfectly fast connection.
      final hits = <String>[];
      final probe = _probe(
        payload: utf8.encode('0'),
        downloadStatus: 403,
        hits: hits,
      );
      final result = await probe.measureThroughput();
      expect(result.ok, isFalse);
      expect(result.downloadMbps, 0);
      expect(hits.any((h) => h.contains('__up')), isFalse);
    });

    test('asks only for a size the service serves', () async {
      final probe = _probe(payload: Uint8List(1000 * 1000));
      await probe.measureThroughput();
      expect(kDownloadChunkBytes, lessThanOrEqualTo(25 * 1000 * 1000));
    });

    test('accounts for the bytes each test moved', () async {
      final probe = _probe(payload: Uint8List(1000 * 1000));
      await probe.measureThroughput();
      final usage = probe.dataUsage();
      expect(
        usage.records.map((r) => r.test),
        containsAll(<String>['Download speed', 'Upload speed']),
      );
      expect(usage.bytesReceived, greaterThan(0));
      expect(usage.bytesSent, greaterThan(0));
      // The speed figures and the aggregate must be drawn from the same
      // records, or the two sections of the report contradict each other.
      final result = await probe.measureThroughput();
      final download = probe.dataUsage().records.lastWhere(
        (r) => r.test == 'Download speed',
      );
      final upload = probe.dataUsage().records.lastWhere(
        (r) => r.test == 'Upload speed',
      );
      expect(download.bytesReceived, result.bytesReceived);
      expect(upload.bytesSent, result.bytesSent);
      // The pings taken while the line is busy cost packets too, so they are
      // listed like every other test instead of vanishing from the total.
      expect(
        probe.dataUsage().records.map((r) => r.test),
        contains('Response time while the line is busy'),
      );
    });

    test('does not sample the busy line when nothing was downloaded', () async {
      // The sample used to start before the first request and was abandoned
      // when the service refused it. It went on pinging for as long as its
      // probes took to time out and then recorded itself — into whichever run
      // was current by then, so a report that downloaded nothing could show a
      // busy-line measurement taken during the previous test.
      var pings = 0;
      final probe = _probe(
        payload: utf8.encode('0'),
        downloadStatus: 403,
        pingRtts: (host, {required count, required interval}) async {
          pings++;
          return List<double>.filled(count, kFakeRttMs);
        },
      );
      final result = await probe.measureThroughput();
      expect(result.ok, isFalse);
      expect(result.loadedRttMs, isNull);
      expect(pings, 0);
      expect(
        probe.dataUsage().records.map((r) => r.test),
        isNot(contains('Response time while the line is busy')),
      );
    });

    test('waits for a sample under way when the transfer dies', () async {
      // The refusal path never starts a sample, but a transfer that answered
      // 200 and then broke has one in flight. Abandoning it left it pinging on
      // its own and recording itself whenever its probes finally timed out —
      // by which time the next diagnosis could already own the list.
      //
      // The ping is held open here, so "did the probe wait for it" is decided
      // by this test rather than by how long a real ping happens to take.
      final release = Completer<void>();
      var pingFinished = false;
      final probe = NetworkProbeImpl(
        clientFactory: () => MockClient.streaming(
          (request, body) async => http.StreamedResponse(_dyingBody(), 200),
        ),
        pingRtts: (host, {required count, required interval}) async {
          await release.future;
          pingFinished = true;
          return List<double>.filled(count, kFakeRttMs);
        },
      );

      final pending = probe.measureThroughput();
      var settled = false;
      unawaited(pending.whenComplete(() => settled = true));
      await pumpEventQueue();

      // The transfer has failed by now and everything that can proceed has.
      expect(pingFinished, isFalse);
      expect(
        settled,
        isFalse,
        reason: 'the probe returned while its latency sample was still running',
      );

      release.complete();
      final result = await pending;

      expect(result.ok, isFalse);
      expect(pingFinished, isTrue);
      // The sample belongs to the run that started it, so its record is in
      // place by the time the probe hands back — it can never be appended to
      // a later run's list.
      expect(
        probe.dataUsage().records.map((r) => r.test),
        contains('Response time while the line is busy'),
      );
    });

    test('records the bytes of a transfer that was cut short', () async {
      final probe = _probe(payload: Uint8List(1000), downloadStatus: 500);
      final result = await probe.measureThroughput();
      expect(result.ok, isFalse);
      // A refusal still cost a request: it belongs in the transparency list.
      expect(
        probe.dataUsage().records.map((r) => r.test),
        contains('Download speed'),
      );
    });

    test('a download that never got through reports nothing', () async {
      // Each transport failure is absorbed into "unavailable" rather than
      // escaping: a diagnosis that cannot measure the line still has a verdict
      // to give about everything else it checked.
      for (final error in <Exception>[
        TimeoutException('too slow'),
        http.ClientException('closed'),
        const SocketException('refused'),
      ]) {
        final probe = NetworkProbeImpl(
          clientFactory: () => MockClient((_) async => throw error),
          pingRtts: _instantPing,
        );
        final result = await probe.measureThroughput();
        expect(result.ok, isFalse, reason: '$error');
        expect(result.uploadMbps, isNull, reason: '$error');
        // The failed attempt is still listed, with the nothing it moved.
        expect(
          probe.dataUsage().records.map((r) => r.test),
          contains('Download speed'),
          reason: '$error',
        );
      }
    });

    test('an upload that failed leaves the download figure standing', () async {
      // The two directions are measured separately on purpose; losing the
      // upload must not discard a download rate that was measured fine.
      for (final error in <Exception>[
        TimeoutException('too slow'),
        http.ClientException('closed'),
        const SocketException('refused'),
      ]) {
        final probe = NetworkProbeImpl(
          clientFactory: () => MockClient((request) async {
            if (request.url.path.contains('__up')) throw error;
            return http.Response.bytes(Uint8List(1000 * 1000), 200);
          }),
          pingRtts: _instantPing,
        );
        final result = await probe.measureThroughput();
        expect(result.ok, isTrue, reason: '$error');
        expect(result.downloadMbps, greaterThan(0), reason: '$error');
        expect(result.uploadMbps, isNull, reason: '$error');
        expect(result.bytesSent, 0, reason: '$error');
      }
    });

    test('an upload the server refuses stops rather than looping', () async {
      final probe = NetworkProbeImpl(
        clientFactory: () => MockClient((request) async {
          if (request.url.path.contains('__up')) {
            return http.Response('too large', 413);
          }
          return http.Response.bytes(Uint8List(1000 * 1000), 200);
        }),
        pingRtts: _instantPing,
      );
      final result = await probe.measureThroughput();
      expect(result.ok, isTrue);
      // Nothing was accepted, so there is no rate to report — and no figure
      // invented from the bytes we pushed at a server that rejected them.
      expect(result.uploadMbps, isNull);
      expect(result.bytesSent, 0);
    });

    test('resetUsage empties the recorded tests', () async {
      final probe = _probe(payload: Uint8List(1000 * 1000));
      await probe.measureThroughput();
      expect(probe.dataUsage().records, isNotEmpty);
      probe.resetUsage();
      expect(probe.dataUsage().records, isEmpty);
      expect(probe.dataUsage().bytesReceived, 0);
      expect(probe.dataUsage().bytesSent, 0);
    });
  });
}
