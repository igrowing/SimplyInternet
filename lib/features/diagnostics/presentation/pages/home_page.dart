import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:simply_internet/core/theme/theme_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/result_view.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';
import 'package:simply_internet/features/urlcheck/presentation/widgets/url_check_result_view.dart';

/// The single-screen entry point. It offers two functions — a full connection
/// diagnosis and a single-URL check — and swaps in the relevant progress or
/// result view while either one is running.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // A cross-medium retest sends the user to the Wi-Fi panel; the test runs
    // again by itself the moment they come back. Either flow may have armed
    // one, and only the one that did will act.
    _lifecycle = AppLifecycleListener(onResume: _runPendingRetests);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _runPendingRetests() {
    context.read<DiagnosisController>().runPendingRetest();
    context.read<UrlCheckController>().runPendingRetest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const _AppBarTitle(),
        actions: const [_ThemeToggleButton()],
      ),
      body: SafeArea(
        child: Consumer2<DiagnosisController, UrlCheckController>(
          builder: (context, diag, url, _) {
            final diagActive = diag.status != DiagnosisStatus.idle;
            final urlActive = url.status != UrlCheckStatus.idle;
            return PopScope(
              // While a result/progress screen is up, the system Back button
              // should return to the main screen instead of leaving the app.
              canPop: !diagActive && !urlActive,
              onPopInvokedWithResult: (didPop, _) {
                if (didPop) return;
                if (diagActive) {
                  diag.reset();
                } else if (urlActive) {
                  url.reset();
                }
              },
              child: _buildBody(diag, url, diagActive, urlActive),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(
    DiagnosisController diag,
    UrlCheckController url,
    bool diagActive,
    bool urlActive,
  ) {
    if (diagActive) return _diagnosisBody(diag);
    if (urlActive) return _urlBody(url);
    return _IdleView(diag: diag, url: url);
  }

  Widget _diagnosisBody(DiagnosisController controller) {
    switch (controller.status) {
      case DiagnosisStatus.running:
        return const _RunningView(message: 'Running comprehensive check…');
      case DiagnosisStatus.done:
        return ResultView(report: controller.report!, controller: controller);
      case DiagnosisStatus.error:
        return _ErrorView(
          message: controller.error ?? 'Unknown error',
          onRetry: controller.run,
        );
      case DiagnosisStatus.idle:
        return const SizedBox.shrink();
    }
  }

  Widget _urlBody(UrlCheckController controller) {
    switch (controller.status) {
      case UrlCheckStatus.running:
        return const _RunningView(message: 'Checking the website…');
      case UrlCheckStatus.done:
        return UrlCheckResultView(
          report: controller.report!,
          controller: controller,
        );
      case UrlCheckStatus.error:
        return _ErrorView(
          message: controller.error ?? 'Unknown error',
          onRetry: controller.reset,
          retryLabel: 'Back',
        );
      case UrlCheckStatus.idle:
        return const SizedBox.shrink();
    }
  }
}

/// The idle screen: two function groups. In portrait they are stacked and
/// centred vertically; in landscape each group is centred vertically within
/// its own column and the two columns sit side by side.
class _IdleView extends StatefulWidget {
  const _IdleView({required this.diag, required this.url});

  final DiagnosisController diag;
  final UrlCheckController url;

  @override
  State<_IdleView> createState() => _IdleViewState();
}

class _IdleViewState extends State<_IdleView> {
  final TextEditingController _urlField = TextEditingController();

  @override
  void dispose() {
    _urlField.dispose();
    super.dispose();
  }

  void _submitUrl() {
    final text = _urlField.text.trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    widget.url.check(text);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Branch on available width only. Comparing width>height would flip
        // the layout when the keyboard opens (it shrinks height), rebuilding
        // and unfocusing the URL field so the keyboard closes instantly.
        final wide = constraints.maxWidth > 600;
        final diagnose = _DiagnoseGroup(
          compact: wide,
          onStart: widget.diag.run,
        );
        final checkUrl = _UrlCheckGroup(
          controller: _urlField,
          onSubmit: _submitUrl,
        );

        if (wide) {
          return Row(
            children: [
              Expanded(child: _centered(constraints, diagnose)),
              const VerticalDivider(width: 1),
              Expanded(child: _centered(constraints, checkUrl)),
            ],
          );
        }
        return _centered(
          constraints,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              diagnose,
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 24),
              checkUrl,
            ],
          ),
        );
      },
    );
  }

  Widget _centered(BoxConstraints constraints, Widget child) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// The full-diagnosis function: prompt above, big button below.
class _DiagnoseGroup extends StatelessWidget {
  const _DiagnoseGroup({required this.compact, required this.onStart});

  /// True when the two groups sit side by side, so the decorative icon and
  /// spacing shrink to fit the narrower column.
  final bool compact;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconSize = compact ? 56.0 : 96.0;
    final gap = compact ? 24.0 : 40.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_find, size: iconSize, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          'Internet not working?\nUnstable? Works partially?',
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
              'Find the problem and give a solution',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

/// The single-URL check function: label, URL field, "Check it" button.
class _UrlCheckGroup extends StatelessWidget {
  const _UrlCheckGroup({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.link, size: 56, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          'A particular website or service not working?\n'
          'Paste its link (URL) here:',
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: controller,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.go,
          autocorrect: false,
          onSubmitted: (_) => onSubmit(),
          decoration: const InputDecoration(
            hintText: 'example.com or https://example.com/page',
            prefixIcon: Icon(Icons.public),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.travel_explore),
            label: const Text(
              'Check it',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
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
                  version == null ? '' : 'v$version',
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
  const _RunningView({required this.message});

  final String message;

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
              message,
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
  const _ErrorView({
    required this.message,
    required this.onRetry,
    this.retryLabel = 'Try again',
  });

  final String message;
  final VoidCallback onRetry;
  final String retryLabel;

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
              label: Text(retryLabel),
            ),
          ],
        ),
      ),
    );
  }
}
