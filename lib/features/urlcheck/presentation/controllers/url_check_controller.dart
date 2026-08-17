import 'package:flutter/foundation.dart';
import 'package:simply_internet/core/retest/cross_medium_retest.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/device_actions.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';

/// Lifecycle of the "check a specific URL" flow.
enum UrlCheckStatus { idle, running, done, error }

/// Presentation controller driving the URL-check screen.
class UrlCheckController extends ChangeNotifier {
  UrlCheckController({
    required CheckUrl checkUrl,
    required DeviceActions deviceActions,
  }) : _checkUrl = checkUrl,
       _deviceActions = deviceActions,
       _retest = CrossMediumRetest(deviceActions);

  final CheckUrl _checkUrl;
  final DeviceActions _deviceActions;
  final CrossMediumRetest _retest;

  UrlCheckStatus _status = UrlCheckStatus.idle;
  UrlCheckStatus get status => _status;

  UrlCheckReport? _report;
  UrlCheckReport? get report => _report;

  String? _error;
  String? get error => _error;

  bool get isRunning => _status == UrlCheckStatus.running;

  /// What the user typed, kept so the same address can be checked again over
  /// the other medium.
  String? _lastUrl;

  bool get retestPending => _retest.pending;

  /// Run every URL probe for [rawUrl] in the background and expose the report.
  Future<void> check(String rawUrl) async {
    if (_status == UrlCheckStatus.running) return;
    _status = UrlCheckStatus.running;
    _lastUrl = rawUrl;
    _report = null;
    _error = null;
    notifyListeners();

    try {
      _report = await _checkUrl.call(rawUrl);
      _status = UrlCheckStatus.done;
    } on InvalidUrlException catch (e) {
      _error = e.message;
      _status = UrlCheckStatus.error;
    } on Exception catch (e) {
      _error = e.toString();
      _status = UrlCheckStatus.error;
    }
    notifyListeners();
  }

  /// Open the checked URL in the system browser.
  Future<bool> openInBrowser() {
    final url = _report?.url;
    if (url == null || url.isEmpty) return Future.value(false);
    return _deviceActions.openUrl(url);
  }

  /// Ask for the same address to be checked again over the other medium.
  /// Choosing this is the user's acknowledgement of the mobile data it uses.
  /// False when there is nothing to check again yet.
  Future<bool> retestOverMobile() async {
    if (_lastUrl == null) return false;
    await _retest.arm();
    return true;
  }

  /// Runs the pending cross-medium re-check, if the user asked for one before
  /// leaving for the Wi-Fi panel. Called when the app is resumed.
  Future<void> runPendingRetest() => _retest.runIfPending(() async {
    final url = _lastUrl;
    if (url != null) await check(url);
  });

  /// Return to the idle screen.
  void reset() {
    _status = UrlCheckStatus.idle;
    _report = null;
    _error = null;
    _retest.cancel();
    notifyListeners();
  }
}
