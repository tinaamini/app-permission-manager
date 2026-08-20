package com.microdev.permissiondetector

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.app.Service
import android.os.Build
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.work.ExistingWorkPolicy
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.util.Locale
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import androidx.core.text.BidiFormatter
import androidx.core.text.TextDirectionHeuristicsCompat

// ===================== زبان اپ =====================
object AppLanguage {
    private const val PREFS = "app_prefs"
    private const val KEY = "app_language"

    fun get(context: Context): String {
        val prefs = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
        return prefs.getString(KEY, null)
            ?: if (Locale.getDefault().language == "fa") "fa" else "en"
    }

    fun isFa(context: Context): Boolean = get(context) == "fa"
}

fun wrapAppName(name: String): String =
    BidiFormatter.getInstance().unicodeWrap(name, TextDirectionHeuristicsCompat.LTR)
fun rtlParagraph(text: String): String = "\u200F$text"
// ===================== نوتیفیکیشن‌ها =====================
object SecurityNotifications {
    private const val ALERTS_CHANNEL = "security_alerts"
    private const val REMINDERS_CHANNEL = "scan_reminders"

    fun initialize(context: Context) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val fa = AppLanguage.isFa(context)
        val manager = context.getSystemService(NotificationManager::class.java)
        manager.createNotificationChannels(
            listOf(
                NotificationChannel(
                    ALERTS_CHANNEL,
                    if (fa) "هشدارهای امنیتی" else "Security alerts",
                    NotificationManager.IMPORTANCE_HIGH,
                ).apply {
                    description = if (fa)
                        "نصب اپ پرریسک و تغییر دسترسی برنامه‌ها"
                    else
                        "High-risk installs and app permission changes"
                },
                NotificationChannel(
                    REMINDERS_CHANNEL,
                    if (fa) "یادآوری اسکن" else "Scan reminders",
                    NotificationManager.IMPORTANCE_DEFAULT,
                ),
            ),
        )
    }

    fun highRiskApp(context: Context, appName: String, packageName: String? = null) {
        val fa = AppLanguage.isFa(context)
        val safeName = wrapAppName(appName)
        show(
            context,
            ALERTS_CHANNEL,
            appName.hashCode(),
            if (fa) "اپ پرریسک جدید نصب شد" else "New high-risk app installed",
            if (fa) rtlParagraph("$safeName دسترسی‌های حساسی دارد و بهتر است بررسی شود.")
            else "$appName has sensitive permissions and should be reviewed.",
            packageName = packageName,
        )
    }

    fun showReadyOnce(context: Context) {
        val prefs = context.getSharedPreferences(
            "security_notifications",
            Context.MODE_PRIVATE,
        )
        if (prefs.getBoolean("ready_notification_shown", false)) return
        val fa = AppLanguage.isFa(context)
        if (show(
                context,
                ALERTS_CHANNEL,
                73000,
                if (fa) "هشدارهای امنیتی فعال شد" else "Security alerts are active",
                if (fa) "${wrapAppName("Privio")} نصب اپ‌های پرریسک و تغییر دسترسی‌ها را بررسی می‌کند."
                else "Privio will monitor high-risk installs and permission changes.",
            )
        ) {
            prefs.edit().putBoolean("ready_notification_shown", true).apply()
        }
    }

    fun permissionsChanged(
        context: Context,
        appName: String,
        addedCount: Int,
        packageName: String? = null,
    ) {
        val fa = AppLanguage.isFa(context)
        val safeName = wrapAppName(appName)
        show(
            context,
            ALERTS_CHANNEL,
            appName.hashCode() xor 0x4f21,
            if (fa) "دسترسی‌های برنامه تغییر کرد" else "App permissions changed",
            if (fa)
                rtlParagraph(
                    if (addedCount > 0) " $safeName  دسترسی جدید دریافت کرده است."
                    else "برخی دسترسی‌های $safeName تغییر کرده‌اند."
                )
            else
                if (addedCount > 0) "$appName gained $addedCount new permission(s)."
                else "Some permissions used by $appName have changed.",
            packageName = packageName,
        )
    }

    fun scanReminder(context: Context) {
        val fa = AppLanguage.isFa(context)
        show(
            context,
            REMINDERS_CHANNEL,
            73001,
            if (fa) "زمان بررسی امنیت اپ‌هاست" else "Time for a security check",
            if (fa) " را باز کنید و یک اسکن جدید انجام دهید."
            else "Open Privio and run a new app permission scan.",
        )
    }

    private fun show(
        context: Context,
        channel: String,
        id: Int,
        title: String,
        body: String,
        packageName: String? = null,
    ): Boolean {
        if (Build.VERSION.SDK_INT >= 33 &&
            context.checkSelfPermission(Manifest.permission.POST_NOTIFICATIONS) !=
            PackageManager.PERMISSION_GRANTED
        ) return false
        if (!NotificationManagerCompat.from(context).areNotificationsEnabled()) return false

        val launchIntent = context.packageManager
            .getLaunchIntentForPackage(context.packageName)
            ?.apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                if (packageName != null) putExtra("notification_package_name", packageName)
            }
            ?: return false
        val pendingIntent = PendingIntent.getActivity(
            context,
            id,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val notification = NotificationCompat.Builder(context, channel)
            .setSmallIcon(R.drawable.ic_stat)
            .setContentTitle(title)
            .setContentText(body)
            .setStyle(NotificationCompat.BigTextStyle().bigText(body))
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()
        NotificationManagerCompat.from(context).notify(id, notification)
        return true
    }
}

