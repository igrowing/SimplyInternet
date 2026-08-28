import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/core/theme/theme_controller.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('defaults to system mode', () async {
    final controller = ThemeController(await SharedPreferences.getInstance());
    expect(controller.mode, ThemeMode.system);
  });

  test('setMode persists and notifies listeners', () async {
    final prefs = await SharedPreferences.getInstance();
    final controller = ThemeController(prefs);
    var notified = 0;
    controller.addListener(() => notified++);

    await controller.setMode(ThemeMode.dark);

    expect(controller.mode, ThemeMode.dark);
    expect(notified, 1);
    expect(prefs.getString('theme_mode'), 'dark');
  });

  test('setMode is a no-op when the mode does not change', () async {
    final prefs = await SharedPreferences.getInstance();
    final controller = ThemeController(prefs);
    var notified = 0;
    controller.addListener(() => notified++);

    await controller.setMode(ThemeMode.system);

    expect(notified, 0);
  });

  test('a later launch restores the persisted mode', () async {
    final prefs = await SharedPreferences.getInstance();
    await ThemeController(prefs).setMode(ThemeMode.light);

    final relaunched = ThemeController(prefs);

    expect(relaunched.mode, ThemeMode.light);
  });
}
