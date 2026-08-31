package com.microdev.permissiondetector

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.util.Base64
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat

class MainActivity : FlutterActivity() {

    private val CHANNEL = "permission_channel"
    private val CHANNEL2 = "recent_apps"
    private val INTENT_CHANNEL = "android_intent"
    private val SPECIAL_PERMISSION_CHANNEL = "app_permission_channel"
    private val DASHBOARD_CHANNEL = "permissions/safe_dashboard"
    private val SYSTEM_SETTINGS_CHANNEL = "system_settings"
    private var navigationChannel: MethodChannel? = null

    private val ioExecutor = Executors.newFixedThreadPool(4)
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)

        // A launcher shortcut can be tapped while this Activity is already in
        // the foreground. In that case Flutter gets no lifecycle transition,
        // so polling on `resumed` is not enough; deliver the new route now.
        intent.getStringExtra("shortcut_route")?.let { route ->
            intent.removeExtra("shortcut_route")
            navigationChannel?.invokeMethod("shortcutRoute", route)
        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        SecurityNotifications.initialize(this)
        SecurityWorkScheduler.schedule(this)
        updateAppShortcuts()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU &&
            checkSelfPermission(android.Manifest.permission.POST_NOTIFICATIONS) !=
            PackageManager.PERMISSION_GRANTED
        ) {
            requestPermissions(
                arrayOf(android.Manifest.permission.POST_NOTIFICATIONS),
                7300,
            )
        } else {
            SecurityNotifications.showReadyOnce(this)
            PermissionMonitorService.start(this)
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 7300 &&
            grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED
        ) {
            SecurityNotifications.showReadyOnce(this)
            PermissionMonitorService.start(this)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)


        navigationChannel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "notification_navigation",
        )
        navigationChannel!!
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getPendingPackage" -> {
                        val pkg = intent?.getStringExtra("notification_package_name")
