/// Device-level remediations the app can trigger on the user's behalf.
///
/// Modern Android forbids apps from silently toggling Wi-Fi, mobile data or
/// flight mode, so these open the relevant system settings panel (returning
/// the user right where they need to act) rather than flipping switches
/// directly. Implemented in the data layer via a platform channel / URL
/// launcher; kept abstract here so the domain stays platform-agnostic.
abstract class DeviceActions {
  /// Open the Wi-Fi settings/panel so the user can enable Wi-Fi.
  Future<void> openWifiSettings();

  /// Open the airplane-mode settings so the user can leave flight mode.
  Future<void> openAirplaneSettings();

  /// Open the mobile-data / cellular settings.
  Future<void> openMobileDataSettings();

  /// Open the Private DNS settings so the user can switch resolver.
  Future<void> openPrivateDnsSettings();

  /// Launch [url] (a captive-portal sign-in page) in the browser.
  Future<bool> openUrl(String url);
}
