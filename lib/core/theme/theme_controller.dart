import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app-wide light/dark/system preference. Defaults to
/// [ThemeMode.system] until the user picks one explicitly in Settings, after
/// which the choice is stored and reused on the next launch.
class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs) {
    _mode = ThemeMode.values.firstWhere(
      (m) => m.name == _prefs.getString(_key),
      orElse: () => ThemeMode.system,
    );
  }

  static const String _key = 'theme_mode';

  final SharedPreferences _prefs;

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    await _prefs.setString(_key, mode.name);
  }
}
