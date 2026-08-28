import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simply_internet/features/settings/domain/entities/app_font_scale.dart';
import 'package:simply_internet/features/settings/domain/entities/app_language.dart';
import 'package:simply_internet/features/settings/presentation/controllers/settings_controller.dart';

import 'fakes.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<SettingsController> buildController() async => SettingsController(
    prefs: await SharedPreferences.getInstance(),
    deviceActions: FakeDeviceActions(),
  );

  test('defaults to English and normal font size', () async {
    final controller = await buildController();
    expect(controller.language.tag, 'en');
    expect(controller.fontScale, AppFontScale.normal);
  });

  test('setLanguage persists the choice and notifies listeners', () async {
    final prefs = await SharedPreferences.getInstance();
    final controller = SettingsController(
      prefs: prefs,
      deviceActions: FakeDeviceActions(),
    );
    var notified = 0;
    controller.addListener(() => notified++);

    final russian = AppLanguage.fromTag('ru');
    await controller.setLanguage(russian);

    expect(controller.language, russian);
    expect(notified, 1);
    expect(prefs.getString('settings_language'), 'ru');
  });

  test('setFontScale persists the choice and notifies listeners', () async {
    final prefs = await SharedPreferences.getInstance();
    final controller = SettingsController(
      prefs: prefs,
      deviceActions: FakeDeviceActions(),
    );
    var notified = 0;
    controller.addListener(() => notified++);

    await controller.setFontScale(AppFontScale.large);

    expect(controller.fontScale, AppFontScale.large);
    expect(notified, 1);
    expect(prefs.getString('settings_font_scale'), 'large');
  });

  test('a later launch restores persisted language and font scale', () async {
    final prefs = await SharedPreferences.getInstance();
    final first = SettingsController(
      prefs: prefs,
      deviceActions: FakeDeviceActions(),
    );
    await first.setLanguage(AppLanguage.fromTag('ja'));
    await first.setFontScale(AppFontScale.small);

    final relaunched = SettingsController(
      prefs: prefs,
      deviceActions: FakeDeviceActions(),
    );

    expect(relaunched.language.tag, 'ja');
    expect(relaunched.fontScale, AppFontScale.small);
  });

  test('openCoffeePage opens the coffee link via DeviceActions', () async {
    final deviceActions = FakeDeviceActions();
    final controller = SettingsController(
      prefs: await SharedPreferences.getInstance(),
      deviceActions: deviceActions,
    );

    await controller.openCoffeePage();

    expect(deviceActions.lastUrl, SettingsController.coffeeUrl);
  });

  test('checkForUpdate opens the Play Store link via DeviceActions', () async {
    final deviceActions = FakeDeviceActions();
    final controller = SettingsController(
      prefs: await SharedPreferences.getInstance(),
      deviceActions: deviceActions,
    );

    await controller.checkForUpdate();

    expect(deviceActions.lastUrl, SettingsController.updateUrl);
  });
}
