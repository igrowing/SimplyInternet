import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/core/theme/theme_controller.dart';
import 'package:simply_internet/features/diagnostics/domain/usecases/run_diagnosis.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/pages/home_page.dart';
import 'package:simply_internet/features/urlcheck/domain/usecases/check_url.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';

import 'fakes.dart';

UrlCheckController _urlController() => UrlCheckController(
  checkUrl: CheckUrl(FakeUrlInspector()),
  deviceActions: FakeDeviceActions(),
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
      MaterialApp(
        home: MultiProvider(
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

    expect(find.textContaining('Internet does not work?'), findsOneWidget);
    expect(find.text('Find the problem and give solution'), findsOneWidget);
    expect(find.text('v.1.0.2'), findsOneWidget);
  });

  testWidgets('theme toggle switches to dark then light', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final themeController = ThemeController(prefs);
    final controller = DiagnosisController(
      runDiagnosis: RunDiagnosis(FakeNetworkProbe()),
      deviceActions: FakeDeviceActions(),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeController>.value(value: themeController),
          ChangeNotifierProvider<DiagnosisController>.value(value: controller),
          ChangeNotifierProvider<UrlCheckController>.value(
            value: _urlController(),
          ),
        ],
        child: Consumer<ThemeController>(
          builder: (context, theme, _) => MaterialApp(
            themeMode: theme.mode,
            theme: ThemeData(useMaterial3: true),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            home: const HomePage(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(themeController.mode, ThemeMode.system);

    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();
    expect(themeController.mode, ThemeMode.dark);

    await tester.tap(find.byIcon(Icons.light_mode));
    await tester.pumpAndSettle();
    expect(themeController.mode, ThemeMode.light);
  });

  testWidgets('URL check group runs and shows a result', (tester) async {
    final prefs = await SharedPreferences.getInstance();
    final urlController = UrlCheckController(
      checkUrl: CheckUrl(FakeUrlInspector()),
      deviceActions: FakeDeviceActions(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
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
      find.textContaining('Not working particular website'),
      findsOneWidget,
    );
    await tester.enterText(find.byType(TextField), 'example.com');
    await tester.tap(find.text('Check it'));
    await tester.pumpAndSettle();

    expect(find.text('The website works'), findsOneWidget);

    await tester.tap(find.text('Check another'));
    await tester.pumpAndSettle();
    expect(find.text('Check it'), findsOneWidget);
  });
}
