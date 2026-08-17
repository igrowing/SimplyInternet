import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The expandable "Technical details" section shared by both features.
///
/// The log lines use a small Markdown subset — `## Heading`, `- item`, a
/// two-space-indented `  - item` for a detail that belongs to the item above
/// it, and an empty line as a separator — which is rendered as headings and
/// nested bullets here and copied verbatim to the clipboard, so what the user
/// pastes into a support ticket looks the same as what they read.
class TechnicalDetails extends StatelessWidget {
  const TechnicalDetails({required this.log, super.key});

  final List<String> log;

  @override
  Widget build(BuildContext context) {
    if (log.isEmpty) return const SizedBox.shrink();
    return ExpansionTile(
      title: const Text('Technical details'),
      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _copy(context),
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Copy'),
          ),
        ),
        for (final line in log) _LogLine(line: line),
      ],
    );
  }

  Future<void> _copy(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    await Clipboard.setData(ClipboardData(text: log.join('\n')));
    messenger.showSnackBar(
      const SnackBar(content: Text('Technical details copied.')),
    );
  }
}

class _LogLine extends StatelessWidget {
  const _LogLine({required this.line});

  final String line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (line.trim().isEmpty) return const SizedBox(height: 10);
    if (line.startsWith('## ')) {
      return Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 2),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            line.substring(3),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
    final nested = line.startsWith('  - ');
    final bullet = nested || line.startsWith('- ');
    return Padding(
      padding: EdgeInsets.only(
        left: nested
            ? 24
            : bullet
            ? 8
            : 0,
        bottom: 2,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          nested
              ? '◦ ${line.substring(4)}'
              : bullet
              ? '• ${line.substring(2)}'
              : line,
          style: const TextStyle(fontSize: 12.5, height: 1.35),
        ),
      ),
    );
  }
}
