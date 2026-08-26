import 'dart:ui' show Locale;

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

/// A language the app can eventually be displayed in.
///
/// [endonym] is the language's own name for itself, shown regardless of the
/// UI's current language, so a user can recognize their own language in the
/// list even if they can't read anything else on screen. [countryCode]
/// selects the flag shown next to it — a flag stands in for a language here,
/// not a country, so a couple of entries intentionally share one.
///
/// The picker built around this list is a visual stub: choosing a language
/// persists the choice but does not yet change the app's language, since no
/// translations exist yet.
@immutable
class AppLanguage extends Equatable {
  const AppLanguage({
    required this.locale,
    required this.countryCode,
    required this.endonym,
  });

  final Locale locale;
  final String countryCode;
  final String endonym;

  /// Stable identifier used to persist the choice (e.g. 'en', 'zh_Hant').
  String get tag => locale.scriptCode == null
      ? locale.languageCode
      : '${locale.languageCode}_${locale.scriptCode}';

  /// Languages offered in the Settings language picker, in display order.
  static const List<AppLanguage> supported = [
    AppLanguage(locale: Locale('cs'), countryCode: 'CZ', endonym: 'Čeština'),
    AppLanguage(locale: Locale('de'), countryCode: 'DE', endonym: 'Deutsch'),
    AppLanguage(locale: Locale('en'), countryCode: 'GB', endonym: 'English'),
    AppLanguage(locale: Locale('es'), countryCode: 'ES', endonym: 'Español'),
    AppLanguage(locale: Locale('fr'), countryCode: 'FR', endonym: 'Français'),
    AppLanguage(locale: Locale('hi'), countryCode: 'IN', endonym: 'हिन्दी'),
    AppLanguage(locale: Locale('it'), countryCode: 'IT', endonym: 'Italiano'),
    AppLanguage(locale: Locale('ja'), countryCode: 'JP', endonym: '日本語'),
    AppLanguage(locale: Locale('ko'), countryCode: 'KR', endonym: '한국어'),
    AppLanguage(locale: Locale('pl'), countryCode: 'PL', endonym: 'Polski'),
    AppLanguage(locale: Locale('pt'), countryCode: 'PT', endonym: 'Português'),
    AppLanguage(locale: Locale('ru'), countryCode: 'RU', endonym: 'Русский'),
    AppLanguage(locale: Locale('th'), countryCode: 'TH', endonym: 'ไทย'),
    AppLanguage(locale: Locale('uk'), countryCode: 'UA', endonym: 'Українська'),
    AppLanguage(locale: Locale('zh'), countryCode: 'CN', endonym: '中文'),
    AppLanguage(
      locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      countryCode: 'CN',
      endonym: '简体中文',
    ),
    AppLanguage(
      locale: Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
      countryCode: 'TW',
      endonym: '繁體中文',
    ),
  ];

  /// Resolves a persisted [tag] back to a language, defaulting to English.
  static AppLanguage fromTag(String? tag) {
    return supported.firstWhere(
      (l) => l.tag == tag,
      orElse: () => supported.firstWhere((l) => l.tag == 'en'),
    );
  }

  @override
  List<Object?> get props => [locale, countryCode, endonym];
}
