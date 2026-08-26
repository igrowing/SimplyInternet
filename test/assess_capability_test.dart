import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/capability.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/link_quality.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict_catalog.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/assess_capability.dart';

LinkQuality _quality({
  required List<double> internetRtts,
  int sent = 10,
  List<double> gatewayRtts = const [2, 2, 3, 2],
  double? loadedRttMs,
}) {
  return LinkQuality(
    gateway: LatencyStats(sent: gatewayRtts.length, rttsMs: gatewayRtts),
    internet: LatencyStats(sent: sent, rttsMs: internetRtts),
    loadedRttMs: loadedRttMs,
  );
}

void main() {
  const assess = AssessCapability();

  group('AssessCapability', () {
    test('a fast, clean link supports everything', () {
      final result = assess(
        speed: const SpeedResult(downloadMbps: 200, ok: true, uploadMbps: 50),
        quality: _quality(internetRtts: const [8, 9, 8, 9, 8, 9, 8, 9, 8, 9]),
      );
      expect(result.kind, CapabilityCase.good);
      expect(result.unsupported, isEmpty);
      expect(result.uploadMeasured, isTrue);
    });

    test('names only the few activities a modest link cannot carry', () {
      final result = assess(
        speed: const SpeedResult(downloadMbps: 8, ok: true, uploadMbps: 2),
        quality: _quality(
          internetRtts: const [30, 32, 31, 33, 30, 31, 32, 30, 31, 32],
        ),
      );
      expect(result.kind, CapabilityCase.mostlyGood);
      expect(result.supported.map((o) => o.name), contains('HD video (1080p)'));
      expect(result.unsupported.map((o) => o.name), contains('4K video'));
    });

    test('heavy loss and jitter degrade a link that is otherwise fast', () {
      final result = assess(
        speed: const SpeedResult(downloadMbps: 90, ok: true, uploadMbps: 30),
        quality: _quality(internetRtts: const [200, 500, 210, 480]),
      );
      expect(result.kind, CapabilityCase.degraded);
      expect(
        result.worstShortfalls.map((s) => s.metric),
        containsAll(<String>['loss', 'jitter', 'latency']),
      );
      expect(result.throughputOnlyProblem, isFalse);
    });

    test('the weak-signal case fails the demanding activities', () {
      // The reported scenario: 45 Mbps link dropped to ~6 Mbps outdoors.
      final result = assess(
        speed: const SpeedResult(downloadMbps: 5.7, ok: true, uploadMbps: 1.2),
        quality: _quality(
          internetRtts: const [60, 120, 70, 140, 65, 130, 68, 125],
        ),
      );
      expect(result.kind, CapabilityCase.degraded);
      expect(
        result.unsupported.map((o) => o.name),
        containsAll(<String>['4K video', 'fast online games']),
      );
    });

    test('advises turning the camera off when only video calls fail', () {
      final result = assess(
        speed: const SpeedResult(downloadMbps: 3, ok: true, uploadMbps: 0.6),
        quality: _quality(
          internetRtts: const [40, 42, 41, 43, 40, 41, 42, 40, 41, 42],
        ),
      );
      expect(result.voiceCallStillFits, isTrue);
      final verdict = VerdictCatalog.capability(
        assessment: result,
        medium: ConnectivityKind.wifi,
        speed: const SpeedResult(downloadMbps: 3, ok: true, uploadMbps: 0.6),
        quality: _quality(
          internetRtts: const [40, 42, 41, 43, 40, 41, 42, 40, 41, 42],
        ),
      );
      // The rescue tip is an action, so it belongs in the advice, not in
      // the explanation of what was measured.
      expect(verdict.solution!.message, contains('Turn your camera off'));
      expect(verdict.verdict.detail, isNot(contains('Turn your camera off')));
    });

    test('does not judge upload limits when upload was not measured', () {
      final result = assess(
        speed: const SpeedResult(downloadMbps: 100, ok: true),
        quality: _quality(
          internetRtts: const [10, 11, 10, 11, 10, 11, 10, 11, 10, 11],
        ),
      );
      expect(result.uploadMeasured, isFalse);
      expect(result.kind, CapabilityCase.good);
    });

    test('skips metrics that could not be measured at all', () {
      final result = assess(
        speed: const SpeedResult.unavailable(),
        quality: const LinkQuality.unavailable(),
      );
      expect(result.latencyMeasured, isFalse);
      expect(result.kind, CapabilityCase.good);
      expect(result.unsupported, isEmpty);
    });

    test('flags throughput-only shortfalls as the only shaping evidence', () {
      final result = assess(
        speed: const SpeedResult(downloadMbps: 1.2, ok: true, uploadMbps: 0.6),
        quality: _quality(
          internetRtts: const [12, 13, 12, 13, 12, 13, 12, 13, 12, 13],
        ),
      );
      expect(result.throughputOnlyProblem, isTrue);
    });
  });

  group('VerdictCatalog.capability', () {
    const good = SpeedResult(downloadMbps: 200, ok: true, uploadMbps: 50);
    final cleanQuality = _quality(
      internetRtts: const [8, 9, 8, 9, 8, 9, 8, 9, 8, 9],
    );

    test('case A states the medium and needs no remedy', () {
      final assessment = assess(speed: good, quality: cleanQuality);
      final out = VerdictCatalog.capability(
        assessment: assessment,
        medium: ConnectivityKind.wifi,
        speed: good,
        quality: cleanQuality,
      );
      expect(out.verdict.category, VerdictCategory.connectionGood);
      expect(out.verdict.title, startsWith('Your Wi-Fi is good for'));
      expect(out.verdict.detail, contains('Measured over Wi-Fi'));
      expect(out.verdict.detail, contains('download 200 Mbps'));
      expect(out.solution, isNull);
    });

    test('case C blames the router when the local hop is the weak part', () {
      const speed = SpeedResult(downloadMbps: 4, ok: true, uploadMbps: 0.4);
      final quality = _quality(
        internetRtts: const [300, 600, 320],
        gatewayRtts: const [80, 200, 90],
      );
      final assessment = assess(speed: speed, quality: quality);
      final out = VerdictCatalog.capability(
        assessment: assessment,
        medium: ConnectivityKind.wifi,
        speed: speed,
        quality: quality,
      );
      expect(out.verdict.category, VerdictCategory.connectionDegraded);
      expect(out.verdict.title, contains('too weak for'));
      expect(out.solution!.message, contains('Move closer'));
    });

    test('says out loud when upload was not measured', () {
      const speed = SpeedResult(downloadMbps: 1, ok: true);
      final quality = _quality(internetRtts: const [400, 900, 420]);
      final assessment = assess(speed: speed, quality: quality);
      final out = VerdictCatalog.capability(
        assessment: assessment,
        medium: ConnectivityKind.mobile,
        speed: speed,
        quality: quality,
      );
      expect(out.verdict.detail, contains('not assessed'));
      // Only the metrics that failed the criteria are spelled out.
      expect(out.verdict.detail, contains('packet loss'));
      expect(out.verdict.detail, isNot(contains('download 1.0 Mbps')));
      expect(out.verdict.title, contains('mobile data'));
    });
  });
}
