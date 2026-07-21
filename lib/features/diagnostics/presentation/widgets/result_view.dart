import 'package:flutter/material.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/diagnosis_report.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
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
                  const SizedBox(height: 8),
                  Text(
                    report.solution!.message,
                    style: theme.textTheme.bodyMedium,
                  ),
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
        _DiagnosticLog(log: report.log),
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
      case SolutionActionType.advisory:
        return Icons.info_outline;
    }
  }
}

class _DiagnosticLog extends StatelessWidget {
  const _DiagnosticLog({required this.log});

  final List<String> log;

  @override
  Widget build(BuildContext context) {
    if (log.isEmpty) return const SizedBox.shrink();
    return ExpansionTile(
      title: const Text('Technical details'),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        for (final line in log)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              line,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
      ],
    );
  }
}
