import 'package:flutter/services.dart';

/// Thin wrapper over the native `actions` method channel plus airplane-mode
/// detection. Opens system settings panels (the only way modern Android lets
/// an app help the user toggle Wi-Fi / data / flight mode / Private DNS).
class PlatformActionsDatasource {
  const PlatformActionsDatasource();

  static const MethodChannel _channel = MethodChannel(
    'com.simplytools.simplyinternet/actions',
  );

  /// Whether the device is currently in flight mode. Returns false when the
  /// platform cannot report it (e.g. iOS).
  Future<bool> isAirplaneModeOn() async {
    try {
      final on = await _channel.invokeMethod<bool>('isAirplaneModeOn');
      return on ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  /// Cellular signal quality on Android's 0 (none) to 4 (excellent) scale, or
  /// null when the platform cannot report it. Needs no permission.
  Future<int?> mobileSignalLevel() async {
    try {
      return await _channel.invokeMethod<int>('mobileSignalLevel');
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  /// Holds the display on while a check runs (and releases it afterwards).
  Future<void> keepScreenOn({required bool on}) async {
    try {
      await _channel.invokeMethod<void>('keepScreenOn', on);
    } on PlatformException catch (e) {
      throw PlatformActionException('keepScreenOn', e.message);
    } on MissingPluginException {
      // Nothing to release on a platform without the channel; the screen
      // simply follows the system timeout.
    }
  }

  Future<void> openWifiSettings() => _open('openWifiSettings');

  Future<void> openAirplaneSettings() => _open('openAirplaneSettings');

  Future<void> openMobileDataSettings() => _open('openMobileDataSettings');

  Future<void> openPrivateDnsSettings() => _open('openPrivateDnsSettings');

  Future<void> _open(String method) async {
    try {
      await _channel.invokeMethod<void>(method);
    } on PlatformException catch (e) {
      throw PlatformActionException(method, e.message);
    } on MissingPluginException {
      throw PlatformActionException(method, 'not supported on this platform');
    }
  }
}

/// Raised when a native settings action cannot be completed. Surfaced to the
/// presentation layer rather than being silently swallowed (see AGENTS.md).
class PlatformActionException implements Exception {
  const PlatformActionException(this.action, this.reason);

  final String action;
  final String? reason;

  @override
  String toString() => 'PlatformActionException($action): $reason';
}
