import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/result_view.dart';

/// The single-screen entry point: a short prompt and one big button. Depending
/// on the controller state it swaps in a progress view or the result view.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SimplyInternet'), centerTitle: true),
      body: SafeArea(
        child: Consumer<DiagnosisController>(
          builder: (context, controller, _) {
            switch (controller.status) {
              case DiagnosisStatus.running:
                return _RunningView(phase: controller.phase);
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
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_find,
                    size: wide ? 120 : 96,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Internet does not work?\nInstable? Works partially?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 40),
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
        );
      },
    );
  }
}

class _RunningView extends StatelessWidget {
  const _RunningView({required this.phase});

  final DiagnosisPhase phase;

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
              diagnosisPhaseLabel(phase),
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
