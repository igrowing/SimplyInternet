import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/capability.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/diagnosis_report.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/use_case_requirements.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/device_actions.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/result_view.dart';
import 'package:simply_internet/features/diagnostics/presentation/widgets/technical_details.dart';
import 'package:simply_internet/l10n/app_localizations.dart';

import 'fakes.dart';

/// A device whose settings panels refuse to open, so the view's error path can
/// be driven the way a real platform failure drives it.
class _BrokenDeviceActions extends FakeDeviceActions {
  @override
  Future<void> openWifiSettings() async => throw Exception('no such activity');
}

const _requirement = UseCaseRequirement(
  id: UseCaseId.videoCalls720,
  name: 'video calls',
  downMbps: 2,
  upMbps: 2,
);
const _lightRequirement = UseCaseRequirement(
  id: UseCaseId.musicStreaming,
  name: 'music streaming',
  downMbps: 0.5,
  upMbps: 0.05,
);

const _verdict = Verdict(
  category: VerdictCategory.notConnected,
  title: 'You are not connected',
  detail: 'Wi-Fi and mobile data are both off.',
);

/// Mounts [report] in a screen-sized surface. The view is a ListView, so a tall
/// report scrolls; tests that reach for the bottom widgets scroll to them.
Widget _wrap(DiagnosisReport report, {DeviceActions? actions}) {
  final controller = DiagnosisController(
    runDiagnosis: RunDiagnosis(FakeNetworkProbe()),
    deviceActions: actions ?? FakeDeviceActions(),
  );
  return _wrapWith(report, controller);
}

Widget _wrapWith(DiagnosisReport report, DiagnosisController controller) =>
    MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: ResultView(report: report, controller: controller),
      ),
    );

