import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/network_facts.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/solution.dart';
import 'package:simply_internet/features/diagnostics/domain/entities/verdict_catalog.dart';
import 'package:simply_internet/l10n/app_localizations_en.dart';

final en = AppLocalizationsEn();

void main() {
  group('mobileDataNoInternet adapts to the measured signal', () {
    test('a good signal only asks to toggle mobile data', () {
      final out = VerdictCatalog.mobileDataNoInternet(en, signalGood: true);
      expect(out.solution.message, contains('Toggle mobile data off and on'));
      expect(out.solution.message, isNot(contains('better reception')));
      expect(out.solution.message, isNot(contains('better signal')));
    });

    test('a weak signal asks to move AND toggle', () {
      final out = VerdictCatalog.mobileDataNoInternet(en, signalWeak: true);
      expect(out.solution.message, contains('signal is weak'));
      expect(
        out.solution.message,
        contains('better reception and toggle mobile data off and on'),
      );
    });

    test('an unknown signal claims neither good nor weak', () {
      final out = VerdictCatalog.mobileDataNoInternet(en);
      expect(out.solution.message, isNot(contains('signal is weak')));
      expect(out.solution.message, contains('toggle mobile data'));
    });
  });

  group('ConnectivityStatus signal reading', () {
    ConnectivityStatus withLevel(int? level) => ConnectivityStatus(
      kind: ConnectivityKind.mobile,
      airplaneMode: false,
      mobileSignalLevel: level,
    );

    test('the 0-4 Android scale maps to weak, good or unknown', () {
      expect(withLevel(0).mobileSignalWeak, isTrue);
      expect(withLevel(1).mobileSignalWeak, isTrue);
      expect(withLevel(2).mobileSignalWeak, isFalse);
      expect(withLevel(2).mobileSignalGood, isFalse);
      expect(withLevel(4).mobileSignalGood, isTrue);
      // No reading must never be invented as either.
      expect(withLevel(null).mobileSignalWeak, isFalse);
      expect(withLevel(null).mobileSignalGood, isFalse);
    });
  });

  group('retestActions', () {
    test('Wi-Fi offers the same medium and mobile data', () {
      final actions = VerdictCatalog.retestActions(en, ConnectivityKind.wifi);
      expect(actions.map((a) => a.label), [
        'Test again over Wi-Fi',
        'Test over mobile data',
      ]);
      expect(actions.last.type, SolutionActionType.retestOverMobile);
    });

    test('mobile data offers the same medium and Wi-Fi', () {
      final actions = VerdictCatalog.retestActions(en, ConnectivityKind.mobile);
      expect(actions.map((a) => a.label), [
        'Test again over mobile data',
        'Test over Wi-Fi',
      ]);
      expect(actions.last.type, SolutionActionType.retestOverWifi);
    });

    test('any other medium just offers a plain retest', () {
      final actions = VerdictCatalog.retestActions(
        en,
        ConnectivityKind.ethernet,
      );
      expect(actions.map((a) => a.label), ['Test again']);
      expect(actions.single.type, SolutionActionType.retry);
    });
  });
}
