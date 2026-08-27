import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/device_actions.dart';
import 'package:simply_internet/features/settings/domain/entities/app_font_scale.dart';
import 'package:simply_internet/features/settings/domain/entities/app_language.dart';

/// Holds every persisted Settings-screen preference: language (see
/// [AppLanguage]) and font scale. Theme lives in its own `ThemeController`
/// since it predates this feature and is read by `MaterialApp` directly.
class SettingsController extends ChangeNotifier {
  SettingsController({
    required SharedPreferences prefs,
    required DeviceActions deviceActions,
  }) : _prefs = prefs,
       _deviceActions = deviceActions {
    _language = AppLanguage.fromTag(_prefs.getString(_languageKey));
    _fontScale = AppFontScale.values.firstWhere(
      (s) => s.name == _prefs.getString(_fontScaleKey),
      orElse: () => AppFontScale.normal,
    );
  }

  static const String _languageKey = 'settings_language';
  static const String _fontScaleKey = 'settings_font_scale';

  /// Link to the developer's "Buy me a coffee" page.
  static const String coffeeUrl = 'https://www.buymeacoffee.com/igrowing';

  /// The app's Play Store listing, opened so the store itself can offer the
  /// update if one is available.
  static const String updateUrl =
      'https://play.google.com/store/apps/details?'
      'id=com.simplytools.simplyInternet';

  final SharedPreferences _prefs;
  final DeviceActions _deviceActions;

  late AppLanguage _language;
  late AppFontScale _fontScale;

  AppLanguage get language => _language;
  AppFontScale get fontScale => _fontScale;

  /// Persists the choice and rebuilds the app in the new language.
  Future<void> setLanguage(AppLanguage value) async {
    if (value == _language) return;
    _language = value;
    notifyListeners();
    await _prefs.setString(_languageKey, value.tag);
  }

  Future<void> setFontScale(AppFontScale value) async {
    if (value == _fontScale) return;
    _fontScale = value;
    notifyListeners();
    await _prefs.setString(_fontScaleKey, value.name);
  }

  Future<bool> openCoffeePage() => _deviceActions.openUrl(coffeeUrl);

  Future<bool> checkForUpdate() => _deviceActions.openUrl(updateUrl);
}
