import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';

/// The full result of a diagnosis run: the single [verdict], its [solution]
/// (absent only when everything is healthy) and the ordered [log] of the
/// checks that were performed, for transparency and support.
@immutable
class DiagnosisReport extends Equatable {
  const DiagnosisReport({
    required this.verdict,
    this.solution,
    this.log = const [],
  });

  final Verdict verdict;
  final Solution? solution;
  final List<String> log;

  @override
  List<Object?> get props => [verdict, solution, log];
}
