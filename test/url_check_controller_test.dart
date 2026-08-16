import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';

import 'fakes.dart';

void main() {
  group('UrlCheckController', () {
    late FakeDeviceActions actions;
    late UrlCheckController controller;

    setUp(() {
      actions = FakeDeviceActions();
      controller = UrlCheckController(
        checkUrl: CheckUrl(FakeUrlInspector()),
        deviceActions: actions,
      );
    });

    test('a mobile re-check waits for the user to come back', () async {
      await controller.check('example.com');
      expect(controller.status, UrlCheckStatus.done);

      final done = await controller.retestOverMobile();
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
      final done = await controller.retestOverMobile();
      expect(done, isFalse);
      expect(actions.calls, isEmpty);
    });
  });
}