// ===================== بقیه کلاس‌ها بدون تغییر =====================

object SecurityWorkScheduler {
    fun schedule(context: Context) {
        val manager = WorkManager.getInstance(context)
        manager.enqueueUniqueWork(
            "privio_security_scan_initial",
            ExistingWorkPolicy.KEEP,
            OneTimeWorkRequestBuilder<SecurityScanWorker>().build(),
        )
        manager.enqueueUniquePeriodicWork(
            "privio_security_scan",
            ExistingPeriodicWorkPolicy.KEEP,
            PeriodicWorkRequestBuilder<SecurityScanWorker>(24, TimeUnit.HOURS)
                .build(),
        )
        manager.enqueueUniquePeriodicWork(
            "privio_scan_reminder",
            ExistingPeriodicWorkPolicy.KEEP,
            PeriodicWorkRequestBuilder<ScanReminderWorker>(7, TimeUnit.DAYS)
                .build(),
        )
    }
}

class PermissionMonitorService : Service() {
    private val scanExecutor = Executors.newSingleThreadScheduledExecutor()

    override fun onCreate() {
        super.onCreate()
        SecurityNotifications.initialize(this)

        val fa = AppLanguage.isFa(this)

        val launchIntent = packageManager
            .getLaunchIntentForPackage(packageName)
            ?.apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
        val pendingIntent = launchIntent?.let {
            PendingIntent.getActivity(
                this,
                73002,
                it,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
        }

        val notification = NotificationCompat.Builder(this, "scan_reminders")
            .setSmallIcon(R.drawable.ic_stat)
            .setContentTitle("Privio")
            .setContentText(
                if (fa) "مانیتورینگ دسترسی‌های امنیتی فعال است"
                else "Security permission monitoring is active"
            )
            .setOngoing(true)
            .setCategory(NotificationCompat.CATEGORY_SERVICE)
            .setContentIntent(pendingIntent)
            .build()
        startForeground(73002, notification)

        scanExecutor.scheduleWithFixedDelay(
            { runCatching { scanForChanges() } },
            0,
            60,
            TimeUnit.SECONDS,
        )
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int = START_STICKY

    override fun onDestroy() {
        scanExecutor.shutdownNow()
        super.onDestroy()
    }

    private fun scanForChanges() {
        val current = DeviceSecurityScanner.snapshot(this)
        val prefs = getSharedPreferences("security_scan", MODE_PRIVATE)
        current.forEach { (packageName, app) ->
            val old = prefs.getStringSet("permissions_$packageName", emptySet()).orEmpty()
            if (old.isNotEmpty() && old != app.permissions) {
                SecurityNotifications.permissionsChanged(
                    this,
                    app.name,
                    app.permissions.minus(old).size,
                    packageName,
                )
            }
        }
        DeviceSecurityScanner.saveSnapshot(this, current, prefs.getStringSet("packages", null))
    }

    override fun onBind(intent: Intent?) = null

    companion object {
        fun start(context: Context) {
            val intent = Intent(context, PermissionMonitorService::class.java)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }
    }
}

class SecurityScanWorker(
    context: Context,
    params: WorkerParameters,
) : Worker(context, params) {
    override fun doWork(): Result {
        SecurityNotifications.initialize(applicationContext)
        return try {
            val current = DeviceSecurityScanner.snapshot(applicationContext)
            val prefs = applicationContext.getSharedPreferences("security_scan", Context.MODE_PRIVATE)
            val previousPackages = prefs.getStringSet("packages", null)

            if (previousPackages != null) {
                current.forEach { (pkg, app) ->
                    if (pkg !in previousPackages) {
                        if (DeviceSecurityScanner.isHighRisk(app.permissions)) {
                            SecurityNotifications.highRiskApp(applicationContext, app.name, pkg)
                        }
                    } else {
                        val oldPermissions = prefs.getStringSet("permissions_$pkg", emptySet()) ?: emptySet()
                        if (oldPermissions != app.permissions) {
                            val added = app.permissions.minus(oldPermissions).size
                            SecurityNotifications.permissionsChanged(
                                applicationContext,
                                app.name,
                                added,
                                pkg,
                            )
                        }
                    }
                }
            }
            DeviceSecurityScanner.saveSnapshot(applicationContext, current, previousPackages)
            Result.success()
        } catch (_: Exception) {
            Result.retry()
        }
    }
}

class ScanReminderWorker(
    context: Context,
    params: WorkerParameters,
) : Worker(context, params) {
    override fun doWork(): Result {
        SecurityNotifications.initialize(applicationContext)
        SecurityNotifications.scanReminder(applicationContext)
        return Result.success()
    }
}

class AppInstallReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Intent.ACTION_PACKAGE_ADDED ||
            intent.getBooleanExtra(Intent.EXTRA_REPLACING, false)
        ) return
        SecurityNotifications.initialize(context)
        val packageName = intent.data?.schemeSpecificPart ?: return
        val app = DeviceSecurityScanner.readDeclaredApp(context, packageName) ?: return
        if (DeviceSecurityScanner.isHighRisk(app.permissions)) {
            SecurityNotifications.highRiskApp(context, app.name, packageName)
        }
    }
}

