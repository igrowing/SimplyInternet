import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/core/theme/theme_controller.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/pages/home_page.dart';
import 'package:simply_internet/features/settings/presentation/controllers/settings_controller.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';
import 'package:simply_internet/l10n/app_localizations.dart';

import 'fakes.dart';

UrlCheckController _urlController({List<String>? history}) =>
    UrlCheckController(
      checkUrl: CheckUrl(FakeUrlInspector()),
      deviceActions: FakeDeviceActions(),
      networkProbe: FakeNetworkProbe(),
      urlHistory: FakeUrlHistory(history),
    );

/// Wraps [home] with the localization delegates `AppLocalizations.of`
/// requires, pinned to English so assertions on literal text stay stable.
Widget _wrapHome(Widget home) => MaterialApp(
  locale: const Locale('en'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: home,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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

  testWidgets('home screen shows the prompt and the single big button', (
    tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final controller = DiagnosisController(
      runDiagnosis: RunDiagnosis(FakeNetworkProbe()),
      deviceActions: FakeDeviceActions(),
    );

    await tester.pumpWidget(
      _wrapHome(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeController>.value(
              value: ThemeController(prefs),
            ),
            ChangeNotifierProvider<DiagnosisController>.value(
              value: controller,
            ),
            ChangeNotifierProvider<UrlCheckController>.value(
              value: _urlController(),
            ),
          ],
          child: const HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Internet not working?'), findsOneWidget);
    expect(find.text('Find the problem and give a solution'), findsOneWidget);
    // The version lives on the Settings screen, not the home AppBar.
    expect(find.text('v1.0.2'), findsNothing);
  });

  testWidgets('settings gear opens the Settings screen', (tester) async {
    final prefs = await SharedPreferences.getInstance();

    // Providers must sit above MaterialApp (not just above HomePage), or a
    // pushed route — like SettingsPage — falls outside their scope.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeController>.value(
            value: ThemeController(prefs),
          ),
          ChangeNotifierProvider<SettingsController>.value(
            value: SettingsController(
              prefs: prefs,
              deviceActions: FakeDeviceActions(),
            ),
          ),
          ChangeNotifierProvider<DiagnosisController>.value(
            value: DiagnosisController(
              runDiagnosis: RunDiagnosis(FakeNetworkProbe()),
              deviceActions: FakeDeviceActions(),
            ),
          ),
          ChangeNotifierProvider<UrlCheckController>.value(
            value: _urlController(),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Language'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Font size'), findsOneWidget);
  });

  testWidgets('URL check group runs and shows a result', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final urlController = _urlController();

    await tester.pumpWidget(
      _wrapHome(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeController>.value(
              value: ThemeController(prefs),
            ),
            ChangeNotifierProvider<DiagnosisController>.value(
              value: DiagnosisController(
                runDiagnosis: RunDiagnosis(FakeNetworkProbe()),
                deviceActions: FakeDeviceActions(),
              ),
            ),
            ChangeNotifierProvider<UrlCheckController>.value(
              value: urlController,
            ),
          ],
          child: const HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.textContaining('A particular website or service not working'),
      findsOneWidget,
    );
    // The settings gear is offered on the idle screen …
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'example.com');
    await tester.tap(find.text('Check it'));
    await tester.pumpAndSettle();

    expect(find.text('The website works'), findsOneWidget);
    // … but not on the result screen, where changing the language would
    // rebuild a report whose text was frozen in the old one.
    expect(find.byIcon(Icons.settings_outlined), findsNothing);

    await tester.tap(find.text('Check another'));
    await tester.pumpAndSettle();
    expect(find.text('Check it'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });

  testWidgets('the URL field drops down remembered addresses on tap', (
    tester,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      _wrapHome(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeController>.value(
              value: ThemeController(prefs),
            ),
            ChangeNotifierProvider<DiagnosisController>.value(
              value: DiagnosisController(
                runDiagnosis: RunDiagnosis(FakeNetworkProbe()),
                deviceActions: FakeDeviceActions(),
              ),
            ),
            ChangeNotifierProvider<UrlCheckController>.value(
              value: _urlController(
                history: ['first.example', 'second.example'],
              ),
            ),
          ],
          child: const HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Nothing is offered until the field is touched.
    expect(find.text('first.example'), findsNothing);

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(find.text('first.example'), findsOneWidget);
    expect(find.text('second.example'), findsOneWidget);

    // Typing narrows the list to the matching address.
    await tester.enterText(find.byType(TextField), 'second');
    await tester.pumpAndSettle();
    expect(find.text('first.example'), findsNothing);
    expect(find.text('second.example'), findsOneWidget);

    // Picking one runs the check for that address.
    await tester.tap(find.text('second.example'));
    await tester.pumpAndSettle();
    expect(find.text('The website works'), findsOneWidget);
  });

  testWidgets('a checked address joins the dropdown next time', (tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      _wrapHome(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeController>.value(
              value: ThemeController(prefs),
            ),
            ChangeNotifierProvider<DiagnosisController>.value(
              value: DiagnosisController(
                runDiagnosis: RunDiagnosis(FakeNetworkProbe()),
                deviceActions: FakeDeviceActions(),
              ),
            ),
            ChangeNotifierProvider<UrlCheckController>.value(
              value: _urlController(),
            ),
          ],
          child: const HomePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'example.com');
    await tester.tap(find.text('Check it'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Check another'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();
    expect(find.text('example.com'), findsOneWidget);
  });
}
