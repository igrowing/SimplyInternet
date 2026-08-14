import 'package:simply_internet/features/diagnostics/domain/entities/capability.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/check_endpoints.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/link_quality.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/use_case_requirements.dart';

/// Turns raw measurements into "what can this connection actually do".
///
/// Pure and synchronous: every input is a measured fact, and a metric that was
/// not measured is skipped rather than assumed to pass — the assessment records
/// which ones were missing so the report can say so out loud.
class AssessCapability {
  const AssessCapability();

  CapabilityAssessment call({
    required SpeedResult speed,
    required LinkQuality quality,
  }) {
    final down = speed.ok ? speed.downloadMbps : null;
    final up = speed.uploadMbps;
    final rtt = quality.internet.avgMs;
    final jitter = quality.internet.jitterMs;
    final loss = quality.internet.ok ? quality.internet.lossPercent : null;

    final outcomes = [
      for (final requirement in kUseCaseRequirements)
        UseCaseOutcome(
          requirement: requirement,
          shortfalls: _shortfalls(
            requirement,
            down: down,
            up: up,
            rtt: rtt,
            jitter: jitter,
            loss: loss,
          ),
        ),
    ];

    final failing = outcomes.where((o) => !o.supported).length;
    final CapabilityCase kind;
    if (failing == 0) {
      kind = CapabilityCase.good;
    } else if (failing <= kMostlyGoodFailureLimit &&
        failing < outcomes.length) {
      kind = CapabilityCase.mostlyGood;
    } else {
      kind = CapabilityCase.degraded;
    }

    return CapabilityAssessment(
      kind: kind,
      outcomes: outcomes,
      uploadMeasured: up != null,
      latencyMeasured: quality.internet.ok,
    );
  }

  List<Shortfall> _shortfalls(
    UseCaseRequirement r, {
    required double? down,
    required double? up,
    required double? rtt,
    required double? jitter,
    required double? loss,
  }) {
    final out = <Shortfall>[];

    if (down != null && down < r.downMbps) {
      out.add(
        Shortfall(
          metric: 'download',
          text: 'download ${_mbps(down)} Mbps',
          ratio: r.downMbps / _atLeastTiny(down),
        ),
      );
    }
    if (up != null && up < r.upMbps) {
      out.add(
        Shortfall(
          metric: 'upload',
          text: 'upload ${_mbps(up)} Mbps',
          ratio: r.upMbps / _atLeastTiny(up),
        ),
      );
    }
    final maxRtt = r.maxRttMs;
    if (maxRtt != null && rtt != null && rtt > maxRtt) {
      out.add(
        Shortfall(
          metric: 'latency',
          text: 'latency ${rtt.round()} ms',
          ratio: rtt / maxRtt,
        ),
      );
    }
    final maxJitter = r.maxJitterMs;
    if (maxJitter != null && jitter != null && jitter > maxJitter) {
      out.add(
        Shortfall(
          metric: 'jitter',
          text: 'jitter ${jitter.round()} ms',
          ratio: jitter / maxJitter,
        ),
      );
    }
    final maxLoss = r.maxLossPercent;
    if (maxLoss != null && loss != null && loss > maxLoss) {
      out.add(
        Shortfall(
          metric: 'loss',
          text: 'packet loss ${loss.round()}%',
          ratio: loss / maxLoss,
        ),
      );
    }
    return out;
  }

  /// Guards the ranking ratio against a division by an (almost) zero rate.
  static double _atLeastTiny(double value) => value < 0.01 ? 0.01 : value;

  /// Rates are shown without decimals above 10 Mbps, where a fraction adds
  /// nothing, and with one below it, where it still carries information.
  static String _mbps(double value) =>
      value >= 10 ? value.round().toString() : value.toStringAsFixed(1);
}
