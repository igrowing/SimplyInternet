import 'package:flutter/material.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';

/// Renders a finished [UrlCheckReport]: a headline verdict, one card per
/// finding (colour-coded by severity), and actions to open the site or check
/// another one.
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
        for (final finding in report.findings) _FindingCard(finding: finding),
        const SizedBox(height: 8),
        FilledButton.tonalIcon(
          onPressed: () => _open(context),
          icon: const Icon(Icons.open_in_browser),
          label: const Text('Open in browser'),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: controller.reset,
          icon: const Icon(Icons.arrow_back),
          label: const Text('Check another'),
        ),
        const SizedBox(height: 8),
        _DetailsLog(log: report.log),
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
  const _FindingCard({required this.finding});

  final UrlFinding finding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                  Text(
                    finding.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
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

class _DetailsLog extends StatelessWidget {
  const _DetailsLog({required this.log});

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
