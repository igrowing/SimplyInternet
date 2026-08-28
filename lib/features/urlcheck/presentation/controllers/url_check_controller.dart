import 'package:flutter/foundation.dart';
import 'package:simply_internet/core/retest/cross_medium_retest.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict_catalog.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/device_actions.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/network_probe.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/domain/repositories/url_history.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';
import 'package:simply_internet/l10n/app_localizations.dart';
import 'package:simply_internet/l10n/app_localizations_en.dart';

/// Lifecycle of the "check a specific URL" flow.
enum UrlCheckStatus { idle, running, done, error }

/// Presentation controller driving the URL-check screen.
class UrlCheckController extends ChangeNotifier {
  UrlCheckController({
    required CheckUrl checkUrl,
    required DeviceActions deviceActions,
    required NetworkProbe networkProbe,
    required UrlHistory urlHistory,
  }) : _checkUrl = checkUrl,
       _deviceActions = deviceActions,
       _networkProbe = networkProbe,
       _urlHistory = urlHistory,
       _retest = CrossMediumRetest(deviceActions);

  final CheckUrl _checkUrl;
  final DeviceActions _deviceActions;
  final NetworkProbe _networkProbe;
  final UrlHistory _urlHistory;
  final CrossMediumRetest _retest;

  UrlCheckStatus _status = UrlCheckStatus.idle;
  UrlCheckStatus get status => _status;

  UrlCheckReport? _report;
  UrlCheckReport? get report => _report;

  String? _error;
  String? get error => _error;

  bool get isRunning => _status == UrlCheckStatus.running;

  /// Addresses the user has checked before, newest first, offered as
  /// suggestions under the URL field.
  List<String> get history => _urlHistory.entries();

  /// What the user typed, kept so the same address can be checked again over
  /// the other medium.
  String? _lastUrl;

  /// The link the last check actually ran over. Read afresh each time, so the
  /// offer to compare mediums follows the user across a switch instead of
  /// inviting someone already on mobile data to try mobile data.
  ConnectivityKind _medium = ConnectivityKind.other;

  /// The medium worth comparing this result against, or null when there is
  /// none — a wired or VPN link, or a connectivity reading that failed.
  CrossMediumOption? get crossMedium => CrossMediumRetest.optionFor(_medium);

  bool get retestPending => _retest.pending;

  /// Localizations of the last [check], reused by the resume-triggered retest
  /// where no `BuildContext` is at hand. Only feeds
  /// `VerdictCatalog.mediumLabel` for the technical log; the visible report
  /// chrome is localized by the view.
  AppLocalizations _l10n = AppLocalizationsEn();

  /// Run every URL probe for [rawUrl] in the background and expose the report.
  Future<void> check(String rawUrl, {AppLocalizations? l10n}) async {
    if (_status == UrlCheckStatus.running) return;
    _l10n = l10n ?? _l10n;
    _status = UrlCheckStatus.running;
    _lastUrl = rawUrl;
    _report = null;
    _error = null;
    notifyListeners();

    // After the spinner is announced, not before: the medium only matters once
    // there is a result to offer a comparison for, and reading it first would
    // hold the screen on the previous view for the length of the platform call.
    _medium = await _currentMedium();

    try {
      _report = await _checkUrl.call(
        rawUrl,
        medium: _mediumLabel(),
        l10n: _l10n,
      );
      _status = UrlCheckStatus.done;
      // Only a check that reached the inspector is worth remembering: a bad
      // address never gets this far, so the suggestion list stays clean.
      await _urlHistory.remember(rawUrl);
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

  /// How the link is named in the report, using the same words the diagnosis
  /// uses so the two reports can be read side by side. Null when there is no
  /// meaningful name for it — the log then says the medium is not known rather
  /// than printing a vague "connection".
  String? _mediumLabel() {
    switch (_medium) {
      case ConnectivityKind.wifi:
      case ConnectivityKind.mobile:
      case ConnectivityKind.ethernet:
      case ConnectivityKind.vpn:
        return VerdictCatalog.mediumLabel(_l10n, _medium);
      case ConnectivityKind.other:
      case ConnectivityKind.none:
        return null;
    }
  }

  /// The link in use, or [ConnectivityKind.other] when it cannot be read.
  ///
  /// A failure here must not fail the URL check, which does not depend on
  /// knowing the medium: the offer to compare the other one is simply not made.
  Future<ConnectivityKind> _currentMedium() async {
    try {
      final status = await _networkProbe.connectivity();
      return status.kind;
    } on Exception {
      return ConnectivityKind.other;
    }
  }

  /// Ask for the same address to be checked again over the other medium —
  /// mobile data when the check ran over Wi-Fi, and Wi-Fi when it ran over
  /// mobile data. Choosing it is the user's acknowledgement of any mobile data
  /// it uses. False when there is nothing to check again, or no other medium
  /// to check it over.
  Future<bool> retestOverOtherMedium() async {
    if (_lastUrl == null || crossMedium == null) return false;
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
