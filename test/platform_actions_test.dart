import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/data/datasources/platform_actions_datasource.dart';

/// The native `actions` channel. Mocked here so the datasource's three
/// behaviours per call — an answer, a platform error, and no native side at all
/// (iOS, or a unit-test host) — can each be driven directly.
const MethodChannel _channel = MethodChannel(
  'com.simplytools.simplyinternet/actions',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const datasource = PlatformActionsDatasource();
  final calls = <MethodCall>[];

  /// Installs a handler that records what was invoked and answers with
  /// [answer], or throws [error] instead when one is given.
  void mockChannel({Object? answer, PlatformException? error}) {
    TestDefaultBinaryMessengerBinding
        .instance
        .defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, (call) async {
          calls.add(call);
          if (error != null) throw error;
          return answer;
        });
  }

  /// Leaves the channel unhandled, which is exactly what a platform without the
  /// native side looks like: every invocation raises MissingPluginException.
  void noNativeSide() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_channel, null);
  }

  setUp(calls.clear);
  tearDown(noNativeSide);

  group('isAirplaneModeOn', () {
    test('reports what the platform answered', () async {
      mockChannel(answer: true);
      expect(await datasource.isAirplaneModeOn(), isTrue);
      expect(calls.single.method, 'isAirplaneModeOn');

      mockChannel(answer: false);
      expect(await datasource.isAirplaneModeOn(), isFalse);
    });

    test('is false when the platform answers nothing', () async {
      mockChannel();
      expect(await datasource.isAirplaneModeOn(), isFalse);
    });

    test('is false when the platform call fails', () async {
      mockChannel(error: PlatformException(code: 'ERR', message: 'nope'));
      expect(await datasource.isAirplaneModeOn(), isFalse);
    });

    test('is false on a platform without the native side', () async {
      noNativeSide();
      expect(await datasource.isAirplaneModeOn(), isFalse);
    });
  });

  group('mobileSignalLevel', () {
    test('reports the 0-4 level the platform gave', () async {
      mockChannel(answer: 3);
      expect(await datasource.mobileSignalLevel(), 3);
      expect(calls.single.method, 'mobileSignalLevel');
    });

    test('is null — not zero — when it cannot be read', () async {
      // Zero means "no signal", which is a finding. Unknown must stay unknown
      // or the report would blame reception it never measured.
      mockChannel();
      expect(await datasource.mobileSignalLevel(), isNull);

      mockChannel(error: PlatformException(code: 'ERR'));
      expect(await datasource.mobileSignalLevel(), isNull);

      noNativeSide();
      expect(await datasource.mobileSignalLevel(), isNull);
    });
  });

  group('keepScreenOn', () {
    test('passes the requested state to the platform', () async {
      mockChannel();
      await datasource.keepScreenOn(on: true);
      await datasource.keepScreenOn(on: false);
      expect(calls.map((c) => c.method), ['keepScreenOn', 'keepScreenOn']);
      expect(calls.map((c) => c.arguments), [true, false]);
    });

    test('surfaces a platform failure', () async {
      mockChannel(error: PlatformException(code: 'ERR', message: 'denied'));
      await expectLater(
        datasource.keepScreenOn(on: true),
        throwsA(
          isA<PlatformActionException>()
              .having((e) => e.action, 'action', 'keepScreenOn')
              .having((e) => e.reason, 'reason', 'denied'),
        ),
      );
    });

    test('is silent where there is nothing to hold on', () async {
      // Unlike the settings panels, a missing wake-lock is not a failure the
      // user can act on: the screen just follows the system timeout.
      noNativeSide();
      await expectLater(datasource.keepScreenOn(on: true), completes);
    });
  });

  group('settings panels', () {
    final openers = <String, Future<void> Function()>{
      'openWifiSettings': datasource.openWifiSettings,
      'openAirplaneSettings': datasource.openAirplaneSettings,
      'openMobileDataSettings': datasource.openMobileDataSettings,
      'openPrivateDnsSettings': datasource.openPrivateDnsSettings,
    };

    for (final entry in openers.entries) {
      test('${entry.key} invokes its own native method', () async {
        mockChannel();
        await entry.value();
        expect(calls.single.method, entry.key);
      });

      test('${entry.key} reports a platform failure', () async {
        mockChannel(error: PlatformException(code: 'ERR', message: 'no such'));
        await expectLater(
          entry.value(),
          throwsA(
            isA<PlatformActionException>()
                .having((e) => e.action, 'action', entry.key)
                .having((e) => e.reason, 'reason', 'no such'),
          ),
        );
      });

      test('${entry.key} says so when the platform cannot do it', () async {
        // The user pressed a button and nothing opened; swallowing that would
        // leave them waiting for a panel that is never coming.
        noNativeSide();
        await expectLater(
          entry.value(),
          throwsA(
            isA<PlatformActionException>().having(
              (e) => e.reason,
              'reason',
              'not supported on this platform',
            ),
          ),
        );
      });
    }
  });

  test('PlatformActionException names the action and the reason', () {
    const e = PlatformActionException('openWifiSettings', 'denied');
    expect(e.toString(), 'PlatformActionException(openWifiSettings): denied');
    const unknown = PlatformActionException('openWifiSettings', null);
    expect(
      unknown.toString(),
      'PlatformActionException(openWifiSettings): null',
    );
  });
}
