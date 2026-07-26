import 'package:flutter/foundation.dart';
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
       _deviceActions = deviceActions;

  final CheckUrl _checkUrl;
  final DeviceActions _deviceActions;

  UrlCheckStatus _status = UrlCheckStatus.idle;
  UrlCheckStatus get status => _status;

  UrlCheckReport? _report;
  UrlCheckReport? get report => _report;

  String? _error;
  String? get error => _error;

  bool get isRunning => _status == UrlCheckStatus.running;

  /// Run every URL probe for [rawUrl] in the background and expose the report.
  Future<void> check(String rawUrl) async {
    if (_status == UrlCheckStatus.running) return;
    _status = UrlCheckStatus.running;
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

  /// Return to the idle screen.
  void reset() {
    _status = UrlCheckStatus.idle;
    _report = null;
    _error = null;
    notifyListeners();
  }
}
