import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:simply_internet/core/theme/theme_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/result_view.dart';

/// The single-screen entry point: a short prompt and one big button. Depending
/// on the controller state it swaps in a progress view or the result view.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const _AppBarTitle(),
        actions: const [_ThemeToggleButton()],
      ),
      body: SafeArea(
        child: Consumer<DiagnosisController>(
          builder: (context, controller, _) {
            switch (controller.status) {
              case DiagnosisStatus.running:
                return const _RunningView();
              case DiagnosisStatus.done:
                return ResultView(
                  report: controller.report!,
                  controller: controller,
                );
              case DiagnosisStatus.error:
                return _ErrorView(
                  message: controller.error ?? 'Unknown error',
                  onRetry: controller.run,
                );
              case DiagnosisStatus.idle:
                return _IdleView(onStart: controller.run);
            }
          },
        ),
      ),
    );
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 600;
        final landscape = constraints.maxWidth > constraints.maxHeight;
        // Shrink the decorative icon in short (landscape) viewports so the
        // prompt and the button both stay on screen.
        final iconSize = landscape ? 64.0 : (wide ? 120.0 : 96.0);
        // Keep the prompt a little above the vertical middle and the button a
        // little below it, while staying centred as a block.
        final gap = landscape ? 28.0 : 48.0;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wifi_find,
                        size: iconSize,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Internet does not work?\nInstable? Works partially?',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                      SizedBox(height: gap),
                      SizedBox(
                        width: double.infinity,
                        height: 72,
                        child: FilledButton.icon(
                          onPressed: onStart,
                          icon: const Icon(Icons.search, size: 28),
                          label: const Text(
                            'Find the problem and give solution',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// App icon + name with the version shown in a small font underneath.
class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 12),
        Image.asset('assets/simplyinternet_fg.png', width: 36, height: 36),
        const SizedBox(width: 10),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('SimplyInternet'),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version = snapshot.data?.version;
                return Text(
                  version == null ? '' : 'v.$version',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

/// Toggles the app between light and dark. Follows the system theme until the
/// first tap (see [ThemeController]).
class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: isDark ? 'Switch to light theme' : 'Switch to dark theme',
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () =>
          controller.toggle(MediaQuery.platformBrightnessOf(context)),
    );
  }
}

class _RunningView extends StatelessWidget {
  const _RunningView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 28),
            Text(
              'Running comprehensive check…',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 72, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              'The check could not finish',
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
