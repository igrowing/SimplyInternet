import 'package:flutter/material.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/capability.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/diagnosis_report.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/technical_details.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/verdict_visuals.dart';

/// Renders a finished [DiagnosisReport]: the verdict headline, the plain
/// solution text, and one button per suggested action (asking for
/// confirmation before performing anything on the device).
class ResultView extends StatelessWidget {
  const ResultView({required this.report, required this.controller, super.key});

  final DiagnosisReport report;
  final DiagnosisController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verdict = report.verdict;
    final color = VerdictVisuals.colorFor(verdict.category);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Icon(VerdictVisuals.iconFor(verdict.category), size: 72, color: color),
        const SizedBox(height: 12),
        Text(
          verdict.title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          verdict.detail,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 24),
        if (report.capability != null) ...[
          _CapabilityList(assessment: report.capability!),
          const SizedBox(height: 16),
        ],
        if (report.solution != null) ...[
          Card(
            color: theme.colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.build_circle_outlined),
                      const SizedBox(width: 8),
                      Text('What to do', style: theme.textTheme.titleMedium),
                    ],
                  ),
                  if (report.solution!.message.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      report.solution!.message,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 12),
                  ...report.solution!.actions.map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonalIcon(
                          onPressed: () => _onAction(context, a),
                          icon: Icon(_actionIcon(a.type)),
                          label: Text(a.label),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        OutlinedButton.icon(
          onPressed: controller.reset,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Back'),
        ),
        const SizedBox(height: 8),
        TechnicalDetails(log: report.log),
      ],
    );
  }

  Future<void> _onAction(BuildContext context, SolutionAction action) async {
    final messenger = ScaffoldMessenger.of(context);
    if (action.confirmBeforeAct) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(action.confirmationPrompt ?? action.label),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Not now'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    try {
      final done = await controller.performAction(action);
      if (!done) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Nothing to open for this step.')),
        );
      }
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not complete that action: $e')),
      );
    }
  }

  IconData _actionIcon(SolutionActionType type) {
    switch (type) {
      case SolutionActionType.enableWifi:
        return Icons.wifi;
      case SolutionActionType.disableAirplane:
        return Icons.airplanemode_off;
      case SolutionActionType.enableMobileData:
        return Icons.signal_cellular_alt;
      case SolutionActionType.openCaptivePortal:
        return Icons.open_in_browser;
      case SolutionActionType.changeDns:
        return Icons.dns;
      case SolutionActionType.retry:
        return Icons.refresh;
      case SolutionActionType.retestOverMobile:
        return Icons.signal_cellular_alt;
      case SolutionActionType.retestOverWifi:
        return Icons.wifi;
      case SolutionActionType.advisory:
        return Icons.info_outline;
    }
  }
}

/// The full "good for …" list, collapsed by default: the headline already names
/// the few activities that matter, this is for the user who wants all of them.
class _CapabilityList extends StatelessWidget {
  const _CapabilityList({required this.assessment});

  final CapabilityAssessment assessment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fits = assessment.supported.length;
    return ExpansionTile(
      title: Text(
        'What your connection can do ($fits of '
        '${assessment.outcomes.length})',
      ),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 8),
      children: [
        for (final outcome in assessment.outcomes)
          ListTile(
            dense: true,
            leading: Icon(
              outcome.supported ? Icons.check_circle : Icons.cancel,
              color: outcome.supported
                  ? Colors.green.shade700
                  : Colors.amber.shade800,
            ),
            title: Text(outcome.name),
            subtitle: outcome.supported
                ? null
                : Text(
                    outcome.shortfalls.map((s) => s.text).join(', '),
                    style: theme.textTheme.bodySmall,
                  ),
          ),
        if (!assessment.uploadMeasured)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'Upload could not be measured, therefore not assessed.',
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
