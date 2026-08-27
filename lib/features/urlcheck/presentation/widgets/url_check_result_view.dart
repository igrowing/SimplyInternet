import 'package:flutter/material.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/technical_details.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';
import 'package:simply_internet/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context);
    final color = _severityColor(context, report.worst);
    final crossMedium = controller.crossMedium;

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
                  l10n.resultWhatToDo,
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
                  label: Text(l10n.urlOpenInBrowser),
                ),
                // Offered only when there is another medium to compare
                // against, and always naming the one the user is not on.
                if (crossMedium != null) ...[
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: () => _retestOverOtherMedium(context),
                    icon: Icon(
                      crossMedium.target == ConnectivityKind.mobile
                          ? Icons.signal_cellular_alt
                          : Icons.wifi,
                    ),
                    label: Text(_crossMediumLabel(l10n, crossMedium.target)),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: controller.reset,
          icon: const Icon(Icons.arrow_back),
          label: Text(l10n.urlCheckAnother),
        ),
        const SizedBox(height: 8),
        TechnicalDetails(log: report.log),
      ],
    );
  }

  Future<void> _open(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    try {
      final ok = await controller.openInBrowser();
      if (!ok) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.urlCouldNotOpenBrowser)),
        );
      }
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.urlCouldNotOpen('$e'))),
      );
    }
  }

  /// Hands the user to the Wi-Fi panel; the same address is checked again by
  /// itself once they return, so the two mediums can be compared. The hint
  /// says which way to move the switch, which depends on where they are now.
  Future<void> _retestOverOtherMedium(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final target = controller.crossMedium?.target;
    try {
      final ok = await controller.retestOverOtherMedium();
      if (!ok || target == null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.urlNothingToTestAgain)),
        );
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(_crossMediumHint(l10n, target))),
      );
    } on Exception catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.urlCouldNotOpenSettings('$e'))),
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

  /// `CrossMediumOption.label` is fixed English (an engine-level constant
  /// shared with `verdict_catalog.dart`'s `SolutionAction`s), so this screen
  /// resolves its own localized wording from just the target medium instead.
  String _crossMediumLabel(AppLocalizations l10n, ConnectivityKind target) =>
      target == ConnectivityKind.mobile
      ? l10n.crossMediumTestOverMobile
      : l10n.crossMediumTestOverWifi;

  String _crossMediumHint(AppLocalizations l10n, ConnectivityKind target) =>
      target == ConnectivityKind.mobile
      ? l10n.crossMediumHintMobile
      : l10n.crossMediumHintWifi;

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
