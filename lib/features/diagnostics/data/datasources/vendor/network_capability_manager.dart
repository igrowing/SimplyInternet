import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

/// Reports platform-level limitations that the app cannot work around.
class NetworkCapabilityManager {
  /// True when the OS blocks unprivileged apps from reading the ARP /
  /// neighbour table, so remote MAC addresses cannot be resolved.
  ///
  /// Android 11 (API 30) and up enforce SELinux/UID rules that deny app
  /// access to `/proc/net/arp` and the netlink neighbour table. Non-Android
  /// platforms never expose a local ARP map to the app either.
  static Future<bool> isMacResolutionBlocked() async {
    if (!Platform.isAndroid) return true;
    try {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      // API 30 == Android 11. Any version >= 30 enforces strict SELinux rules.
      return androidInfo.version.sdkInt >= 30;
    } catch (_) {
      // Fail safe: assume blocked if the platform channel errors out.
      return true;
    }
  }
}
