import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/use_case_requirements.dart';

/// How good the working connection is, once the hard-failure decision tree has
/// found nothing broken.
///
/// A broken connection is not represented here: with no usable link there is
/// nothing to measure, so the diagnosis reports its single hard verdict instead
/// and never prints a capability list.
enum CapabilityCase {
  /// Every activity fits.
  good,

  /// A handful of activities do not fit; name only those.
  mostlyGood,

  /// Most activities do not fit; name the worst.
  degraded,
}

/// Which measurement fell short, by how much, in words the user can act on.
@immutable
class Shortfall extends Equatable {
  const Shortfall({
    required this.metric,
    required this.text,
    required this.ratio,
  });

  /// Short metric name: 'download', 'upload', 'latency', 'jitter', 'loss'.
  final String metric;

  /// Display form including the measured value, e.g. 'jitter 45 ms'.
  final String text;

  /// How badly the limit was missed, as a multiple (>1). Used for ranking.
  final double ratio;

  @override
  List<Object?> get props => [metric, text, ratio];
}

/// Verdict for a single activity.
@immutable
class UseCaseOutcome extends Equatable {
  const UseCaseOutcome({required this.requirement, required this.shortfalls});

  final UseCaseRequirement requirement;

  /// Empty when the activity is supported.
  final List<Shortfall> shortfalls;

  bool get supported => shortfalls.isEmpty;

  String get name => requirement.name;

  /// The worst miss across all metrics; 1 when supported.
  double get worstRatio => shortfalls.isEmpty
      ? 1
      : shortfalls.map((s) => s.ratio).reduce((a, b) => a > b ? a : b);

  @override
  List<Object?> get props => [requirement, shortfalls];
}

/// What the connection can and cannot do right now.
@immutable
class CapabilityAssessment extends Equatable {
  const CapabilityAssessment({
    required this.kind,
    required this.outcomes,
    required this.uploadMeasured,
    required this.latencyMeasured,
  });

  final CapabilityCase kind;

  /// One outcome per activity, in requirement order.
  final List<UseCaseOutcome> outcomes;

  /// False when the upload probe could not run: upload limits were then not
  /// judged at all, and the report must say so rather than imply a pass.
  final bool uploadMeasured;

  /// False when no latency samples came back (ICMP blocked, for example).
  final bool latencyMeasured;

  List<UseCaseOutcome> get supported =>
      outcomes.where((o) => o.supported).toList();

  /// Unsupported activities, worst miss first.
  List<UseCaseOutcome> get unsupported {
    final list = outcomes.where((o) => !o.supported).toList()
      ..sort((a, b) => b.worstRatio.compareTo(a.worstRatio));
    return list;
  }

  /// The distinct measurements to blame, worst first — the subline that turns a
  /// verdict into an action ("unstable" points somewhere different to "slow").
  List<Shortfall> get worstShortfalls {
    final byMetric = <String, Shortfall>{};
    for (final outcome in unsupported) {
      for (final s in outcome.shortfalls) {
        final seen = byMetric[s.metric];
        if (seen == null || s.ratio > seen.ratio) byMetric[s.metric] = s;
      }
    }
    final list = byMetric.values.toList()
      ..sort((a, b) => b.ratio.compareTo(a.ratio));
    return list;
  }

  /// True when video calls do not fit but a voice-only call still would — the
  /// one piece of advice that rescues someone mid-meeting.
  bool get voiceCallStillFits {
    final videoFails = outcomes.any(
      (o) => !o.supported && kVideoCallUseCases.contains(o.name),
    );
    final voiceOk = outcomes.any(
      (o) => o.supported && o.name == kVoiceCallUseCase,
    );
    return videoFails && voiceOk;
  }

  /// True when every miss is a throughput miss while latency, jitter and loss
  /// all stayed inside their limits — the only shape of evidence that makes
  /// "possible throttling" worth mentioning at all.
  bool get throughputOnlyProblem {
    final failing = unsupported;
    if (failing.isEmpty) return false;
    return failing.every(
      (o) => o.shortfalls.every(
        (s) => s.metric == 'download' || s.metric == 'upload',
      ),
    );
  }

  @override
  List<Object?> get props => [kind, outcomes, uploadMeasured, latencyMeasured];
}
