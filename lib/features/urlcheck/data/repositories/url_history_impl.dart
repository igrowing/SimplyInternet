import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/features/urlcheck/domain/repositories/url_history.dart';

/// [UrlHistory] backed by `SharedPreferences`. At most [_maxEntries] addresses
/// are kept so the suggestion list stays short and the store bounded.
class UrlHistoryImpl implements UrlHistory {
  UrlHistoryImpl(this._prefs);

  static const String _key = 'url_check_history';
  static const int _maxEntries = 15;

  final SharedPreferences _prefs;

  @override
  List<String> entries() => _prefs.getStringList(_key) ?? const [];

  @override
  Future<void> remember(String url) async {
    final entry = url.trim();
    if (entry.isEmpty) return;
    final updated = <String>[
      entry,
      for (final e in entries())
        if (e.toLowerCase() != entry.toLowerCase()) e,
    ];
    if (updated.length > _maxEntries) {
      updated.removeRange(_maxEntries, updated.length);
    }
    await _prefs.setStringList(_key, updated);
  }
}
