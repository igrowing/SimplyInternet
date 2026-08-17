import 'package:flutter/foundation.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/device_actions.dart';

/// Labels of the cross-medium offer, held in one place because both result
/// screens make it: the diagnosis wraps them in a `SolutionAction` and the URL
/// check draws its own button, and the two must not drift apart.
const String kTestOverMobileLabel = 'Test over mobile data';
const String kTestOverWifiLabel = 'Test over Wi-Fi';

/// The medium worth comparing a result against, and what to tell the user so
/// they can get there. Android does not let an app switch medium, so the
/// instruction is half the offer.
@immutable
class CrossMediumOption {
  const CrossMediumOption({
    required this.target,
    required this.label,
    required this.hint,
  });

  /// The medium the test would run over next — the opposite of the one in use.
  final ConnectivityKind target;

  /// Button text, e.g. 'Test over mobile data'.
  final String label;

  /// What the user has to do while they are in the settings panel.
  final String hint;
}

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

  /// What to offer someone whose link is [current]: the other of the two
  /// mediums a phone can switch between.
  ///
  /// Null when the device is on neither Wi-Fi nor mobile data — a wired or VPN
  /// link has no counterpart to compare against, and offering "test over mobile
  /// data" to someone already on mobile data is the kind of advice that makes
  /// the whole report look like it was not paying attention.
  static CrossMediumOption? optionFor(ConnectivityKind current) {
    switch (current) {
      case ConnectivityKind.wifi:
        return const CrossMediumOption(
          target: ConnectivityKind.mobile,
          label: kTestOverMobileLabel,
          hint:
              'Turn Wi-Fi off, then come back — the check runs again by '
              'itself.',
        );
      case ConnectivityKind.mobile:
        return const CrossMediumOption(
          target: ConnectivityKind.wifi,
          label: kTestOverWifiLabel,
          hint:
              'Turn Wi-Fi on, then come back — the check runs again by '
              'itself.',
        );
      case ConnectivityKind.ethernet:
      case ConnectivityKind.vpn:
      case ConnectivityKind.other:
      case ConnectivityKind.none:
        return null;
    }
  }
}
