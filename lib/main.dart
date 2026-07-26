import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/core/di/injection.dart';
import 'package:simply_internet/core/theme/theme_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/pages/home_page.dart';

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
    return ChangeNotifierProvider<ThemeController>.value(
      value: sl<ThemeController>(),
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'SimplyInternet',
            debugShowCheckedModeBanner: false,
            themeMode: theme.mode,
            theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
            darkTheme: ThemeData(
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.dark,
              useMaterial3: true,
            ),
            home: ChangeNotifierProvider<DiagnosisController>(
              create: (_) => sl<DiagnosisController>(),
              child: const HomePage(),
            ),
          );
        },
      ),
    );
  }
}
