import 'package:flutter/material.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/technical_details.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';

/// Renders a finished [UrlCheckReport]: a headline verdict, one card per
/// finding (colour-coded by severity), then a single "What to do" card holding
/// every instruction and the buttons that carry them out — the same shape the
/// diagnosis result uses, so both features read the same way.
class UrlCheckResultView extends StatelessWidget {
  const UrlCheckResultView({
    required this.report,
    required this.controller,
    super.key,
  });

  final UrlCheckReport report;
  final UrlCheckController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _severityColor(context, report.worst);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Icon(_severityIcon(report.worst), size: 64, color: color),
        const SizedBox(height: 12),
        Text(
          report.headline,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          report.url,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),
        for (final finding in report.findings)
          // The headline is drawn from the reason above, so a card would
          // print the same sentence twice.
          _FindingCard(
            finding: finding,
            showTitle: finding.title != report.headline,
          ),
        const SizedBox(height: 8),
        // One "What to do" block, exactly as the diagnosis result shows it:
        // the instructions and the buttons that carry them out sit together,
        // away from the explanation of what went wrong.
        Card(
          color: theme.colorScheme.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What to do',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                for (final line in report.advice) ...[
                  const SizedBox(height: 6),
                  Text('• $line', style: theme.textTheme.bodyMedium),
                ],
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () => _open(context),
                  icon: const Icon(Icons.open_in_browser),
                  label: const Text('Open in browser'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: () => _retestOverMobile(context),
                  icon: const Icon(Icons.signal_cellular_alt),
                  label: const Text('Test over mobile data'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: controller.reset,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Check another'),
        ),
        const SizedBox(height: 8),
        TechnicalDetails(log: report.log),
      ],
    );
  }

  Future<void> _open(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ok = await controller.openInBrowser();
      if (!ok) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not open the browser.')),
        );
      }
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Could not open: $e')));
    }
  }

  /// Hands the user to the Wi-Fi panel; the same address is checked again by
  /// itself once they return, so the two mediums can be compared.
  Future<void> _retestOverMobile(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final ok = await controller.retestOverMobile();
      if (!ok) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Nothing to test again.')),
        );
        return;
      }
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Turn Wi-Fi off, then come back — the check runs again by itself.',
          ),
        ),
      );
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not open the settings: $e')),
      );
    }
  }

  Color _severityColor(BuildContext context, UrlSeverity severity) {
    final scheme = Theme.of(context).colorScheme;
    switch (severity) {
      case UrlSeverity.ok:
        return Colors.green;
      case UrlSeverity.info:
        return scheme.primary;
      case UrlSeverity.warning:
        return Colors.orange;
      case UrlSeverity.problem:
        return scheme.error;
    }
  }

  IconData _severityIcon(UrlSeverity severity) {
    switch (severity) {
      case UrlSeverity.ok:
        return Icons.check_circle;
      case UrlSeverity.info:
        return Icons.info;
      case UrlSeverity.warning:
        return Icons.warning_amber;
      case UrlSeverity.problem:
        return Icons.error;
    }
  }
}

class _FindingCard extends StatelessWidget {
  const _FindingCard({required this.finding, this.showTitle = true});

  final UrlFinding finding;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // A finding that carries no title — or one already said by the headline —
    // shows its detail alone rather than an empty line where a title would be.
    final title = showTitle ? finding.title : null;
    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_icon(finding.severity), color: _color(context)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) ...[
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(finding.detail, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _color(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    switch (finding.severity) {
      case UrlSeverity.ok:
        return Colors.green;
      case UrlSeverity.info:
        return scheme.primary;
      case UrlSeverity.warning:
        return Colors.orange;
      case UrlSeverity.problem:
        return scheme.error;
    }
  }

  IconData _icon(UrlSeverity severity) {
    switch (severity) {
      case UrlSeverity.ok:
        return Icons.check_circle_outline;
      case UrlSeverity.info:
        return Icons.info_outline;
      case UrlSeverity.warning:
        return Icons.warning_amber_outlined;
      case UrlSeverity.problem:
        return Icons.error_outline;
    }
  }
}
