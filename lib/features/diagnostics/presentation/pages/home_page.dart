import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/result_view.dart';
import 'package:simply_internet/features/settings/presentation/pages/settings_page.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';
import 'package:simply_internet/features/urlcheck/presentation/widgets/url_check_result_view.dart';
import 'package:simply_internet/l10n/app_localizations.dart';

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
        actions: const [_SettingsAction()],
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
    final l10n = AppLocalizations.of(context);
    switch (controller.status) {
      case DiagnosisStatus.running:
        return _RunningView(message: l10n.homeRunningDiagnosis);
      case DiagnosisStatus.done:
        return ResultView(report: controller.report!, controller: controller);
      case DiagnosisStatus.error:
        return _ErrorView(
          message: controller.error ?? l10n.homeUnknownError,
          onRetry: () => controller.run(l10n: l10n),
        );
      case DiagnosisStatus.idle:
        return const SizedBox.shrink();
    }
  }

  Widget _urlBody(UrlCheckController controller) {
    final l10n = AppLocalizations.of(context);
    switch (controller.status) {
      case UrlCheckStatus.running:
        return _RunningView(message: l10n.homeRunningUrlCheck);
      case UrlCheckStatus.done:
        return UrlCheckResultView(
          report: controller.report!,
          controller: controller,
        );
      case UrlCheckStatus.error:
        return _ErrorView(
          message: controller.error ?? l10n.homeUnknownError,
          onRetry: controller.reset,
          retryLabel: l10n.commonBack,
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
  final FocusNode _urlFocus = FocusNode();

  @override
  void dispose() {
    _urlField.dispose();
    _urlFocus.dispose();
    super.dispose();
  }

  void _submitUrl() {
    final text = _urlField.text.trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    widget.url.check(text, l10n: AppLocalizations.of(context));
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
          onStart: () => widget.diag.run(l10n: AppLocalizations.of(context)),
        );
        final checkUrl = _UrlCheckGroup(
          controller: _urlField,
          focusNode: _urlFocus,
          history: widget.url.history,
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
    final l10n = AppLocalizations.of(context);
    final iconSize = compact ? 56.0 : 96.0;
    final gap = compact ? 24.0 : 40.0;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_find, size: iconSize, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          l10n.homeTitle,
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
            label: Text(
              l10n.homeDiagnoseButton,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

/// The single-URL check function: label, URL field, "Check it" button.
///
/// The field is an [Autocomplete] over [history]: focusing it (with the field
/// empty) drops down every address checked before, and typing narrows the
/// list. Picking one fills the field and runs the check straight away.
class _UrlCheckGroup extends StatelessWidget {
  const _UrlCheckGroup({
    required this.controller,
    required this.focusNode,
    required this.history,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final List<String> history;
  final VoidCallback onSubmit;

  Iterable<String> _suggestions(TextEditingValue value) {
    final query = value.text.trim().toLowerCase();
    if (query.isEmpty) return history;
    return history.where((url) => url.toLowerCase().contains(query));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.link, size: 56, color: theme.colorScheme.primary),
        const SizedBox(height: 16),
        Text(
          l10n.homeUrlPrompt,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        Autocomplete<String>(
          // Remount when the remembered list changes so a freshly checked
          // address is in the suggestions the next time the field is opened.
          key: ValueKey(Object.hashAll(history)),
          textEditingController: controller,
          focusNode: focusNode,
          optionsBuilder: _suggestions,
          onSelected: (_) => onSubmit(),
          fieldViewBuilder: (context, textController, node, onFieldSubmitted) {
            return TextField(
              controller: textController,
              focusNode: node,
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.go,
              autocorrect: false,
              onSubmitted: (_) {
                onFieldSubmitted();
                onSubmit();
              },
              decoration: InputDecoration(
                hintText: l10n.homeUrlHint,
                prefixIcon: const Icon(Icons.public),
                border: const OutlineInputBorder(),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton.icon(
            onPressed: onSubmit,
            icon: const Icon(Icons.travel_explore),
            label: Text(
              l10n.homeCheckButton,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

/// The gear that opens Settings, shown only on the idle screen. It is hidden
/// while a diagnosis or URL check is on screen: changing the language from a
/// result view rebuilds it against a report whose text was frozen in the old
/// language, so the screen ends up half-translated.
class _SettingsAction extends StatelessWidget {
  const _SettingsAction();

  @override
  Widget build(BuildContext context) {
    return Consumer2<DiagnosisController, UrlCheckController>(
      builder: (context, diag, url, _) {
        final busy =
            diag.status != DiagnosisStatus.idle ||
            url.status != UrlCheckStatus.idle;
        if (busy) return const SizedBox.shrink();
        return IconButton(
          tooltip: AppLocalizations.of(context).homeSettingsTooltip,
          icon: const Icon(Icons.settings_outlined),
          onPressed: () => Navigator.of(
            context,
          ).push(MaterialPageRoute<void>(builder: (_) => const SettingsPage())),
        );
      },
    );
  }
}

/// App icon + name. The version is shown on the Settings screen instead.
class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(width: 12),
        Image.asset('assets/simplyinternet_fg.png', width: 36, height: 36),
        const SizedBox(width: 10),
        const Text('SimplyInternet'),
      ],
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
    this.retryLabel,
  });

  final String message;
  final VoidCallback onRetry;

  /// Defaults to [AppLocalizations.homeTryAgain]; overridden for the
  /// URL-check error state, which reads better as "Back".
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 72, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(
              l10n.homeCheckFailedTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel ?? l10n.homeTryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
