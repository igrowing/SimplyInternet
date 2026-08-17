import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';

import 'fakes.dart';

void main() {
  group('DiagnosisController', () {
    late FakeNetworkProbe probe;
    late FakeDeviceActions actions;
    late DiagnosisController controller;

    setUp(() {
      probe = FakeNetworkProbe();
      actions = FakeDeviceActions();
      controller = DiagnosisController(
        runDiagnosis: RunDiagnosis(probe),
        deviceActions: actions,
      );
    });

    test('run() produces a done status with a verdict', () async {
      await controller.run();
      expect(controller.status, DiagnosisStatus.done);
      expect(
        controller.report!.verdict.category,
        VerdictCategory.connectionGood,
      );
    });

    test('reset() returns to idle', () async {
      await controller.run();
      controller.reset();
      expect(controller.status, DiagnosisStatus.idle);
      expect(controller.report, isNull);
    });

    test('performAction routes enableWifi to the device action', () async {
      await controller.performAction(
        const SolutionAction(
          type: SolutionActionType.enableWifi,
          label: 'Turn on Wi-Fi',
        ),
      );
      expect(actions.calls, contains('wifi'));
    });

    test('performAction opens the captive-portal url', () async {
      final done = await controller.performAction(
        const SolutionAction(
          type: SolutionActionType.openCaptivePortal,
          label: 'Open',
          payload: 'http://login.example',
        ),
      );
      expect(done, isTrue);
      expect(actions.lastUrl, 'http://login.example');
    });

    test('performAction retry re-runs the diagnosis', () async {
      final done = await controller.performAction(
        const SolutionAction(
          type: SolutionActionType.retry,
          label: 'Test again',
        ),
      );
      expect(done, isTrue);
      expect(controller.status, DiagnosisStatus.done);
    });

    test('run() keeps the screen lit and releases it afterwards', () async {
      await controller.run();
      expect(actions.calls, containsAllInOrder(['screenOn', 'screenOff']));
    });

    test('the screen is released even when the run fails', () async {
      final failing = DiagnosisController(
        runDiagnosis: RunDiagnosis(FakeNetworkProbe(throwOnConnectivity: true)),
        deviceActions: actions,
      );
      await failing.run();
      expect(failing.status, DiagnosisStatus.error);
      expect(actions.calls, containsAllInOrder(['screenOn', 'screenOff']));
    });

    test('a cross-medium retest waits for the user to come back', () async {
      final done = await controller.performAction(
        const SolutionAction(
          type: SolutionActionType.retestOverMobile,
          label: 'Test over mobile data',
        ),
      );
      expect(done, isTrue);
      // Sent to the Wi-Fi panel, nothing measured yet.
      expect(actions.calls, contains('wifi'));
      expect(controller.retestPending, isTrue);
      expect(controller.status, DiagnosisStatus.idle);

      await controller.runPendingRetest();
      expect(controller.status, DiagnosisStatus.done);
      expect(controller.retestPending, isFalse);

      // A resume without a pending retest must not start a test.
      controller.reset();
      await controller.runPendingRetest();
      expect(controller.status, DiagnosisStatus.idle);
    });
  });
}