data class ScannedApp(val name: String, val permissions: Set<String>)

object DeviceSecurityScanner {
    fun snapshot(context: Context): Map<String, ScannedApp> {
        val pm = context.packageManager
        return pm.getInstalledPackages(PackageManager.GET_PERMISSIONS)
            .mapNotNull { info ->
                val appInfo = info.applicationInfo ?: return@mapNotNull null
                if ((appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0) return@mapNotNull null
                val permissions = grantedPermissions(pm, info)
                info.packageName to ScannedApp(
                    pm.getApplicationLabel(appInfo).toString(),
                    permissions,
                )
            }
            .toMap()
    }

    fun readApp(context: Context, packageName: String): ScannedApp? {
        return try {
            val pm = context.packageManager
            val info = pm.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS)
            val appInfo = info.applicationInfo ?: return null
            ScannedApp(
                pm.getApplicationLabel(appInfo).toString(),
                grantedPermissions(pm, info),
            )
        } catch (_: Exception) {
            null
        }
    }

    fun readDeclaredApp(context: Context, packageName: String): ScannedApp? {
        return try {
            val pm = context.packageManager
            val info = pm.getPackageInfo(packageName, PackageManager.GET_PERMISSIONS)
            val appInfo = info.applicationInfo ?: return null
            ScannedApp(
                pm.getApplicationLabel(appInfo).toString(),
                info.requestedPermissions?.toSet().orEmpty(),
            )
        } catch (_: Exception) {
            null
        }
    }

