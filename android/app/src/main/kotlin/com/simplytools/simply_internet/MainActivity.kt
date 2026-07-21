package com.simplytools.simply_internet

import android.content.Intent
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val ACTIONS_CHANNEL =
            "com.simplytools.simplyinternet/actions"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            ACTIONS_CHANNEL,
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "isAirplaneModeOn" -> result.success(isAirplaneModeOn())
                "openWifiSettings" -> openWifiSettings(result)
                "openAirplaneSettings" ->
                    openSettings(Settings.ACTION_AIRPLANE_MODE_SETTINGS, result)
                "openMobileDataSettings" -> openMobileDataSettings(result)
                "openPrivateDnsSettings" ->
                    openSettings(Settings.ACTION_WIRELESS_SETTINGS, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun isAirplaneModeOn(): Boolean {
        return Settings.Global.getInt(
            contentResolver,
            Settings.Global.AIRPLANE_MODE_ON,
            0,
        ) != 0
    }

    private fun openWifiSettings(result: MethodChannel.Result) {
        val action = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Settings.Panel.ACTION_WIFI
        } else {
            Settings.ACTION_WIFI_SETTINGS
        }
        openSettings(action, result)
    }

    private fun openMobileDataSettings(result: MethodChannel.Result) {
        val action = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            Settings.Panel.ACTION_INTERNET_CONNECTIVITY
        } else {
            Settings.ACTION_WIRELESS_SETTINGS
        }
        openSettings(action, result)
    }

    private fun openSettings(action: String, result: MethodChannel.Result) {
        try {
            val intent = Intent(action).apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.error("SETTINGS_ERROR", e.message, null)
        }
    }
}
