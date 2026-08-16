package com.simplytools.simply_internet

import android.content.Intent
import android.os.Build
import android.provider.Settings
import android.telephony.TelephonyManager
import android.view.WindowManager
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
                "mobileSignalLevel" -> result.success(mobileSignalLevel())
                "keepScreenOn" -> {
                    keepScreenOn(call.arguments as? Boolean ?: false)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    /**
     * Cellular signal quality as Android's own 0 (none) to 4 (excellent)
     * level, or null when the platform cannot report it. Uses
     * TelephonyManager.getSignalStrength(), which needs no permission —
     * unlike getAllCellInfo(), so the app asks for nothing.
     */
    private fun mobileSignalLevel(): Int? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.P) return null
        return try {
            val tm = getSystemService(TELEPHONY_SERVICE) as TelephonyManager
            tm.signalStrength?.level
        } catch (e: SecurityException) {
            null
        }
    }

    /** Holds the display on while a check runs, and releases it after. */
    private fun keepScreenOn(on: Boolean) {
        runOnUiThread {
            if (on) {
                window.addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON)
            } else {
                window.clearFlags(
                    WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
                )
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
