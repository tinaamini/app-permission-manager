//package com.example.permissions_app
//import android.content.pm.PackageInfo
//import android.content.Context
//
//import android.content.Intent
//import android.net.Uri
//import android.provider.Settings
//import android.content.pm.ApplicationInfo
//import android.content.pm.PackageManager
//import android.graphics.Bitmap
//import android.graphics.Canvas
//import android.util.Base64
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//import java.io.ByteArrayOutputStream
//
//class MainActivity : FlutterActivity() {
//
//    private val CHANNEL = "permission_channel"
//    private val CHANNEL2 = "recent_apps"
//    private val INTENT_CHANNEL = "android_intent"
//    private val SPECIAL_PERMISSION_CHANNEL = "app_permission_channel"
//    private val DASHBOARD_CHANNEL = "permissions/safe_dashboard"
//    private val SYSTEM_SETTINGS_CHANNEL = "system_settings"
//
//
//
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(
//            flutterEngine.dartExecutor.binaryMessenger,
//            CHANNEL
//        ).setMethodCallHandler { call, result ->
//            when (call.method) {
//
//                "getInstalledAppsList" -> {
//                    try {
//                        result.success(getInstalledAppsList())
//                    } catch (e: Exception) {
//                        result.error("APP_LIST_ERROR", e.message, null)
//                    }
//                }
//
//                "getInstalledAppsCount" -> {
//                    try {
//                        result.success(getInstalledAppsCount())
//                    } catch (e: Exception) {
//                        result.error("APP_COUNT_ERROR", e.message, null)
//                    }
//                }
//
//
//                "openAppSettings" -> {
//                    val packageName = call.argument<String>("packageName")
//                    if (packageName != null) {
//                        val intent =
//                            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
//                        intent.data = Uri.parse("package:$packageName")
//                        startActivity(intent)
//                        result.success(true)
//                    } else {
//                        result.error("NO_PACKAGE", "Package name missing", null)
//                    }
//                }
//
//
//
//
//                else -> result.notImplemented()
//            }
//        }
//
//        MethodChannel(
//            flutterEngine.dartExecutor.binaryMessenger,
//            CHANNEL2
//        ).setMethodCallHandler { call, result ->
//            when (call.method) {
//
//                "getTodayRecentApps" -> {
//                    try {
//                        result.success(getTodayRecentApps())
//                    } catch (e: Exception) {
//                        result.error("RECENT_APPS_ERROR", e.message, null)
//                    }
//                }
//
//                else -> result.notImplemented()
//            }
//        }
//
//        MethodChannel(
//            flutterEngine.dartExecutor.binaryMessenger,
//            INTENT_CHANNEL
//        ).setMethodCallHandler { call, result ->
//            when (call.method) {
//
//                "openUsageAccess" -> {
//                    try {
//                        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
//                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
//                        startActivity(intent)
//                        result.success(true)
//                    } catch (e: Exception) {
//                        result.error("USAGE_ACCESS_ERROR", e.message, null)
//                    }
//                }
//
//                "checkUsageAccess" -> {
//                    try {
//                        val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
//                        val mode = appOps.checkOpNoThrow(
//                            android.app.AppOpsManager.OPSTR_GET_USAGE_STATS,
//                            android.os.Process.myUid(),
//                            packageName
//                        )
//                        result.success(mode == android.app.AppOpsManager.MODE_ALLOWED)
//                    } catch (e: Exception) {
//                        result.success(false)
//                    }
//                }
//
//
//                else -> result.notImplemented()
//            }
//        }
//
//        MethodChannel(
//            flutterEngine.dartExecutor.binaryMessenger,
//            SPECIAL_PERMISSION_CHANNEL
//        ).setMethodCallHandler { call, result ->
//            when (call.method) {
//
//                // ===== Usage Access =====
//                "openUsageAccessSettings" -> {
//                    try {
//                        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
//                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                        startActivity(intent)
//                        result.success(true)
//                    } catch (e: Exception) {
//                        result.error("USAGE_ACCESS_ERROR", e.message, null)
//                    }
//                }
//
//                "checkUsageAccess" -> {
//                    try {
//                        val appOps = getSystemService(Context.APP_OPS_SERVICE)
//                                as android.app.AppOpsManager
//                        val mode = appOps.checkOpNoThrow(
//                            android.app.AppOpsManager.OPSTR_GET_USAGE_STATS,
//                            android.os.Process.myUid(),
//                            packageName
//                        )
//                        result.success(
//                            mode == android.app.AppOpsManager.MODE_ALLOWED
//                        )
//                    } catch (e: Exception) {
//                        result.success(false)
//                    }
//                }
//
//                "getUsageAccessApps" -> {
//                    try {
//                        val usageStatsManager =
//                            getSystemService(Context.USAGE_STATS_SERVICE)
//                                    as android.app.usage.UsageStatsManager
//
//                        val endTime = System.currentTimeMillis()
//                        val startTime = endTime - (1000L * 60 * 60 * 24)
//
//                        val stats = usageStatsManager.queryUsageStats(
//                            android.app.usage.UsageStatsManager.INTERVAL_DAILY,
//                            startTime,
//                            endTime
//                        )
//
//                        val pm = packageManager
//                        val apps = mutableListOf<Map<String, Any>>()
//
//                        stats
//                            .distinctBy { it.packageName }
//                            .forEach { usage ->
//                                try {
//                                    val appInfo =
//                                        pm.getApplicationInfo(usage.packageName, 0)
//
//                                    // skip system apps
//                                    if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0)
//                                        return@forEach
//
//                                    val appName =
//                                        pm.getApplicationLabel(appInfo).toString()
//
//                                    // ===== ICON =====
//                                    val drawable = pm.getApplicationIcon(appInfo)
//                                    val width =
//                                        if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 96
//                                    val height =
//                                        if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 96
//
//                                    val bitmap = Bitmap.createBitmap(
//                                        width,
//                                        height,
//                                        Bitmap.Config.ARGB_8888
//                                    )
//                                    val canvas = Canvas(bitmap)
//                                    drawable.setBounds(0, 0, canvas.width, canvas.height)
//                                    drawable.draw(canvas)
//
//                                    val stream = ByteArrayOutputStream()
//                                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
//                                    val encodedIcon =
//                                        Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
//
//                                    apps.add(
//                                        mapOf(
//                                            "package" to usage.packageName,
//                                            "name" to appName,
//                                            "icon" to encodedIcon
//                                        )
//                                    )
//                                } catch (_: Exception) {}
//                            }
//
//                        result.success(apps)
//                    } catch (e: Exception) {
//                        result.error("USAGE_LIST_ERROR", e.message, null)
//                    }
//                }
//
//
//                // ===== Overlay =====
//                "openOverlaySettings" -> {
//                    try {
//                        val intent = Intent(
//                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                            Uri.parse("package:$packageName")
//                        )
//                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                        startActivity(intent)
//                        result.success(true)
//                    } catch (e: Exception) {
//                        result.error("OVERLAY_ERROR", e.message, null)
//                    }
//                }
//
//                "checkOverlayPermission" -> {
//                    try {
//                        val hasOverlay = hasAnyNonSystemOverlayPermission()
//                        result.success(hasOverlay)
//                    } catch (e: Exception) {
//                        result.success(false)
//                    }
//                }
//
//
//                // ===== Notification Access =====
//                "openNotificationAccessSettings" -> {
//                    try {
//                        val intent = Intent(
//                            Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS
//                        )
//                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                        startActivity(intent)
//                        result.success(true)
//                    } catch (e: Exception) {
//                        result.error("NOTIFICATION_ACCESS_ERROR", e.message, null)
//                    }
//                }
//
//                "checkNotificationAccess" -> {
//                    try {
//                        val enabled = isAnyNonSystemNotificationListenerEnabled()
//                        result.success(enabled)
//                    } catch (e: Exception) {
//                        result.success(false)
//                    }
//                }
//
//                "getNotificationAccessApps" -> {
//                    try {
//                        val enabledListeners = Settings.Secure.getString(
//                            contentResolver,
//                            "enabled_notification_listeners"
//                        ) ?: ""
//
//                        val pm = packageManager
//                        val apps = mutableListOf<Map<String, Any>>()
//
//                        enabledListeners.split(":").forEach { flat ->
//                            val cn = android.content.ComponentName.unflattenFromString(flat)
//                                ?: return@forEach
//
//                            val pkg = cn.packageName
//
//                            try {
//                                val appInfo = pm.getApplicationInfo(pkg, 0)
//
//                                // skip system apps
//                                if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0)
//                                    return@forEach
//
//                                val appName = pm.getApplicationLabel(appInfo).toString()
//
//                                // ===== ICON =====
//                                val drawable = pm.getApplicationIcon(appInfo)
//                                val width =
//                                    if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 96
//                                val height =
//                                    if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 96
//
//                                val bitmap = Bitmap.createBitmap(
//                                    width,
//                                    height,
//                                    Bitmap.Config.ARGB_8888
//                                )
//                                val canvas = Canvas(bitmap)
//                                drawable.setBounds(0, 0, canvas.width, canvas.height)
//                                drawable.draw(canvas)
//
//                                val stream = ByteArrayOutputStream()
//                                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
//                                val encodedIcon =
//                                    Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
//
//                                apps.add(
//                                    mapOf(
//                                        "package" to pkg,
//                                        "name" to appName,
//                                        "icon" to encodedIcon
//                                    )
//                                )
//                            } catch (_: Exception) {}
//                        }
//
//                        result.success(apps)
//                    } catch (e: Exception) {
//                        result.error("NOTIFICATION_LIST_ERROR", e.message, null)
//                    }
//                }
//
//
//
//                // ===== Battery Optimization =====
//                "openBatteryOptimizationSettings" -> {
//                    try {
//                        val intent = Intent(
//                            Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS
//                        )
//                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                        startActivity(intent)
//                        result.success(true)
//                    } catch (e: Exception) {
//                        result.error("BATTERY_OPT_ERROR", e.message, null)
//                    }
//                }
//
//                "checkBatteryOptimization" -> {
//                    try {
//                        val pm = getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
//                        val ignoring = pm.isIgnoringBatteryOptimizations(packageName)
//                        result.success(ignoring)
//                    } catch (e: Exception) {
//                        result.success(false)
//                    }
//                }
//
//
//                // ===== Do Not Disturb =====
//                "openDoNotDisturbSettings" -> {
//                    try {
//                        val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
//                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                        startActivity(intent)
//                        result.success(true)
//                    } catch (e: Exception) {
//                        result.error("DND_ERROR", e.message, null)
//                    }
//                }
//
//                "checkDoNotDisturb" -> {
//                    try {
//                        val nm = getSystemService(Context.NOTIFICATION_SERVICE)
//                                as android.app.NotificationManager
//
//                        val enabled =
//                            nm.currentInterruptionFilter !=
//                                    android.app.NotificationManager.INTERRUPTION_FILTER_ALL
//
//                        result.success(enabled)
//                    } catch (e: Exception) {
//                        result.success(false)
//                    }
//                }
//
//
//                else -> result.notImplemented()
//            }
//        }
//
//
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DASHBOARD_CHANNEL)
//            .setMethodCallHandler { call, result ->
//                when (call.method) {
//
//                    "isAccessibilityEnabled" -> {
//                        val enabled =
//                            AccessibilityUtils.isAnyAccessibilityServiceEnabled(this)
//                        result.success(enabled)
//                    }
//
//                    "openAccessibilitySettings" -> {
//                        SettingsNavigator.openAccessibilitySettings(this)
//                        result.success(null)
//                    }
//
//                    "getLocationState" -> {
//                        val pkg = call.argument<String>("packageName")
//                        if (pkg.isNullOrBlank()) {
//                            result.error("NO_PACKAGE", "packageName missing", null)
//                        } else {
//                            val data = LocationUtils.getLocationStateForPackage(this, pkg)
//                            result.success(data)
//                        }
//                    }
//
//                    "openAppLocationSettings" -> {
//                        val pkg = call.argument<String>("packageName")
//                        if (pkg.isNullOrBlank()) {
//                            result.error("NO_PACKAGE", "packageName missing", null)
//                        } else {
//                            AppSettingsNavigator.openAppLocationSettings(this, pkg)
//                            result.success(true)
//                        }
//                    }
//
//
//                    else -> result.notImplemented()
//                }
//            }
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SYSTEM_SETTINGS_CHANNEL)
//            .setMethodCallHandler { call, result ->
//                when (call.method) {
//
//                    "openPrivacySettings" -> {
//                        try {
//                            // ✅ very stable: "android.settings.PRIVACY_SETTINGS"
//                            val intent = Intent(Settings.ACTION_PRIVACY_SETTINGS).apply {
//                                flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                            }
//                            startActivity(intent)
//                            result.success(true)
//                        } catch (e: Exception) {
//                            // fallback
//                            try {
//                                val fallback = Intent(Settings.ACTION_SETTINGS).apply {
//                                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                                }
//                                startActivity(fallback)
//                                result.success(true)
//                            } catch (e2: Exception) {
//                                result.error("OPEN_PRIVACY_FAILED", e2.message, null)
//                            }
//                        }
//                    }
//
//                    "openPermissionManager" -> {
//                        try {
//                            // not guaranteed on all OEMs, so keep fallback
//                            val intent = Intent(Settings.ACTION_MANAGE_APPLICATIONS_SETTINGS).apply {
//                                flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                            }
//                            startActivity(intent)
//                            result.success(true)
//                        } catch (e: Exception) {
//                            try {
//                                val fallback = Intent(Settings.ACTION_SETTINGS).apply {
//                                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
//                                }
//                                startActivity(fallback)
//                                result.success(true)
//                            } catch (e2: Exception) {
//                                result.error("OPEN_PERMISSION_MANAGER_FAILED", e2.message, null)
//                            }
//                        }
//                    }
//
//                    else -> result.notImplemented()
//                }
//            }
//
//
//    }
//    private fun getInstalledAppsCount(): Int {
//        val pm = applicationContext.packageManager
//        val packages = pm.getInstalledPackages(0)
//        var count = 0
//
//        for (pkg in packages) {
//            val appInfo = pkg.applicationInfo ?: continue
//            // Skip system apps
//            if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue
//            count++
//        }
//        return count
//    }
//
//    private fun getInstalledAppsList(): List<Map<String, Any>> {
//        val pm: PackageManager = applicationContext.packageManager
//        val packages = pm.getInstalledPackages(PackageManager.GET_PERMISSIONS)
//        val apps = mutableListOf<Map<String, Any>>()
//
//        for (pkg in packages) {
//            val appInfo = pkg.applicationInfo ?: continue
//
//            // Skip system apps
//            if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue
//
//            val appName = pm.getApplicationLabel(appInfo).toString()
//            val packageName = appInfo.packageName
//
//            val grantedPermissions = mutableListOf<String>()
//
//            pkg.requestedPermissions?.forEachIndexed { index, permission ->
//                val flagsArray = pkg.requestedPermissionsFlags
//                if (flagsArray != null && index < flagsArray.size) {
//                    val flags = flagsArray[index]
//                    if ((flags and PackageInfo.REQUESTED_PERMISSION_GRANTED) != 0) {
//                        grantedPermissions.add(permission)
//                    }
//                }
//            }
//
//
//            try {
//                val drawable = pm.getApplicationIcon(appInfo)
//
//                val width =
//                    if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 96
//                val height =
//                    if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 96
//
//                val bitmap = Bitmap.createBitmap(
//                    width,
//                    height,
//                    Bitmap.Config.ARGB_8888
//                )
//
//                val canvas = Canvas(bitmap)
//                drawable.setBounds(0, 0, canvas.width, canvas.height)
//                drawable.draw(canvas)
//
//                val stream = ByteArrayOutputStream()
//                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
//
//                val encodedIcon =
//                    Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
//
//                apps.add(
//                    mapOf(
//                        "name" to appName,
//                        "package" to packageName,
//                        "icon" to encodedIcon,
//                        "permissions" to grantedPermissions
//                    )
//                )
//            } catch (e: Exception) {
//                e.printStackTrace()
//            }
//        }
//
//        return apps
//    }
//
//    private fun getTodayRecentApps(): List<Map<String, Any>> {
//        val usageStatsManager =
//            getSystemService(Context.USAGE_STATS_SERVICE) as android.app.usage.UsageStatsManager
//
//        val calendar = java.util.Calendar.getInstance().apply {
//            set(java.util.Calendar.HOUR_OF_DAY, 0)
//            set(java.util.Calendar.MINUTE, 0)
//            set(java.util.Calendar.SECOND, 0)
//            set(java.util.Calendar.MILLISECOND, 0)
//        }
//
//        val startTime = calendar.timeInMillis
//        val endTime = System.currentTimeMillis()
//
//        val stats = usageStatsManager.queryUsageStats(
//            android.app.usage.UsageStatsManager.INTERVAL_DAILY,
//            startTime,
//            endTime
//        )
//
//        val result = mutableListOf<Map<String, Any>>()
//
//        stats.forEach {
//            if (it.lastTimeUsed >= startTime) {
//                result.add(
//                    mapOf(
//                        "package" to it.packageName,
//                        "lastTimeUsed" to it.lastTimeUsed,
//                        "foregroundTime" to it.totalTimeInForeground
//                    )
//                )
//            }
//        }
//
//        return result
//    }
//
//    private fun isAnyNonSystemNotificationListenerEnabled(): Boolean {
//        val enabledListeners = Settings.Secure.getString(
//            contentResolver,
//            "enabled_notification_listeners"
//        ) ?: return false
//
//        // enabled_notification_listeners format:
//        // com.pkg/.SomeService:com.other/.Service
//        val parts = enabledListeners.split(":")
//
//        val pm = applicationContext.packageManager
//
//        for (flat in parts) {
//            val cn = android.content.ComponentName.unflattenFromString(flat) ?: continue
//            val pkg = cn.packageName
//
//            try {
//                val appInfo = pm.getApplicationInfo(pkg, 0)
//                val isSystem = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
//                if (!isSystem) return true
//            } catch (_: Exception) {
//                // ignore broken entries
//            }
//        }
//        return false
//    }
//    private fun hasAnyNonSystemOverlayPermission(): Boolean {
//        val pm = applicationContext.packageManager
//        val packages = pm.getInstalledApplications(PackageManager.GET_META_DATA)
//
//        for (app in packages) {
//            if ((app.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue
//
//            if (Settings.canDrawOverlays(this)) {
//                return true
//            }
//        }
//        return false
//    }
//
//}
package com.example.permissions_app

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.net.Uri
import android.provider.Settings
import android.util.Base64
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {

    private val CHANNEL = "permission_channel"
    private val CHANNEL2 = "recent_apps"
    private val INTENT_CHANNEL = "android_intent"
    private val SPECIAL_PERMISSION_CHANNEL = "app_permission_channel"
    private val DASHBOARD_CHANNEL = "permissions/safe_dashboard"
    private val SYSTEM_SETTINGS_CHANNEL = "system_settings"

    // ✅ برای اجرای کارهای سنگین خارج از UI thread
    private val ioExecutor = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // ===================== permission_channel =====================
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    // ✅ NEW: سریع (بدون permissions و icon)
                    "getInstalledAppsLite" -> {
                        ioExecutor.execute {
                            try {
                                val data = getInstalledAppsLite()
                                runOnUiThread { result.success(data) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("APP_LITE_ERROR", e.message, null) }
                            }
                        }
                    }

                    // ✅ NEW: permissions فقط برای یک اپ
                    "getAppPermissions" -> {
                        val pkg = call.argument<String>("packageName")
                        if (pkg.isNullOrBlank()) {
                            result.error("NO_PACKAGE", "packageName missing", null)
                        } else {
                            ioExecutor.execute {
                                try {
                                    val perms = getGrantedPermissionsForPackage(pkg)
                                    runOnUiThread { result.success(perms) }
                                } catch (e: Exception) {
                                    runOnUiThread { result.error("PERM_ERROR", e.message, null) }
                                }
                            }
                        }
                    }

                    // ✅ NEW: icon فقط برای یک اپ (lazy) با سایز کوچک
                    "getAppIcon" -> {
                        val pkg = call.argument<String>("packageName")
                        val size = call.argument<Int>("size") ?: 64
                        if (pkg.isNullOrBlank()) {
                            result.error("NO_PACKAGE", "packageName missing", null)
                        } else {
                            ioExecutor.execute {
                                try {
                                    val iconB64 = getAppIconBase64(pkg, size)
                                    runOnUiThread { result.success(iconB64) }
                                } catch (e: Exception) {
                                    runOnUiThread { result.error("ICON_ERROR", e.message, null) }
                                }
                            }
                        }
                    }

                    // (Legacy) سنگین: name + package + icon(base64) + granted permissions
                    "getInstalledAppsList" -> {
                        ioExecutor.execute {
                            try {
                                val data = getInstalledAppsListHeavy()
                                runOnUiThread { result.success(data) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("APP_LIST_ERROR", e.message, null) }
                            }
                        }
                    }

                    "getInstalledAppsCount" -> {
                        ioExecutor.execute {
                            try {
                                val count = getInstalledAppsCount()
                                runOnUiThread { result.success(count) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("APP_COUNT_ERROR", e.message, null) }
                            }
                        }
                    }

                    "openAppSettings" -> {
                        val packageName = call.argument<String>("packageName")
                        if (packageName != null) {
                            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                            intent.data = Uri.parse("package:$packageName")
                            startActivity(intent)
                            result.success(true)
                        } else {
                            result.error("NO_PACKAGE", "Package name missing", null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }

        // ===================== recent_apps =====================
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL2)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "getTodayRecentApps" -> {
                        ioExecutor.execute {
                            try {
                                val data = getTodayRecentApps()
                                runOnUiThread { result.success(data) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("RECENT_APPS_ERROR", e.message, null) }
                            }
                        }
                    }

                    else -> result.notImplemented()
                }
            }

        // ===================== android_intent =====================
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INTENT_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "openUsageAccess" -> {
                        try {
                            val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("USAGE_ACCESS_ERROR", e.message, null)
                        }
                    }

                    "checkUsageAccess" -> {
                        try {
                            val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
                            val mode = appOps.checkOpNoThrow(
                                android.app.AppOpsManager.OPSTR_GET_USAGE_STATS,
                                android.os.Process.myUid(),
                                packageName
                            )
                            result.success(mode == android.app.AppOpsManager.MODE_ALLOWED)
                        } catch (_: Exception) {
                            result.success(false)
                        }
                    }

                    else -> result.notImplemented()
                }
            }

        // ===================== app_permission_channel (Special permissions) =====================
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SPECIAL_PERMISSION_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "openUsageAccessSettings" -> {
                        try {
                            val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("USAGE_ACCESS_ERROR", e.message, null)
                        }
                    }

                    "checkUsageAccess" -> {
                        try {
                            val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
                            val mode = appOps.checkOpNoThrow(
                                android.app.AppOpsManager.OPSTR_GET_USAGE_STATS,
                                android.os.Process.myUid(),
                                packageName
                            )
                            result.success(mode == android.app.AppOpsManager.MODE_ALLOWED)
                        } catch (_: Exception) {
                            result.success(false)
                        }
                    }

                    "getUsageAccessApps" -> {
                        ioExecutor.execute {
                            try {
                                val data = getUsageAccessApps()
                                runOnUiThread { result.success(data) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("USAGE_LIST_ERROR", e.message, null) }
                            }
                        }
                    }

                    "openOverlaySettings" -> {
                        try {
                            val intent = Intent(
                                Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                Uri.parse("package:$packageName")
                            )
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("OVERLAY_ERROR", e.message, null)
                        }
                    }

                    "checkOverlayPermission" -> {
                        try {
                            val hasOverlay = hasAnyNonSystemOverlayPermission()
                            result.success(hasOverlay)
                        } catch (_: Exception) {
                            result.success(false)
                        }
                    }

                    "openNotificationAccessSettings" -> {
                        try {
                            val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("NOTIFICATION_ACCESS_ERROR", e.message, null)
                        }
                    }

                    "checkNotificationAccess" -> {
                        try {
                            val enabled = isAnyNonSystemNotificationListenerEnabled()
                            result.success(enabled)
                        } catch (_: Exception) {
                            result.success(false)
                        }
                    }

                    "getNotificationAccessApps" -> {
                        ioExecutor.execute {
                            try {
                                val data = getNotificationAccessApps()
                                runOnUiThread { result.success(data) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("NOTIFICATION_LIST_ERROR", e.message, null) }
                            }
                        }
                    }

                    "openBatteryOptimizationSettings" -> {
                        try {
                            val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("BATTERY_OPT_ERROR", e.message, null)
                        }
                    }

                    "checkBatteryOptimization" -> {
                        try {
                            val pm = getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
                            val ignoring = pm.isIgnoringBatteryOptimizations(packageName)
                            result.success(ignoring)
                        } catch (_: Exception) {
                            result.success(false)
                        }
                    }

                    "openDoNotDisturbSettings" -> {
                        try {
                            val intent = Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            result.error("DND_ERROR", e.message, null)
                        }
                    }

                    "checkDoNotDisturb" -> {
                        try {
                            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as android.app.NotificationManager
                            val enabled =
                                nm.currentInterruptionFilter != android.app.NotificationManager.INTERRUPTION_FILTER_ALL
                            result.success(enabled)
                        } catch (_: Exception) {
                            result.success(false)
                        }
                    }

                    else -> result.notImplemented()
                }
            }

        // ===================== permissions/safe_dashboard =====================
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DASHBOARD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "isAccessibilityEnabled" -> {
                        val enabled = AccessibilityUtils.isAnyAccessibilityServiceEnabled(this)
                        result.success(enabled)
                    }
                    "openAccessibilitySettings" -> {
                        SettingsNavigator.openAccessibilitySettings(this)
                        result.success(null)
                    }
                    "getLocationState" -> {
                        val pkg = call.argument<String>("packageName")
                        if (pkg.isNullOrBlank()) {
                            result.error("NO_PACKAGE", "packageName missing", null)
                        } else {
                            val data = LocationUtils.getLocationStateForPackage(this, pkg)
                            result.success(data)
                        }
                    }
                    "openAppLocationSettings" -> {
                        val pkg = call.argument<String>("packageName")
                        if (pkg.isNullOrBlank()) {
                            result.error("NO_PACKAGE", "packageName missing", null)
                        } else {
                            AppSettingsNavigator.openAppLocationSettings(this, pkg)
                            result.success(true)
                        }
                    }
                    else -> result.notImplemented()
                }
            }

        // ===================== system_settings =====================
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SYSTEM_SETTINGS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

                    "openPrivacySettings" -> {
                        try {
                            val intent = Intent(Settings.ACTION_PRIVACY_SETTINGS).apply {
                                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            }
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            try {
                                val fallback = Intent(Settings.ACTION_SETTINGS).apply {
                                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                }
                                startActivity(fallback)
                                result.success(true)
                            } catch (e2: Exception) {
                                result.error("OPEN_PRIVACY_FAILED", e2.message, null)
                            }
                        }
                    }

                    "openPermissionManager" -> {
                        try {
                            val intent = Intent(Settings.ACTION_MANAGE_APPLICATIONS_SETTINGS).apply {
                                flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            }
                            startActivity(intent)
                            result.success(true)
                        } catch (e: Exception) {
                            try {
                                val fallback = Intent(Settings.ACTION_SETTINGS).apply {
                                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                }
                                startActivity(fallback)
                                result.success(true)
                            } catch (e2: Exception) {
                                result.error("OPEN_PERMISSION_MANAGER_FAILED", e2.message, null)
                            }
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    // ===================== Core helpers =====================

    private fun getInstalledAppsCount(): Int {
        val pm = applicationContext.packageManager
        val packages = pm.getInstalledPackages(0)
        var count = 0
        for (pkg in packages) {
            val appInfo = pkg.applicationInfo ?: continue
            if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue
            count++
        }
        return count
    }

    // ✅ FAST: no permissions, no icon
    private fun getInstalledAppsLite(): List<Map<String, Any>> {
        val pm: PackageManager = applicationContext.packageManager
        val installed = pm.getInstalledApplications(0)
        val apps = mutableListOf<Map<String, Any>>()

        for (appInfo in installed) {
            if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue
            val appName = pm.getApplicationLabel(appInfo).toString()
            val packageName = appInfo.packageName
            apps.add(mapOf("name" to appName, "package" to packageName))
        }
        return apps
    }

    // ✅ Lazy: permissions for one package
    private fun getGrantedPermissionsForPackage(pkg: String): List<String> {
        val pm = applicationContext.packageManager
        val granted = mutableListOf<String>()
        val info = pm.getPackageInfo(pkg, PackageManager.GET_PERMISSIONS)

        info.requestedPermissions?.forEachIndexed { index, permission ->
            val flagsArray = info.requestedPermissionsFlags
            if (flagsArray != null && index < flagsArray.size) {
                val flags = flagsArray[index]
                if ((flags and PackageInfo.REQUESTED_PERMISSION_GRANTED) != 0) {
                    granted.add(permission)
                }
            }
        }
        return granted
    }

    // ✅ Lazy: icon for one package (small)
    private fun getAppIconBase64(pkg: String, size: Int): String {
        val pm = applicationContext.packageManager
        val appInfo = pm.getApplicationInfo(pkg, 0)
        val drawable = pm.getApplicationIcon(appInfo)

        val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)

        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream) // سبک‌تر از 100
        return Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
    }

    // (Legacy) سنگین — اگر هنوز نیاز داری نگهش دار
    private fun getInstalledAppsListHeavy(): List<Map<String, Any>> {
        val pm: PackageManager = applicationContext.packageManager
        val packages = pm.getInstalledPackages(PackageManager.GET_PERMISSIONS)
        val apps = mutableListOf<Map<String, Any>>()

        for (pkg in packages) {
            val appInfo = pkg.applicationInfo ?: continue
            if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue

            val appName = pm.getApplicationLabel(appInfo).toString()
            val packageName = appInfo.packageName

            val grantedPermissions = mutableListOf<String>()
            pkg.requestedPermissions?.forEachIndexed { index, permission ->
                val flagsArray = pkg.requestedPermissionsFlags
                if (flagsArray != null && index < flagsArray.size) {
                    val flags = flagsArray[index]
                    if ((flags and PackageInfo.REQUESTED_PERMISSION_GRANTED) != 0) {
                        grantedPermissions.add(permission)
                    }
                }
            }

            try {
                // ⚠️ این قسمت سنگینه: icon + PNG + base64
                val drawable = pm.getApplicationIcon(appInfo)
                val width = if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 96
                val height = if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 96

                val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
                val canvas = Canvas(bitmap)
                drawable.setBounds(0, 0, canvas.width, canvas.height)
                drawable.draw(canvas)

                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
                val encodedIcon = Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)

                apps.add(
                    mapOf(
                        "name" to appName,
                        "package" to packageName,
                        "icon" to encodedIcon,
                        "permissions" to grantedPermissions
                    )
                )
            } catch (_: Exception) {
                // ignore icon errors
            }
        }

        return apps
    }

    private fun getTodayRecentApps(): List<Map<String, Any>> {
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as android.app.usage.UsageStatsManager

        val calendar = java.util.Calendar.getInstance().apply {
            set(java.util.Calendar.HOUR_OF_DAY, 0)
            set(java.util.Calendar.MINUTE, 0)
            set(java.util.Calendar.SECOND, 0)
            set(java.util.Calendar.MILLISECOND, 0)
        }

        val startTime = calendar.timeInMillis
        val endTime = System.currentTimeMillis()

        val stats = usageStatsManager.queryUsageStats(
            android.app.usage.UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )

        val result = mutableListOf<Map<String, Any>>()
        stats.forEach {
            if (it.lastTimeUsed >= startTime) {
                result.add(
                    mapOf(
                        "package" to it.packageName,
                        "lastTimeUsed" to it.lastTimeUsed,
                        "foregroundTime" to it.totalTimeInForeground
                    )
                )
            }
        }
        return result
    }

    private fun getUsageAccessApps(): List<Map<String, Any>> {
        val usageStatsManager =
            getSystemService(Context.USAGE_STATS_SERVICE) as android.app.usage.UsageStatsManager

        val endTime = System.currentTimeMillis()
        val startTime = endTime - (1000L * 60 * 60 * 24)

        val stats = usageStatsManager.queryUsageStats(
            android.app.usage.UsageStatsManager.INTERVAL_DAILY,
            startTime,
            endTime
        )

        val pm = packageManager
        val apps = mutableListOf<Map<String, Any>>()

        stats.distinctBy { it.packageName }.forEach { usage ->
            try {
                val appInfo = pm.getApplicationInfo(usage.packageName, 0)
                if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) return@forEach
                val appName = pm.getApplicationLabel(appInfo).toString()

                val iconB64 = getAppIconBase64(usage.packageName, 64)

                apps.add(
                    mapOf(
                        "package" to usage.packageName,
                        "name" to appName,
                        "icon" to iconB64
                    )
                )
            } catch (_: Exception) {}
        }

        return apps
    }

    private fun getNotificationAccessApps(): List<Map<String, Any>> {
        val enabledListeners = Settings.Secure.getString(
            contentResolver,
            "enabled_notification_listeners"
        ) ?: ""

        val pm = packageManager
        val apps = mutableListOf<Map<String, Any>>()

        enabledListeners.split(":").forEach { flat ->
            val cn = android.content.ComponentName.unflattenFromString(flat) ?: return@forEach
            val pkg = cn.packageName

            try {
                val appInfo = pm.getApplicationInfo(pkg, 0)
                if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) return@forEach

                val appName = pm.getApplicationLabel(appInfo).toString()
                val iconB64 = getAppIconBase64(pkg, 64)

                apps.add(mapOf("package" to pkg, "name" to appName, "icon" to iconB64))
            } catch (_: Exception) {}
        }

        return apps
    }

    private fun isAnyNonSystemNotificationListenerEnabled(): Boolean {
        val enabledListeners = Settings.Secure.getString(contentResolver, "enabled_notification_listeners")
            ?: return false

        val pm = applicationContext.packageManager
        for (flat in enabledListeners.split(":")) {
            val cn = android.content.ComponentName.unflattenFromString(flat) ?: continue
            val pkg = cn.packageName
            try {
                val appInfo = pm.getApplicationInfo(pkg, 0)
                val isSystem = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0
                if (!isSystem) return true
            } catch (_: Exception) {}
        }
        return false
    }

    private fun hasAnyNonSystemOverlayPermission(): Boolean {
        val pm = applicationContext.packageManager
        val packages = pm.getInstalledApplications(PackageManager.GET_META_DATA)
        for (app in packages) {
            if ((app.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue
            if (Settings.canDrawOverlays(this)) return true
        }
        return false
    }
}