    fun saveSnapshot(
        context: Context,
        current: Map<String, ScannedApp>,
        previousPackages: Set<String>?,
    ) {
        val prefs = context.getSharedPreferences("security_scan", Context.MODE_PRIVATE)
        prefs.edit().apply {
            previousPackages.orEmpty().minus(current.keys)
                .forEach { remove("permissions_$it") }
            putStringSet("packages", current.keys)
            current.forEach { (pkg, app) ->
                putStringSet("permissions_$pkg", app.permissions)
            }
            apply()
        }
    }

    fun isHighRisk(permissions: Set<String>): Boolean {
        var score = 0
        permissions.forEach {
            if (it in sensitive) score += 10
            if (it in dangerous) score += 25
            if (it in special) score += 40
        }
        if ("android.permission.CAMERA" in permissions &&
            "android.permission.RECORD_AUDIO" in permissions
        ) score += 20
        if ("android.permission.ACCESS_FINE_LOCATION" in permissions &&
            "android.permission.INTERNET" in permissions
        ) score += 20
        if (permissions.any { it in callRelated } &&
            "android.permission.INTERNET" in permissions
        ) score += 30

        val hasCall = permissions.any { it in callRelated }
        val hasSms = permissions.any { it in smsRelated }
        val hasCamera = "android.permission.CAMERA" in permissions
        val hasMic = "android.permission.RECORD_AUDIO" in permissions
        val hasInternet = "android.permission.INTERNET" in permissions
        val category = when {
            hasCall || hasSms -> "telephony"
            hasCamera && hasMic && hasInternet -> "messaging"
            hasInternet && permissions.size <= 3 -> "network"
            else -> "utility"
        }
        permissions.forEach {
            if (it in callRelated && category == "utility") score += 80
            if (it in smsRelated && category != "messaging") score += 70
            if (it == "android.permission.RECORD_AUDIO" &&
                category == "utility"
            ) score += 40
            if (it in locationRelated && category == "utility" &&
                !hasInternet
            ) score += 30
        }
        return score > 100
    }

    private fun grantedPermissions(pm: PackageManager, info: PackageInfo): Set<String> {
        val requested = info.requestedPermissions ?: return emptySet()
        val flags = info.requestedPermissionsFlags ?: return emptySet()
        return requested.mapIndexedNotNull { index, permission ->
            if (index < flags.size &&
                flags[index] and PackageInfo.REQUESTED_PERMISSION_GRANTED != 0
            ) permission else null
        }.toSet()
    }

    private val sensitive = setOf(
        "android.permission.CAMERA",
        "android.permission.RECORD_AUDIO",
        "android.permission.ACCESS_FINE_LOCATION",
        "android.permission.ACCESS_COARSE_LOCATION",
        "android.permission.READ_CONTACTS",
        "android.permission.WRITE_CONTACTS",
        "android.permission.READ_CALENDAR",
        "android.permission.WRITE_CALENDAR",
    )
    private val dangerous = setOf(
        "android.permission.READ_CALL_LOG",
        "android.permission.WRITE_CALL_LOG",
        "android.permission.READ_SMS",
        "android.permission.SEND_SMS",
        "android.permission.RECEIVE_SMS",
        "android.permission.RECEIVE_MMS",
        "android.permission.ANSWER_PHONE_CALLS",
        "android.permission.READ_PHONE_STATE",
    )
    private val special = setOf(
        "android.permission.SYSTEM_ALERT_WINDOW",
        "android.permission.WRITE_SETTINGS",
        "android.permission.PACKAGE_USAGE_STATS",
        "android.permission.BIND_ACCESSIBILITY_SERVICE",
        "android.permission.MANAGE_EXTERNAL_STORAGE",
    )
    private val callRelated = setOf(
        "android.permission.READ_CALL_LOG",
        "android.permission.WRITE_CALL_LOG",
        "android.permission.READ_PHONE_STATE",
        "android.permission.ANSWER_PHONE_CALLS",
    )
    private val smsRelated = setOf(
        "android.permission.READ_SMS",
        "android.permission.SEND_SMS",
        "android.permission.RECEIVE_SMS",
        "android.permission.RECEIVE_MMS",
    )
    private val locationRelated = setOf(
        "android.permission.ACCESS_FINE_LOCATION",
        "android.permission.ACCESS_COARSE_LOCATION",
    )
}