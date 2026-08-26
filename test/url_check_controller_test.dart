import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/urlcheck/domain/entities/url_check_report.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';

import 'fakes.dart';

/// A use-case that fails with a plain exception rather than a message written
/// for the user, so the controller's catch-all can be driven directly.
class _FailingCheckUrl extends CheckUrl {
  _FailingCheckUrl() : super(FakeUrlInspector());

  @override
  Future<UrlCheckReport> call(String rawUrl, {String? medium}) async =>
      throw Exception('the inspector fell over');
}

/// A use-case that never finishes, so the running state can be observed while
/// it lasts instead of only after the fact.
class _HangingCheckUrl extends CheckUrl {
  _HangingCheckUrl() : super(FakeUrlInspector());

  int calls = 0;

  @override
  Future<UrlCheckReport> call(String rawUrl, {String? medium}) {
    calls++;
    return Completer<UrlCheckReport>().future;
  }
}

void main() {
  group('UrlCheckController', () {
    late FakeDeviceActions actions;
    late UrlCheckController controller;

    late FakeNetworkProbe probe;

    setUp(() {
      actions = FakeDeviceActions();
      probe = FakeNetworkProbe();
      controller = UrlCheckController(
        checkUrl: CheckUrl(FakeUrlInspector()),
        deviceActions: actions,
        networkProbe: probe,
      );
    });

    test('starts with nothing to show', () {
      expect(controller.status, UrlCheckStatus.idle);
      expect(controller.isRunning, isFalse);
      expect(controller.report, isNull);
      expect(controller.error, isNull);
      expect(controller.retestPending, isFalse);
    });

    test('a finished check exposes the report and no error', () async {
      await controller.check('example.com');
      expect(controller.status, UrlCheckStatus.done);
      expect(controller.isRunning, isFalse);
      expect(controller.report!.url, 'https://example.com');
      expect(controller.error, isNull);
    });

    test('tells its listeners when the state moves', () async {
      final seen = <UrlCheckStatus>[];
      controller.addListener(() => seen.add(controller.status));
      await controller.check('example.com');
      // The running state has to be announced, or the screen never shows the
      // spinner it was told to show.
      expect(seen, [UrlCheckStatus.running, UrlCheckStatus.done]);
    });

    group('while a check is under way', () {
      late _HangingCheckUrl hanging;
      late UrlCheckController busy;

      setUp(() {
        hanging = _HangingCheckUrl();
        busy = UrlCheckController(
          checkUrl: hanging,
          deviceActions: FakeDeviceActions(),
          networkProbe: FakeNetworkProbe(),
        );
      });

      test('it reports itself as running', () async {
        unawaited(busy.check('example.com'));
        await pumpEventQueue();
        expect(busy.status, UrlCheckStatus.running);
        expect(busy.isRunning, isTrue);
        expect(busy.report, isNull);
      });

      test('a second request is ignored rather than queued', () async {
        // Two checks racing would leave the screen showing whichever finished
        // last, which is not necessarily the one the user asked for.
        unawaited(busy.check('example.com'));
        await pumpEventQueue();
        await busy.check('other.example');
        expect(hanging.calls, 1);
      });
    });

    group('reports a bad address in words the user can act on', () {
      const cases = {
        '': 'Please paste a website address first.',
        '   ': 'Please paste a website address first.',
        'ftp://example.com': 'Only http and https addresses can be checked.',
        'https://': 'That does not look like a valid web address.',
      };

      for (final entry in cases.entries) {
        test('"${entry.key}"', () async {
          await controller.check(entry.key);
          expect(controller.status, UrlCheckStatus.error);
          expect(controller.error, entry.value);
          expect(controller.report, isNull);
        });
      }
    });

    test('an unexpected failure is surfaced, not swallowed', () async {
      final failing = UrlCheckController(
        checkUrl: _FailingCheckUrl(),
        deviceActions: actions,
        networkProbe: probe,
      );
      await failing.check('example.com');
      expect(failing.status, UrlCheckStatus.error);
      expect(failing.error, contains('the inspector fell over'));
      expect(failing.report, isNull);
    });

    test('a new check clears the last error', () async {
      await controller.check('');
      expect(controller.error, isNotNull);
      await controller.check('example.com');
      expect(controller.error, isNull);
      expect(controller.status, UrlCheckStatus.done);
    });

    test('a failed check clears the last report', () async {
      await controller.check('example.com');
      expect(controller.report, isNotNull);
      await controller.check('');
      expect(controller.report, isNull);
    });

    group('openInBrowser', () {
      test('opens the address that was actually checked', () async {
        // The normalised URL, not the raw text: the browser needs the scheme
        // the check added.
        await controller.check('example.com');
        expect(await controller.openInBrowser(), isTrue);
        expect(actions.lastUrl, 'https://example.com');
      });

      test('does nothing before there is anything to open', () async {
        expect(await controller.openInBrowser(), isFalse);
        expect(actions.calls, isEmpty);
      });

      test('does nothing again once the screen is reset', () async {
        await controller.check('example.com');
        controller.reset();
        expect(await controller.openInBrowser(), isFalse);
      });
    });

    test('reset returns to the idle screen', () async {
      await controller.check('example.com');
      controller.reset();
      expect(controller.status, UrlCheckStatus.idle);
      expect(controller.report, isNull);
      expect(controller.error, isNull);
    });

    test('a cross-medium re-check waits for the user to come back', () async {
      await controller.check('example.com');
      expect(controller.status, UrlCheckStatus.done);

      final done = await controller.retestOverOtherMedium();
      expect(done, isTrue);
      // Sent to the Wi-Fi panel; the check itself has not started again.
      expect(actions.calls, contains('wifi'));
      expect(controller.retestPending, isTrue);

      await controller.runPendingRetest();
      expect(controller.status, UrlCheckStatus.done);
      expect(controller.report!.url, 'https://example.com');
      expect(controller.retestPending, isFalse);
    });

    test('a resume without a pending re-check starts nothing', () async {
      await controller.check('example.com');
      controller.reset();
      await controller.runPendingRetest();
      expect(controller.status, UrlCheckStatus.idle);
      expect(controller.report, isNull);
    });

    test('there is nothing to re-check before the first check', () async {
      final done = await controller.retestOverOtherMedium();
      expect(done, isFalse);
      expect(actions.calls, isEmpty);
    });

    test('a re-check remembers the address even after a reset', () async {
      // Reset clears the screen, not what the user typed: arming a re-check
      // after it must still know which address to check again.
      await controller.check('example.com');
      controller.reset();
      expect(await controller.retestOverOtherMedium(), isTrue);
      await controller.runPendingRetest();
      expect(controller.report!.url, 'https://example.com');
    });

    group('offers the medium the user is not on', () {
      Future<UrlCheckController> checkedOver(ConnectivityKind kind) async {
        probe.connectivityResult = ConnectivityStatus(
          kind: kind,
          airplaneMode: false,
        );
        await controller.check('example.com');
        return controller;
      }

      test('Wi-Fi is offered mobile data', () async {
        final c = await checkedOver(ConnectivityKind.wifi);
        expect(c.crossMedium!.target, ConnectivityKind.mobile);
        expect(c.crossMedium!.label, 'Test over mobile data');
        expect(c.crossMedium!.hint, contains('Turn Wi-Fi off'));
      });

      test('mobile data is offered Wi-Fi', () async {
        // The bug this replaced: someone already on mobile data was told to
        // test over mobile data.
        final c = await checkedOver(ConnectivityKind.mobile);
        expect(c.crossMedium!.target, ConnectivityKind.wifi);
        expect(c.crossMedium!.label, 'Test over Wi-Fi');
        expect(c.crossMedium!.hint, contains('Turn Wi-Fi on'));
      });

      test('a wired link is offered neither', () async {
        final c = await checkedOver(ConnectivityKind.ethernet);
        expect(c.crossMedium, isNull);
        expect(await c.retestOverOtherMedium(), isFalse);
        expect(actions.calls, isEmpty);
      });

      test('the offer follows the user across a switch', () async {
        await checkedOver(ConnectivityKind.wifi);
        expect(controller.crossMedium!.target, ConnectivityKind.mobile);
        // They act on it, turn Wi-Fi off and come back: the re-check runs over
        // mobile data, and the offer must now point the other way instead of
        // inviting the same switch again.
        await controller.retestOverOtherMedium();
        probe.connectivityResult = const ConnectivityStatus(
          kind: ConnectivityKind.mobile,
          airplaneMode: false,
        );
        await controller.runPendingRetest();
        expect(controller.crossMedium!.target, ConnectivityKind.wifi);
      });

      test('and records it in the technical details', () async {
        // The button and the log must agree about the link: the log is what
        // the user pastes into a support ticket after comparing the two.
        final c = await checkedOver(ConnectivityKind.mobile);
        expect(c.report!.log, contains('- Tested over: mobile data'));
        expect(c.crossMedium!.label, 'Test over Wi-Fi');
      });

      test('an unreadable link offers nothing rather than guessing', () async {
        // The check itself still has to finish: the medium is a nicety, and a
        // connectivity read that throws must not take the result down with it.
        probe.throwOnConnectivity = true;
        await controller.check('example.com');
        expect(controller.status, UrlCheckStatus.done);
        expect(controller.report, isNotNull);
        expect(controller.crossMedium, isNull);
        // And the log admits it rather than naming a medium it never read.
        expect(controller.report!.log, contains('- Tested over: not known'));
      });
    });
  });
}
