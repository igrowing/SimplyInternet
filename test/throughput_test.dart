import 'dart:convert';
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

void main() {
  group('measureThroughput', () {
    test('reports the rate of the bytes that actually arrived', () async {
      final hits = <String>[];
      final probe = NetworkProbeImpl(
        clientFactory: () =>
            _server(payload: Uint8List(2 * 1000 * 1000), hits: hits),
      );
      final result = await probe.measureThroughput();
      expect(result.ok, isTrue);
      expect(result.downloadMbps, greaterThan(0));
      expect(result.bytesReceived, greaterThanOrEqualTo(2 * 1000 * 1000));
      expect(result.uploadMbps, isNotNull);
      expect(result.bytesSent, greaterThanOrEqualTo(kUploadChunkBytes));
    });

    test('downloads before uploading, never both at once', () async {
      final hits = <String>[];
      final probe = NetworkProbeImpl(
        clientFactory: () =>
            _server(payload: Uint8List(2 * 1000 * 1000), hits: hits),
      );
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
      final probe = NetworkProbeImpl(
        clientFactory: () =>
            _server(payload: utf8.encode('0'), downloadStatus: 403, hits: hits),
      );
      final result = await probe.measureThroughput();
      expect(result.ok, isFalse);
      expect(result.downloadMbps, 0);
      expect(hits.any((h) => h.contains('__up')), isFalse);
    });

    test('asks only for a size the service serves', () async {
      final hits = <String>[];
      final probe = NetworkProbeImpl(
        clientFactory: () =>
            _server(payload: Uint8List(1000 * 1000), hits: hits),
      );
      await probe.measureThroughput();
      expect(kDownloadChunkBytes, lessThanOrEqualTo(25 * 1000 * 1000));
    });

    test('accounts for the bytes each test moved', () async {
      final hits = <String>[];
      final probe = NetworkProbeImpl(
        clientFactory: () =>
            _server(payload: Uint8List(1000 * 1000), hits: hits),
      );
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

    test('records the bytes of a transfer that was cut short', () async {
      final probe = NetworkProbeImpl(
        clientFactory: () => _server(
          payload: Uint8List(1000),
          hits: <String>[],
          downloadStatus: 500,
        ),
      );
      final result = await probe.measureThroughput();
      expect(result.ok, isFalse);
      // A refusal still cost a request: it belongs in the transparency list.
      expect(
        probe.dataUsage().records.map((r) => r.test),
        contains('Download speed'),
      );
    });

    test('resetUsage empties the recorded tests', () async {
      final probe = NetworkProbeImpl(
        clientFactory: () =>
            _server(payload: Uint8List(1000 * 1000), hits: <String>[]),
      );
      await probe.measureThroughput();
      expect(probe.dataUsage().records, isNotEmpty);
      probe.resetUsage();
      expect(probe.dataUsage().records, isEmpty);
      expect(probe.dataUsage().bytesReceived, 0);
      expect(probe.dataUsage().bytesSent, 0);
    });
  });
}
