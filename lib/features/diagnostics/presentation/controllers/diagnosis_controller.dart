import 'package:flutter/foundation.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/diagnosis_report.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/device_actions.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';

/// Lifecycle of the single-button diagnosis flow.
enum DiagnosisStatus { idle, running, done, error }

/// Presentation controller for the diagnosis screen. Drives the run, exposes
/// live phase updates for the progress UI, and executes the remediation
/// actions the user confirms.
class DiagnosisController extends ChangeNotifier {
  DiagnosisController({
    required RunDiagnosis runDiagnosis,
    required DeviceActions deviceActions,
  }) : _runDiagnosis = runDiagnosis,
       _deviceActions = deviceActions;

  final RunDiagnosis _runDiagnosis;
  final DeviceActions _deviceActions;

  DiagnosisStatus _status = DiagnosisStatus.idle;
  DiagnosisStatus get status => _status;

  DiagnosisPhase _phase = DiagnosisPhase.connection;
  DiagnosisPhase get phase => _phase;

  DiagnosisReport? _report;
  DiagnosisReport? get report => _report;

  String? _error;
  String? get error => _error;

  bool get isRunning => _status == DiagnosisStatus.running;

  /// Run the full diagnosis. Safe to call repeatedly (ignored while running).
  Future<void> run() async {
    if (_status == DiagnosisStatus.running) return;
    _status = DiagnosisStatus.running;
    _report = null;
    _error = null;
    _phase = DiagnosisPhase.connection;
    notifyListeners();

    try {
      final report = await _runDiagnosis.call(
        onPhase: (p) {
          _phase = p;
          notifyListeners();
        },
      );
      _report = report;
      _status = DiagnosisStatus.done;
    } on Exception catch (e) {
      _error = e.toString();
      _status = DiagnosisStatus.error;
    }
    notifyListeners();
  }

  /// Return to the initial screen.
  void reset() {
    _status = DiagnosisStatus.idle;
    _report = null;
    _error = null;
    notifyListeners();
  }

  /// Execute a confirmed [action]. The caller is responsible for having shown
  /// the confirmation prompt first. Returns true when a device action was
  /// carried out (or the browser launched); false when nothing happened.
  Future<bool> performAction(SolutionAction action) async {
    switch (action.type) {
      case SolutionActionType.enableWifi:
        await _deviceActions.openWifiSettings();
        return true;
      case SolutionActionType.disableAirplane:
        await _deviceActions.openAirplaneSettings();
        return true;
      case SolutionActionType.enableMobileData:
        await _deviceActions.openMobileDataSettings();
        return true;
      case SolutionActionType.changeDns:
        await _deviceActions.openPrivateDnsSettings();
        return true;
      case SolutionActionType.openCaptivePortal:
        final url = action.payload;
        if (url == null || url.isEmpty) return false;
        return _deviceActions.openUrl(url);
      case SolutionActionType.retry:
        await run();
        return true;
      case SolutionActionType.advisory:
        return false;
    }
  }
}
