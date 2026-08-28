import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/core/theme/theme_controller.dart';
import 'package:simply_internet/features/settings/presentation/controllers/settings_controller.dart';
import 'package:simply_internet/features/settings/presentation/pages/settings_page.dart';
import 'package:simply_internet/l10n/app_localizations.dart';

import 'fakes.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'SimplyInternet',
      packageName: 'com.simplytools.simplyInternet',
      version: '1.0.2',
      buildNumber: '3',
      buildSignature: '',
    );
  });

  Future<FakeDeviceActions> pumpSettings(WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    final deviceActions = FakeDeviceActions();

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeController>.value(
              value: ThemeController(prefs),
            ),
            ChangeNotifierProvider<SettingsController>.value(
              value: SettingsController(
                prefs: prefs,
                deviceActions: deviceActions,
              ),
            ),
          ],
          child: const SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return deviceActions;
  }

  testWidgets('shows the current language and lets the user pick another', (
    tester,
  ) async {
    await pumpSettings(tester);

    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('Language'));
    await tester.pumpAndSettle();
    // 'Deutsch' sits near the top of the picker's list, so it is on screen
    // without needing to scroll the modal first.
    await tester.tap(find.text('Deutsch'));
    await tester.pumpAndSettle();

    expect(find.text('Deutsch'), findsOneWidget);
  });

  testWidgets('theme segmented button switches the theme mode', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.text('Dark'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SettingsPage));
    expect(context.read<ThemeController>().mode, ThemeMode.dark);
  });

  testWidgets('font size segmented button switches the font scale', (
    tester,
  ) async {
    await pumpSettings(tester);

    await tester.tap(find.text('Large'));
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(SettingsPage));
    expect(context.read<SettingsController>().fontScale.label, 'Large');
  });

  testWidgets('shows the app name, version, and update/coffee links', (
    tester,
  ) async {
    final deviceActions = await pumpSettings(tester);

    expect(find.text('SimplyInternet v1.0.2'), findsOneWidget);

    await tester.tap(find.text('Check for update'));
    await tester.pumpAndSettle();
    expect(deviceActions.lastUrl, SettingsController.updateUrl);

    await tester.tap(find.text('Buy me a coffee'));
    await tester.pumpAndSettle();
    expect(deviceActions.lastUrl, SettingsController.coffeeUrl);
  });
}
