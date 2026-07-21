import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simply_internet/core/di/injection.dart';
import 'package:simply_internet/features/diagnostics/presentation/controllers/diagnosis_controller.dart';
import 'package:simply_internet/features/diagnostics/presentation/pages/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(const SimplyInternetApp());
}

class SimplyInternetApp extends StatelessWidget {
  const SimplyInternetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimplyInternet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: ChangeNotifierProvider<DiagnosisController>(
        create: (_) => sl<DiagnosisController>(),
        child: const HomePage(),
      ),
    );
  }
}
