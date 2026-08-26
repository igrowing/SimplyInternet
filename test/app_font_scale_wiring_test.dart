import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/core/di/injection.dart';
import 'package:simply_internet/features/diagnostics/presentation/pages/home_page.dart';
import 'package:simply_internet/features/settings/domain/entities/app_font_scale.dart';
import 'package:simply_internet/main.dart';

/// Unlike font_scaling_test.dart — which hand-copies the MediaQuery/
/// TextScaler wiring to check the scaling mechanism in isolation — this
/// checks that `SimplyInternetApp` itself actually applies a persisted
/// [AppFontScale] choice, so a regression that drops the wiring from
/// main.dart would be caught here even though the mechanism-level test
/// would still pass.
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

  testWidgets('a persisted "large" font scale reaches the ambient MediaQuery', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'settings_font_scale': AppFontScale.large.name,
    });
    final prefs = await SharedPreferences.getInstance();
    await sl.reset();
    configureDependencies(prefs);

    await tester.pumpWidget(const SimplyInternetApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(HomePage));
    expect(
      MediaQuery.textScalerOf(context),
      TextScaler.linear(AppFontScale.large.scaleFactor),
    );
  });

  testWidgets('a persisted "small" font scale reaches the ambient MediaQuery', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'settings_font_scale': AppFontScale.small.name,
    });
    final prefs = await SharedPreferences.getInstance();
    await sl.reset();
    configureDependencies(prefs);

    await tester.pumpWidget(const SimplyInternetApp());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(HomePage));
    expect(
      MediaQuery.textScalerOf(context),
      TextScaler.linear(AppFontScale.small.scaleFactor),
    );
  });
}