void main() {
  group('ResultView headline', () {
    testWidgets('shows the verdict title, detail and icon', (tester) async {
      await tester.pumpWidget(_wrap(const DiagnosisReport(verdict: _verdict)));

      expect(find.text('You are not connected'), findsOneWidget);
      expect(find.text('Wi-Fi and mobile data are both off.'), findsOneWidget);
      expect(find.byIcon(Icons.signal_wifi_off), findsOneWidget);
    });

    testWidgets('colours the headline by category', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: Verdict(
              category: VerdictCategory.connectionGood,
              title: 'Your connection is good',
              detail: 'Everything fits.',
            ),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.check_circle));
      expect(icon.color, Colors.green.shade800);
      final title = tester.widget<Text>(find.text('Your connection is good'));
      expect(title.style?.color, Colors.green.shade800);
    });

    testWidgets('shows nothing extra when there is no solution or list', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(const DiagnosisReport(verdict: _verdict)));

      expect(find.text('What to do'), findsNothing);
      expect(find.byType(ExpansionTile), findsNothing);
      // The way back is always there, even with nothing else to show.
      expect(find.text('Back'), findsOneWidget);
    });

    testWidgets('Back returns the controller to the start screen', (
      tester,
    ) async {
      final controller = DiagnosisController(
        runDiagnosis: RunDiagnosis(FakeNetworkProbe()),
        deviceActions: FakeDeviceActions(),
      );
      await controller.run();
      expect(controller.status, DiagnosisStatus.done);

      await tester.pumpWidget(
        _wrapWith(const DiagnosisReport(verdict: _verdict), controller),
      );
      await tester.tap(find.text('Back'));
      await tester.pump();

      expect(controller.status, DiagnosisStatus.idle);
    });

    testWidgets('hands the log to the technical details section', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: _verdict,
            log: ['## Device link', '- Connectivity: none'],
          ),
        ),
      );

      final details = tester.widget<TechnicalDetails>(
        find.byType(TechnicalDetails),
      );
      expect(details.log, ['## Device link', '- Connectivity: none']);
    });
  });

  group('ResultView capability list', () {
    const assessment = CapabilityAssessment(
      kind: CapabilityCase.mostlyGood,
      outcomes: [
        UseCaseOutcome(requirement: _lightRequirement, shortfalls: []),
        UseCaseOutcome(
          requirement: _requirement,
          shortfalls: [
            Shortfall(metric: 'upload', text: 'upload 0.4 Mbps', ratio: 5),
            Shortfall(metric: 'jitter', text: 'jitter 45 ms', ratio: 1.5),
          ],
        ),
      ],
      uploadMeasured: true,
      latencyMeasured: true,
    );

    testWidgets('counts the activities that fit in the title', (tester) async {
      await tester.pumpWidget(
        _wrap(const DiagnosisReport(verdict: _verdict, capability: assessment)),
      );

      expect(find.text('What your connection can do (1 of 2)'), findsOneWidget);
      // Collapsed by default: the headline already named what matters.
      expect(find.text('video calls'), findsNothing);
    });

    testWidgets('names each shortfall behind the activity that missed it', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const DiagnosisReport(verdict: _verdict, capability: assessment)),
      );
      await tester.tap(find.text('What your connection can do (1 of 2)'));
      await tester.pumpAndSettle();

      expect(find.text('music streaming'), findsOneWidget);
      expect(find.text('video calls (720p)'), findsOneWidget);
      expect(find.text('upload 0.4 Mbps, jitter 45 ms'), findsOneWidget);
      // A supported activity gets a tick and no explanation to read.
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.cancel), findsOneWidget);
    });

    testWidgets('says so when upload was never measured', (tester) async {
      // Silence here would read as a pass on every upload limit, which is the
      // one thing an unmeasured probe cannot claim.
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: _verdict,
            capability: CapabilityAssessment(
              kind: CapabilityCase.good,
              outcomes: [
                UseCaseOutcome(requirement: _lightRequirement, shortfalls: []),
              ],
              uploadMeasured: false,
              latencyMeasured: true,
            ),
          ),
        ),
      );
      await tester.tap(find.text('What your connection can do (1 of 1)'));
      await tester.pumpAndSettle();

      expect(
        find.text('Upload could not be measured, therefore not assessed.'),
        findsOneWidget,
      );
    });

    testWidgets('leaves the note out when upload was measured', (tester) async {
      await tester.pumpWidget(
        _wrap(const DiagnosisReport(verdict: _verdict, capability: assessment)),
      );
      await tester.tap(find.text('What your connection can do (1 of 2)'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Upload could not be measured'), findsNothing);
    });
  });

  group('ResultView solution card', () {
    testWidgets('shows the message and one button per action', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: _verdict,
            solution: Solution(
              message: 'Turn Wi-Fi back on.',
              actions: [
                SolutionAction(
                  type: SolutionActionType.enableWifi,
                  label: 'Turn on Wi-Fi',
                ),
                SolutionAction(
                  type: SolutionActionType.retry,
                  label: 'Test again',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('What to do'), findsOneWidget);
      expect(find.text('Turn Wi-Fi back on.'), findsOneWidget);
      expect(find.text('Turn on Wi-Fi'), findsOneWidget);
      expect(find.text('Test again'), findsOneWidget);
    });

    testWidgets('skips the message line when there is none', (tester) async {
      // An empty paragraph above the buttons is a blank gap the user has to
      // read past for nothing.
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: _verdict,
            solution: Solution(
              message: '',
              actions: [
                SolutionAction(
                  type: SolutionActionType.retry,
                  label: 'Test again',
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('What to do'), findsOneWidget);
      expect(find.text(''), findsNothing);
      expect(find.text('Test again'), findsOneWidget);
    });

    testWidgets('gives each action type its own icon', (tester) async {
      const actions = [
        SolutionAction(type: SolutionActionType.enableWifi, label: 'wifi'),
        SolutionAction(
          type: SolutionActionType.disableAirplane,
          label: 'airplane',
        ),
        SolutionAction(
          type: SolutionActionType.enableMobileData,
          label: 'data',
        ),
        SolutionAction(
          type: SolutionActionType.openCaptivePortal,
          label: 'portal',
        ),
        SolutionAction(type: SolutionActionType.changeDns, label: 'dns'),
        SolutionAction(type: SolutionActionType.retry, label: 'retry'),
        SolutionAction(
          type: SolutionActionType.retestOverMobile,
          label: 'mobile',
        ),
        SolutionAction(type: SolutionActionType.retestOverWifi, label: 'wifi2'),
        SolutionAction(type: SolutionActionType.advisory, label: 'advice'),
      ];
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: _verdict,
            solution: Solution(message: 'do things', actions: actions),
          ),
        ),
      );

      // Every action type is covered, so a new one cannot ship without a
      // picture on its button.
      expect(SolutionActionType.values, hasLength(actions.length));
      expect(find.byIcon(Icons.wifi), findsNWidgets(2)); // enable + retest
      expect(find.byIcon(Icons.airplanemode_off), findsOneWidget);
      // enableMobileData and retestOverMobile share the cellular icon.
      expect(find.byIcon(Icons.signal_cellular_alt), findsNWidgets(2));
      expect(find.byIcon(Icons.open_in_browser), findsOneWidget);
      expect(find.byIcon(Icons.dns), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });

  group('ResultView actions', () {
    testWidgets('performs an unconfirmed action straight away', (tester) async {
      final actions = FakeDeviceActions();
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: _verdict,
            solution: Solution(
              message: 'Turn Wi-Fi back on.',
              actions: [
                SolutionAction(
                  type: SolutionActionType.enableWifi,
                  label: 'Turn on Wi-Fi',
                ),
              ],
            ),
          ),
          actions: actions,
        ),
      );
      await tester.tap(find.text('Turn on Wi-Fi'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(actions.calls, contains('wifi'));
    });

    testWidgets('asks before acting when the action requires it', (
      tester,
    ) async {
      final actions = FakeDeviceActions();
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: _verdict,
            solution: Solution(
              message: 'Turn Wi-Fi back on.',
              actions: [
                SolutionAction(
                  type: SolutionActionType.enableWifi,
                  label: 'Turn on Wi-Fi',
                  confirmBeforeAct: true,
                  confirmationPrompt: 'Wi-Fi is off. Should I open settings?',
                ),
              ],
            ),
          ),
          actions: actions,
        ),
      );
      await tester.tap(find.text('Turn on Wi-Fi'));
      await tester.pumpAndSettle();

      expect(
        find.text('Wi-Fi is off. Should I open settings?'),
        findsOneWidget,
      );
      expect(actions.calls, isEmpty);

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(actions.calls, contains('wifi'));
    });

    testWidgets('does nothing when the user declines', (tester) async {
      final actions = FakeDeviceActions();
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: _verdict,
            solution: Solution(
              message: 'Turn Wi-Fi back on.',
              actions: [
                SolutionAction(
                  type: SolutionActionType.enableWifi,
                  label: 'Turn on Wi-Fi',
                  confirmBeforeAct: true,
                ),
              ],
            ),
          ),
          actions: actions,
        ),
      );
      await tester.tap(find.text('Turn on Wi-Fi'));
      await tester.pumpAndSettle();

      // With no prompt of its own the dialog falls back to the button label.
      expect(find.text('Turn on Wi-Fi'), findsNWidgets(2));

      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      expect(actions.calls, isEmpty);
    });

    testWidgets('says so when an action had nothing to do', (tester) async {
      // Advisory actions carry no device step; a silent tap would look broken.
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: _verdict,
            solution: Solution(
              message: 'Ask your provider.',
              actions: [
                SolutionAction(
                  type: SolutionActionType.advisory,
                  label: 'Contact your provider',
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('Contact your provider'));
      await tester.pumpAndSettle();

      expect(find.text('Nothing to open for this step.'), findsOneWidget);
    });

    testWidgets('reports a failure instead of swallowing it', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DiagnosisReport(
            verdict: _verdict,
            solution: Solution(
              message: 'Turn Wi-Fi back on.',
              actions: [
                SolutionAction(
                  type: SolutionActionType.enableWifi,
                  label: 'Turn on Wi-Fi',
                ),
              ],
            ),
          ),
          actions: _BrokenDeviceActions(),
        ),
      );
      await tester.tap(find.text('Turn on Wi-Fi'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Could not complete that action:'),
        findsOneWidget,
      );
      expect(find.textContaining('no such activity'), findsOneWidget);
    });
  });
}
