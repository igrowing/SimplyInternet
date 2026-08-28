import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:simply_internet/features/settings/domain/entities/app_language.dart';

void main() {
  group('AppLanguage', () {
    test('tag is just the language code when there is no script', () {
      const english = AppLanguage(
        locale: Locale('en'),
        countryCode: 'GB',
        endonym: 'English',
      );
      expect(english.tag, 'en');
    });

    test('tag includes the script code when one is set', () {
      final hant = AppLanguage.supported.firstWhere((l) => l.endonym == '繁體中文');
      expect(hant.tag, 'zh_Hant');
    });

    test('supported lists every locale exactly once, in order', () {
      final tags = AppLanguage.supported.map((l) => l.tag).toList();
      expect(tags, [
        'cs',
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'it',
        'ja',
        'ko',
        'pl',
        'pt',
        'ru',
        'th',
        'uk',
        'zh_Hans',
        'zh_Hant',
      ]);
      expect(tags.toSet().length, tags.length);
    });

    test('fromTag resolves a known tag back to its language', () {
      expect(AppLanguage.fromTag('ru').endonym, 'Русский');
    });

    test('fromTag falls back to English for an unknown or missing tag', () {
      expect(AppLanguage.fromTag('xx').tag, 'en');
      expect(AppLanguage.fromTag(null).tag, 'en');
    });
  });
}