//                        result.success(intent?.getStringExtra("notification_package_name"))
                        intent?.removeExtra("notification_package_name")
                        result.success(pkg)
                    }
                    "getPendingShortcutRoute" -> {

                        val route = intent?.getStringExtra("shortcut_route")
                        intent?.removeExtra("shortcut_route")
                        result.success(route)
                    }
                    "setLanguage" -> {
                        val language = call.argument<String>("language") ?: "fa"
                        val prefs = getSharedPreferences("app_prefs", Context.MODE_PRIVATE)
                        prefs.edit().putString("app_language", language).apply()
                        updateAppShortcuts()

                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }

        // ===================== permission_channel =====================
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {

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

                    // یک درخواست واحد که لیست اپ‌ها + وضعیت لوکیشن هرکدوم رو با هم برمی‌گردونه.
                    // به‌جای این‌که Dart برای هر اپ جداگانه getLocationState صدا بزنه (N درخواست
                    // جدا روی method channel)، همینجا توی همون حلقه‌ای که داریم اپ‌ها رو
                    // می‌خونیم، وضعیت لوکیشن هر اپ رو هم محاسبه می‌کنیم (چون خودش سبکه، فقط
                    // چندتا pm.checkPermission است) و یکجا برمی‌گردونیم.
                    "getInstalledAppsListWithLocation" -> {
                        ioExecutor.execute {
                            try {
                                val data = getInstalledAppsListWithLocation()
                                runOnUiThread { result.success(data) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("APP_LIST_LOCATION_ERROR", e.message, null) }
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
                            val appOps =
                                getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
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

        // ===================== app_permission_channel =====================
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SPECIAL_PERMISSION_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "checkUsageAccess" -> {
                        try {
                            val appOps =
                                getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
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

                    "getOverlayApps" -> {
                        ioExecutor.execute {
                            try {
                                val data = getOverlayApps()
                                runOnUiThread { result.success(data) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("OVERLAY_LIST_ERROR", e.message, null) }
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

                    "openAppOverlaySettings" -> {
                        val pkg = call.argument<String>("packageName")
                        if (pkg.isNullOrBlank()) {
                            result.error("NO_PACKAGE", "packageName missing", null)
                        } else {
                            try {
                                val intent = Intent(
                                    Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                                    Uri.parse("package:$pkg")
                                )
                                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                startActivity(intent)
                                result.success(true)
                            } catch (e: Exception) {
                                result.error("OVERLAY_ERROR", e.message, null)
                            }
                        }
                    }

                    // "Modify System Settings" (WRITE_SETTINGS) هم مثل overlay یک
                    // special permission است و توی App Info عادی نیست.
                    "openAppWriteSettingsSettings" -> {
                        val pkg = call.argument<String>("packageName")
                        if (pkg.isNullOrBlank()) {
                            result.error("NO_PACKAGE", "packageName missing", null)
                        } else {
                            try {
                                val intent = Intent(
                                    Settings.ACTION_MANAGE_WRITE_SETTINGS,
                                    Uri.parse("package:$pkg")
                                )
                                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                startActivity(intent)
                                result.success(true)
                            } catch (e: Exception) {
                                result.error("WRITE_SETTINGS_ERROR", e.message, null)
                            }
                        }
                    }

                    // "All Files Access" (MANAGE_EXTERNAL_STORAGE) هم مثل overlay
                    // یک special permission است و توی صفحه‌ی عمومی App Info لیست
                    // نمی‌شه؛ نیاز به همین intent اختصاصی داره (فقط Android 11+).
                    "openAppAllFilesAccessSettings" -> {
                        val pkg = call.argument<String>("packageName")
                        if (pkg.isNullOrBlank()) {
                            result.error("NO_PACKAGE", "packageName missing", null)
                        } else {
                            try {
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                                    val intent = Intent(
                                        Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,
                                        Uri.parse("package:$pkg")
                                    )
                                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                    startActivity(intent)
                                } else {
                                    // زیر Android 11 این permission اصلاً وجود نداره؛
                                    // برای احتیاط به صفحه‌ی عمومی App Info برمی‌گردیم
                                    val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                                    intent.data = Uri.parse("package:$pkg")
                                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                    startActivity(intent)
                                }
                                result.success(true)
                            } catch (e: Exception) {
                                result.error("ALL_FILES_ACCESS_ERROR", e.message, null)
                            }
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
                                runOnUiThread {
                                    result.error("NOTIFICATION_LIST_ERROR", e.message, null)
                                }
                            }
                        }
                    }

                    "openAppNotificationSettings" -> {
                        val pkg = call.argument<String>("packageName")
                        if (pkg.isNullOrBlank()) {
                            result.error("NO_PACKAGE", "packageName missing", null)
                        } else {
                            try {
                                val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_DETAIL_SETTINGS).apply {
                                    putExtra(Settings.EXTRA_NOTIFICATION_LISTENER_COMPONENT_NAME, pkg)
                                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                }
                                startActivity(intent)
                                result.success(true)
                            } catch (e: Exception) {
                                try {
                                    val fallback = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS).apply {
                                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                    }
                                    startActivity(fallback)
                                    result.success(true)
                                } catch (e2: Exception) {
                                    result.error("NOTIFICATION_SETTINGS_ERROR", e2.message, null)
                                }
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

                    "getBatteryOptimizationApps" -> {
                        ioExecutor.execute {
                            try {
                                val data = getBatteryOptimizationApps()
                                runOnUiThread { result.success(data) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("BATTERY_LIST_ERROR", e.message, null) }
                            }
                        }
                    }

                    "openAppBatteryOptimizationSettings" -> {
                        val pkg = call.argument<String>("packageName")
                        if (pkg.isNullOrBlank()) {
                            result.error("NO_PACKAGE", "packageName missing", null)
                        } else {
                            try {
                                val intent = Intent().apply {
                                    action = "android.settings.APPLICATION_DETAILS_SETTINGS"
                                    putExtra("android.provider.extra.APP_PACKAGE", pkg)
                                    data = Uri.parse("package:$pkg")
                                    flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                }
                                startActivity(intent)
                                result.success(true)
                            } catch (e: Exception) {
                                try {
                                    val fallback = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS).apply {
                                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                                    }
                                    startActivity(fallback)
                                    result.success(true)
                                } catch (e2: Exception) {
                                    result.error("BATTERY_OPT_ERROR", e2.message, null)
                                }
                            }
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
                            val nm =
                                getSystemService(Context.NOTIFICATION_SERVICE) as android.app.NotificationManager
                            val enabled =
                                nm.currentInterruptionFilter != android.app.NotificationManager.INTERRUPTION_FILTER_ALL
                            result.success(enabled)
                        } catch (_: Exception) {
                            result.success(false)
                        }
                    }

                    "getDoNotDisturbApps" -> {
                        ioExecutor.execute {
                            try {
                                val data = getDoNotDisturbApps()
                                runOnUiThread { result.success(data) }
                            } catch (e: Exception) {
                                runOnUiThread { result.error("DND_LIST_ERROR", e.message, null) }
                            }
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
    private fun resolveShortcutLanguage(): String {
        val saved = getSharedPreferences("app_prefs", Context.MODE_PRIVATE)
            .getString("app_language", null)

        if (saved == "fa" || saved == "en") return saved

        val systemLang = resources.configuration.locales[0].language
        return if (systemLang == "en") "en" else "fa"
    }

    private fun updateAppShortcuts() {
        val lang = resolveShortcutLanguage()
        val isFa = lang == "fa"

        val scanShort = if (isFa) "اسکن" else "Scan"
        val scanLong = if (isFa) "اجرای اسکن امنیتی" else "Run a security scan"
        val riskShort = if (isFa) "اپ‌های پرریسک" else "Risky apps"
        val riskLong = if (isFa) "مشاهده اپ‌های پرریسک" else "View high-risk apps"
        val permShort = if (isFa) "دسترسی‌ها" else "Permissions"
        val permLong = if (isFa) "مشاهده دسترسی‌های اپ‌ها" else "View app permissions"

        fun buildShortcut(
            id: String,
            route: String,
            shortLabel: String,
            longLabel: String,
            iconRes: Int
        ): ShortcutInfoCompat {
            val intent = Intent(this, MainActivity::class.java).apply {
                action = Intent.ACTION_VIEW
                putExtra("shortcut_route", route)
                // Reuse the running FlutterActivity. CLEAR_TASK used to tear
                // down the active engine and could leave the replacement
                // engine waiting on the native splash screen.
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
            }
            return ShortcutInfoCompat.Builder(this, id)
                .setShortLabel(shortLabel)
                .setLongLabel(longLabel)
                .setIcon(IconCompat.createWithResource(this, iconRes))
                .setIntent(intent)
                .build()
        }

        val shortcuts = listOf(
            buildShortcut("scan_now", "dashboardPermission", scanShort, scanLong, R.mipmap.ic_shortcut_scan),
            buildShortcut("risk_apps", "riskApps", riskShort, riskLong, R.mipmap.ic_shortcut_risk),
            buildShortcut("group_permission", "groupPermission", permShort, permLong, R.mipmap.ic_shortcut_permission)
        )

        ShortcutManagerCompat.setDynamicShortcuts(this, shortcuts)
    }
    // ===================== Core helpers =====================
    private fun getOverlayApps(): List<Map<String, Any>> {
        val pm = packageManager
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
        val installed = pm.getInstalledApplications(0)
        val apps = mutableListOf<Map<String, Any>>()

        for (app in installed) {
            if ((app.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue

            try {
                val mode = appOps.checkOpNoThrow(
                    android.app.AppOpsManager.OPSTR_SYSTEM_ALERT_WINDOW,
                    app.uid,
                    app.packageName
                )

                if (mode != android.app.AppOpsManager.MODE_ALLOWED) continue

                val appName = pm.getApplicationLabel(app).toString()
                val iconB64 = getAppIconBase64(app.packageName, 64)

                apps.add(
                    mapOf(
                        "package" to app.packageName,
                        "name" to appName,
                        "icon" to iconB64
                    )
                )
            } catch (_: Exception) {}
        }

        return apps
    }
    private fun getDoNotDisturbApps(): List<Map<String, Any>> {
        val pm = packageManager
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
        val installed = pm.getInstalledApplications(0)
        val apps = mutableListOf<Map<String, Any>>()

        for (app in installed) {
            if ((app.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue

            try {
                val mode =
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q) {
                        appOps.unsafeCheckOpNoThrow(
                            "android:access_notifications",
                            app.uid,
                            app.packageName
                        )
                    } else {
                        appOps.checkOpNoThrow(
                            "android:access_notifications",
                            app.uid,
                            app.packageName
                        )
                    }

                if (mode != android.app.AppOpsManager.MODE_ALLOWED) continue

                val appName = pm.getApplicationLabel(app).toString()
                val iconB64 = getAppIconBase64(app.packageName, 64)

                apps.add(
                    mapOf(
                        "package" to app.packageName,
                        "name" to appName,
                        "icon" to iconB64
                    )
                )
            } catch (_: Exception) {
            }
        }

        return apps
    }
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

    // برای permission های عادی، پرچم REQUESTED_PERMISSION_GRANTED قابل‌اعتماده.
    // ولی این سه‌تا (SYSTEM_ALERT_WINDOW, PACKAGE_USAGE_STATS, WRITE_SETTINGS)
    // از طریق AppOpsManager کنترل می‌شن، نه مکانیزم استاندارد permission؛
    // پرچم استاندارد فقط یعنی اپ توی manifest خودش خواسته، نه این‌که کاربر
    // واقعاً توی تنظیمات روشنش کرده. برای این سه‌تا باید مستقیم از
    // AppOpsManager بپرسیم، وگرنه اپ‌هایی که فقط این permission رو
    // «خواستن» (ولی کاربر رد کرده) اشتباهاً granted حساب می‌شن.
    private fun isPermissionActuallyGranted(
        packageName: String,
        permission: String,
        requestedFlags: Int
    ): Boolean {
        val opString = when (permission) {
            "android.permission.SYSTEM_ALERT_WINDOW" ->
                android.app.AppOpsManager.OPSTR_SYSTEM_ALERT_WINDOW
            "android.permission.PACKAGE_USAGE_STATS" ->
                android.app.AppOpsManager.OPSTR_GET_USAGE_STATS
            "android.permission.WRITE_SETTINGS" ->
                android.app.AppOpsManager.OPSTR_WRITE_SETTINGS
            else -> null
        }

        if (opString == null) {
            return (requestedFlags and PackageInfo.REQUESTED_PERMISSION_GRANTED) != 0
        }

        return try {
            val appOps =
                getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
            val uid = applicationContext.packageManager
                .getApplicationInfo(packageName, 0).uid
            val mode = appOps.checkOpNoThrow(opString, uid, packageName)
            mode == android.app.AppOpsManager.MODE_ALLOWED
        } catch (_: Exception) {
            false
        }
    }

    private fun getGrantedPermissionsForPackage(pkg: String): List<String> {
        val pm = applicationContext.packageManager
        val granted = mutableListOf<String>()
        val info = pm.getPackageInfo(pkg, PackageManager.GET_PERMISSIONS)

        info.requestedPermissions?.forEachIndexed { index, permission ->
            val flagsArray = info.requestedPermissionsFlags
            val flags = if (flagsArray != null && index < flagsArray.size) flagsArray[index] else 0
            if (isPermissionActuallyGranted(pkg, permission, flags)) {
                granted.add(permission)
            }
        }
        return granted
    }

    private fun getAppIconBase64(pkg: String, size: Int): String {
        val pm = applicationContext.packageManager
        val appInfo = pm.getApplicationInfo(pkg, 0)
        val drawable = pm.getApplicationIcon(appInfo)

        val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)

        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
        return Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
    }

    private fun getInstalledAppsListHeavy(): List<Map<String, Any>> {
        val pm: PackageManager = applicationContext.packageManager
        val packages = pm.getInstalledPackages(PackageManager.GET_PERMISSIONS)
        val apps = mutableListOf<Map<String, Any>>()

        for (pkg in packages) {
            val appInfo = pkg.applicationInfo ?: continue
            if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue

            // کل پردازش این پکیج توی try-catch است: اگه یک پکیج خاص (مثلاً
            // یک پکیج محافظت‌شده‌ی سامسونگ/Knox) روی هر کدوم از این خط‌ها
            // (getApplicationLabel، getApplicationIcon و ...) Exception بده،
            // فقط همین یک اپ با continue رد می‌شه و پردازش بقیه‌ی اپ‌ها ادامه
            // پیدا می‌کنه. قبلاً فقط ساخت آیکون try-catch داشت، نه کل بلوک؛
            // یعنی خطا روی هر بخش دیگه (مثل getApplicationLabel) کل تابع رو
            // متوقف می‌کرد و همه‌ی اپ‌ها (نه فقط همون یکی) از دست می‌رفتن.
            try {
                val appName = pm.getApplicationLabel(appInfo).toString()
                val packageName = appInfo.packageName

                val grantedPermissions = mutableListOf<String>()
                pkg.requestedPermissions?.forEachIndexed { index, permission ->
                    val flagsArray = pkg.requestedPermissionsFlags
                    val flags = if (flagsArray != null && index < flagsArray.size) flagsArray[index] else 0
                    if (isPermissionActuallyGranted(packageName, permission, flags)) {
                        grantedPermissions.add(permission)
                    }
                }

                var encodedIcon = ""
                try {
                    val drawable = pm.getApplicationIcon(appInfo)
                    // سایز ثابت به‌جای intrinsicWidth/Height: بعضی آیکون‌ها (خصوصاً روی
                    // گوشی‌های xxxhdpi) می‌تونن ۱۹۲px یا بیشتر باشن؛ با صدها اپ نصب‌شده
                    // روی یک گوشی واقعی، این یعنی صدها Bitmap بزرگ که ساخت و فشرده‌سازیشون
                    // زمان‌بره و باعث گیر کردن UI روی «در حال بارگذاری» می‌شه.
                    val size = 96
                    val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
                    val canvas = Canvas(bitmap)
                    drawable.setBounds(0, 0, size, size)
                    drawable.draw(canvas)

                    val stream = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
                    encodedIcon = Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
                } catch (_: Exception) {
                    // اگه فقط آیکون خطا بده، بقیه‌ی اطلاعات اپ (اسم/پرمیشن) بازم ثبت می‌شه
                }

                apps.add(
                    mapOf(
                        "name" to appName,
                        "package" to packageName,
                        "icon" to encodedIcon,
                        "permissions" to grantedPermissions
                    )
                )
            } catch (_: Exception) {}
        }

        return apps
    }

    private fun getInstalledAppsListWithLocation(): List<Map<String, Any>> {
        val pm: PackageManager = applicationContext.packageManager
        val packages = pm.getInstalledPackages(PackageManager.GET_PERMISSIONS)
        val apps = mutableListOf<Map<String, Any>>()

        for (pkg in packages) {
            val appInfo = pkg.applicationInfo ?: continue
            if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue

            // مثل getInstalledAppsListHeavy: کل پردازش هر پکیج توی try-catch
            // است تا اگه یک پکیج خاص (مثلاً Knox-protected) خطا بده، فقط
            // همون رد بشه، نه کل لیست.
            try {
                val appName = pm.getApplicationLabel(appInfo).toString()
                val packageName = appInfo.packageName

                var encodedIcon = ""
                try {
                    val drawable = pm.getApplicationIcon(appInfo)
                    val size = 96
                    val bitmap = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
                    val canvas = Canvas(bitmap)
                    drawable.setBounds(0, 0, size, size)
                    drawable.draw(canvas)
                    val stream = ByteArrayOutputStream()
                    bitmap.compress(Bitmap.CompressFormat.PNG, 90, stream)
                    encodedIcon = Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)
                } catch (_: Exception) {}

                // به‌جای یک درخواست جدا از Dart برای هر اپ، همینجا محاسبه می‌شه
                val location = LocationUtils.getLocationStateForPackage(this, packageName)

                apps.add(
                    mapOf(
                        "name" to appName,
                        "package" to packageName,
                        "icon" to encodedIcon,
                        "locationState" to (location["state"] ?: "denied"),
                        "locationPrecision" to (location["precision"] ?: "none")
                    )
                )
            } catch (_: Exception) {}
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
        val pm = packageManager
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
        val installed = pm.getInstalledApplications(0)
        val apps = mutableListOf<Map<String, Any>>()

        for (app in installed) {
            if ((app.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue

            try {
                val mode = appOps.checkOpNoThrow(
                    android.app.AppOpsManager.OPSTR_GET_USAGE_STATS,
                    app.uid,
                    app.packageName
                )

                if (mode != android.app.AppOpsManager.MODE_ALLOWED) continue

                val appName = pm.getApplicationLabel(app).toString()
                val iconB64 = getAppIconBase64(app.packageName, 64)

                apps.add(
                    mapOf(
                        "package" to app.packageName,
                        "name" to appName,
                        "icon" to iconB64,
                        "hasPermission" to true
                    )
                )
            } catch (_: Exception) {}
        }

        return apps
    }

    private fun getBatteryOptimizationApps(): List<Map<String, Any>> {
        val pm = packageManager
        val powerManager = getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
        val installed = pm.getInstalledApplications(0)
        val apps = mutableListOf<Map<String, Any>>()

        for (app in installed) {
            if ((app.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue
            try {
                if (!powerManager.isIgnoringBatteryOptimizations(app.packageName)) continue
                val appName = pm.getApplicationLabel(app).toString()
                val iconB64 = getAppIconBase64(app.packageName, 64)
                apps.add(mapOf("package" to app.packageName, "name" to appName, "icon" to iconB64))
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
        val seenPackages = mutableSetOf<String>()

        enabledListeners.split(":").forEach { flat ->
            if (flat.isBlank()) return@forEach
            val cn = android.content.ComponentName.unflattenFromString(flat) ?: return@forEach
            val pkg = cn.packageName

            if (pkg in seenPackages) return@forEach
            seenPackages.add(pkg)

            try {
                val appInfo = pm.getApplicationInfo(pkg, 0)
                if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) return@forEach

                val appName = pm.getApplicationLabel(appInfo).toString()
                val iconB64 = getAppIconBase64(pkg, 64)

                apps.add(
                    mapOf(
                        "package" to pkg,
                        "name" to appName,
                        "icon" to iconB64,
                        "component" to flat
                    )
                )
            } catch (_: Exception) {}
        }

        return apps
    }

    private fun isAnyNonSystemNotificationListenerEnabled(): Boolean {
        val enabledListeners =
            Settings.Secure.getString(contentResolver, "enabled_notification_listeners")
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
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
        val packages = pm.getInstalledApplications(0)
        for (app in packages) {
            if ((app.flags and ApplicationInfo.FLAG_SYSTEM) != 0) continue
            val mode = appOps.checkOpNoThrow(
                android.app.AppOpsManager.OPSTR_SYSTEM_ALERT_WINDOW,
                app.uid, app.packageName
            )
            if (mode == android.app.AppOpsManager.MODE_ALLOWED) return true
        }
        return false
    }
}
