import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/core/di/injection.dart';
import 'package:simply_internet/core/theme/theme_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/pages/home_page.dart';
import 'package:simply_internet/features/settings/presentation/controllers/settings_controller.dart';
import 'package:simply_internet/features/urlcheck/presentation/controllers/url_check_controller.dart';
import 'package:simply_internet/l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  configureDependencies(prefs);
  runApp(const SimplyInternetApp());
}

class SimplyInternetApp extends StatelessWidget {
  const SimplyInternetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>.value(
          value: sl<ThemeController>(),
        ),
        ChangeNotifierProvider<SettingsController>.value(
          value: sl<SettingsController>(),
        ),
      ],
      child: Consumer2<ThemeController, SettingsController>(
        builder: (context, theme, settings, _) {
          return MaterialApp(
            title: 'SimplyInternet',
            debugShowCheckedModeBanner: false,
            locale: settings.language.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            themeMode: theme.mode,
            theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
            darkTheme: ThemeData(
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            // Scales every piece of text in the app proportionally; see
            // AppFontScale for why one multiplier here is enough.
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(settings.fontScale.scaleFactor),
              ),
              child: child!,
            ),
            home: MultiProvider(
              providers: [
                ChangeNotifierProvider<DiagnosisController>(
                  create: (_) => sl<DiagnosisController>(),
                ),
                ChangeNotifierProvider<UrlCheckController>(
                  create: (_) => sl<UrlCheckController>(),
                ),
              ],
              child: const HomePage(),
            ),
          );
        },
      ),
    );
  }
}
