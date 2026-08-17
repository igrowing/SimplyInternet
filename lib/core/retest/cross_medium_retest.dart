import 'package:simply_internet/features/diagnostics/domain/repositories/device_actions.dart';

/// The "test this again over the other medium" mechanism, shared by the
/// diagnosis and URL-check flows.
///
/// Android does not let an app switch between Wi-Fi and mobile data, so the
/// switch is the user's to make: they are sent to the Wi-Fi panel and the test
/// re-runs by itself the moment they come back. That leaving-and-returning is
/// the whole reason this is a small object rather than one method — the intent
/// has to survive the trip through another app.
class CrossMediumRetest {
  CrossMediumRetest(this._deviceActions);

  final DeviceActions _deviceActions;

  bool _pending = false;

  /// True between the user asking for the retest and it actually running.
  bool get pending => _pending;

  /// Send the user to the Wi-Fi panel and remember to re-run on return.
  Future<void> arm() async {
    _pending = true;
    await _deviceActions.openWifiSettings();
  }

  /// Runs [rerun] only if a retest was armed. Called when the app is resumed,
  /// where it is normal for nothing to be pending.
  Future<void> runIfPending(Future<void> Function() rerun) async {
    if (!_pending) return;
    _pending = false;
    await rerun();
  }

  /// Forget an armed retest — the user left the result screen instead.
  void cancel() => _pending = false;
}
