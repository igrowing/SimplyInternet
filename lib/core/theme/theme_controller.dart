import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app-wide light/dark preference. Defaults to [ThemeMode.system]
/// until the user changes it once, after which the explicit choice is stored
/// and reused on the next launch.
class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs) {
    switch (_prefs.getString(_key)) {
      case 'light':
        _mode = ThemeMode.light;
      case 'dark':
        _mode = ThemeMode.dark;
      default:
        _mode = ThemeMode.system;
    }
  }

  static const String _key = 'theme_mode';

  final SharedPreferences _prefs;

  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  /// Flip between light and dark. On the very first change (while still
  /// following the system), pick the opposite of [platformBrightness] so the
  /// tap always produces a visible switch.
  Future<void> toggle(Brightness platformBrightness) async {
    final effective = switch (_mode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => platformBrightness,
    };
    _mode = effective == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
    await _prefs.setString(_key, _mode == ThemeMode.dark ? 'dark' : 'light');
  }
}
