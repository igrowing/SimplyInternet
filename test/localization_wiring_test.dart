import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/core/di/injection.dart';
import 'package:simply_internet/features/diagnostics/presentation/pages/home_page.dart';
import 'package:simply_internet/features/settings/presentation/pages/settings_page.dart';
import 'package:simply_internet/main.dart';

/// Proves the picker → `MaterialApp.locale` → rendered text path actually
/// works end to end, not just that the ARB files parse. Unlike
/// settings_page_test.dart (which pumps `SettingsPage` directly and pins
/// English), this goes through the real `SimplyInternetApp` root widget with
/// a persisted language choice, the same way app_font_scale_wiring_test.dart
/// does for the font-scale setting.
void main() {
  setUp(() {
    PackageInfo.setMockInitialValues(
      appName: 'SimplyInternet',
      packageName: 'com.simplytools.simplyInternet',
      version: '1.0.2',
      buildNumber: '3',
      buildSignature: '',
    );
  });

  Future<void> pumpWithLanguage(WidgetTester tester, String tag) async {
    SharedPreferences.setMockInitialValues({'settings_language': tag});
    final prefs = await SharedPreferences.getInstance();
    await sl.reset();
    configureDependencies(prefs);
    await tester.pumpWidget(const SimplyInternetApp());
    await tester.pumpAndSettle();
  }

  testWidgets('a persisted German choice renders the Settings screen in '
      'German', (tester) async {
    await pumpWithLanguage(tester, 'de');

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsPage), findsOneWidget);
    expect(find.text('Einstellungen'), findsOneWidget); // Settings
    expect(find.text('Sprache'), findsOneWidget); // Language
    expect(find.text('Design'), findsOneWidget); // Theme
    // No English chrome leaks through when a non-English locale is active.
    expect(find.text('Settings'), findsNothing);
  });

  // One spot check per newly-added language: enough to catch a missing or
  // malformed ARB entry without re-asserting the whole chrome per language.
  for (final language in {
    'es': 'Comprobar', // "Check it"
    'fr': 'Vérifier',
    'it': 'Verifica',
    'pt': 'Verificar',
    'cs': 'Zkontrolovat',
    'ru': 'Проверить',
    'uk': 'Перевірити',
    'pl': 'Sprawdź',
    'hi': 'जांचें',
    'ja': '確認する',
    'ko': '확인하기',
    'th': 'ตรวจสอบ',
    'zh_Hans': '检查',
    'zh_Hant': '檢查',
  }.entries) {
    testWidgets('a persisted "${language.key}" choice renders the home '
        'screen check button in that language', (tester) async {
      await pumpWithLanguage(tester, language.key);

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text(language.value), findsOneWidget);
    });
  }
}
