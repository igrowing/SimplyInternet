import 'package:simply_internet/features/diagnostics/data/datasources/platform_actions_datasource.dart';
import 'package:simply_internet/features/diagnostics/domain/repositories/device_actions.dart';
import 'package:url_launcher/url_launcher.dart';

/// [DeviceActions] backed by the native settings channel and url_launcher.
class DeviceActionsImpl implements DeviceActions {
  const DeviceActionsImpl(this._platform);

  final PlatformActionsDatasource _platform;

  @override
  Future<void> openWifiSettings() => _platform.openWifiSettings();

  @override
  Future<void> openAirplaneSettings() => _platform.openAirplaneSettings();

  @override
  Future<void> openMobileDataSettings() => _platform.openMobileDataSettings();

  @override
  Future<void> openPrivateDnsSettings() => _platform.openPrivateDnsSettings();

  @override
  Future<void> keepScreenOn({required bool on}) =>
      _platform.keepScreenOn(on: on);

  @override
  Future<bool> openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return false;
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
