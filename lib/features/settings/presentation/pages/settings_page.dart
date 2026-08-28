import 'dart:async';

import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:simply_internet/core/theme/theme_controller.dart';
import 'package:simply_internet/features/settings/domain/entities/app_font_scale.dart';
import 'package:simply_internet/features/settings/domain/entities/app_language.dart';
import 'package:simply_internet/features/settings/presentation/controllers/settings_controller.dart';
import 'package:simply_internet/l10n/app_localizations.dart';

/// Every persisted app preference, reached from the gear icon in the home
/// screen's AppBar. The app has no other settings surface, so language,
/// theme, text size, and the app-identity links all live on this one screen.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).settingsTitle)),
      body: Consumer2<ThemeController, SettingsController>(
        builder: (context, theme, settings, _) {
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _LanguageTile(
                current: settings.language,
                onSelected: settings.setLanguage,
              ),
              const Divider(height: 24),
              _ThemeModeSetting(value: theme.mode, onChanged: theme.setMode),
              const Divider(height: 24),
              _FontScaleSetting(
                value: settings.fontScale,
                onChanged: settings.setFontScale,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
                child: Divider(),
              ),
              const _AboutFooter(),
            ],
          );
        },
      ),
    );
  }
}

/// The Language setting: a tile showing the current choice, opening a
/// bottom sheet with every supported language written in its own script.
/// Selecting one persists the choice and rebuilds the app in that language.
class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.current, required this.onSelected});

  final AppLanguage current;
  final ValueChanged<AppLanguage> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _flag(current.countryCode),
      title: Text(AppLocalizations.of(context).settingsLanguage),
      subtitle: Text(current.endonym),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _pickLanguage(context),
    );
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final picked = await showModalBottomSheet<AppLanguage>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final lang in AppLanguage.supported)
              ListTile(
                leading: _flag(lang.countryCode),
                title: Text(lang.endonym),
                trailing: lang.tag == current.tag
                    ? Icon(
                        Icons.check,
                        color: Theme.of(sheetContext).colorScheme.primary,
                      )
                    : null,
                onTap: () => Navigator.pop(sheetContext, lang),
              ),
          ],
        ),
      ),
    );
    if (picked != null && picked.tag != current.tag) onSelected(picked);
  }

  Widget _flag(String countryCode) => CountryFlag.fromCountryCode(
    countryCode,
    theme: const ImageTheme(width: 32, height: 24, shape: RoundedRectangle(4)),
  );
}

/// The Theme setting: a 3-way system/light/dark picker.
class _ThemeModeSetting extends StatelessWidget {
  const _ThemeModeSetting({required this.value, required this.onChanged});

  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsTheme,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          SegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text(l10n.settingsThemeSystem),
                icon: const Icon(Icons.brightness_auto_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text(l10n.settingsThemeLight),
                icon: const Icon(Icons.light_mode_outlined),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text(l10n.settingsThemeDark),
                icon: const Icon(Icons.dark_mode_outlined),
              ),
            ],
            selected: {value},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
        ],
      ),
    );
  }
}

/// The Font size setting: a 3-way small/normal/large picker that scales
/// every piece of text in the app proportionally (see [AppFontScale]).
class _FontScaleSetting extends StatelessWidget {
  const _FontScaleSetting({required this.value, required this.onChanged});

  final AppFontScale value;
  final ValueChanged<AppFontScale> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.settingsFontSize,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          SegmentedButton<AppFontScale>(
            segments: [
              ButtonSegment(
                value: AppFontScale.small,
                label: Text(l10n.settingsFontSmall),
                icon: const Icon(Icons.text_decrease_outlined),
              ),
              ButtonSegment(
                value: AppFontScale.normal,
                label: Text(l10n.settingsFontNormal),
                icon: const Icon(Icons.text_fields),
              ),
              ButtonSegment(
                value: AppFontScale.large,
                label: Text(l10n.settingsFontLarge),
                icon: const Icon(Icons.text_increase_outlined),
              ),
            ],
            selected: {value},
            onSelectionChanged: (selection) => onChanged(selection.first),
          ),
        ],
      ),
    );
  }
}

/// App name/version, a "Check for update" link, and a "Buy me a coffee"
/// link, shown at the very bottom of the Settings screen.
class _AboutFooter extends StatefulWidget {
  const _AboutFooter();

  @override
  State<_AboutFooter> createState() => _AboutFooterState();
}

class _AboutFooterState extends State<_AboutFooter> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    unawaited(_loadPackageInfo());
  }

  Future<void> _loadPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _packageInfo = info);
  }

  @override
  Widget build(BuildContext context) {
    final info = _packageInfo;
    final label = info == null
        ? 'SimplyInternet'
        : '${info.appName} v${info.version}';
    final settings = context.read<SettingsController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Column(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: settings.checkForUpdate,
            icon: const Icon(Icons.system_update_outlined),
            label: Text(AppLocalizations.of(context).settingsCheckForUpdate),
          ),
          TextButton.icon(
            onPressed: settings.openCoffeePage,
            icon: const Icon(Icons.coffee, color: Colors.amber),
            label: Text(
              AppLocalizations.of(context).settingsBuyMeACoffee,
              style: const TextStyle(color: Colors.amber),
            ),
          ),
        ],
      ),
    );
  }
}
