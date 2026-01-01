package com.example.permissions_app
import android.content.pm.PackageInfo

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.util.Base64
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

class MainActivity : FlutterActivity() {

    private val CHANNEL = "permission_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {

                "getInstalledAppsList" -> {
                    try {
                        result.success(getInstalledAppsList())
                    } catch (e: Exception) {
                        result.error("APP_LIST_ERROR", e.message, null)
                    }
                }

                "openAppSettings" -> {
                    val packageName = call.argument<String>("packageName")
                    if (packageName != null) {
                        val intent =
                            Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
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
    }

    /**
     * Returns ONLY user-installed apps (no system apps)
     * with name, package, icon (base64) and permissions
     */
    /**
     * Returns ONLY user-installed apps (no system apps)
     * with name, package, icon (base64) and ONLY GRANTED permissions
     */
    private fun getInstalledAppsList(): List<Map<String, Any>> {
        val pm: PackageManager = applicationContext.packageManager
        val packages = pm.getInstalledPackages(PackageManager.GET_PERMISSIONS)
        val apps = mutableListOf<Map<String, Any>>()

        for (pkg in packages) {
            val appInfo = pkg.applicationInfo ?: continue

            // Skip system apps
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
                val drawable = pm.getApplicationIcon(appInfo)

                val width =
                    if (drawable.intrinsicWidth > 0) drawable.intrinsicWidth else 96
                val height =
                    if (drawable.intrinsicHeight > 0) drawable.intrinsicHeight else 96

                val bitmap = Bitmap.createBitmap(
                    width,
                    height,
                    Bitmap.Config.ARGB_8888
                )

                val canvas = Canvas(bitmap)
                drawable.setBounds(0, 0, canvas.width, canvas.height)
                drawable.draw(canvas)

                val stream = ByteArrayOutputStream()
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)

                val encodedIcon =
                    Base64.encodeToString(stream.toByteArray(), Base64.NO_WRAP)

                apps.add(
                    mapOf(
                        "name" to appName,
                        "package" to packageName,
                        "icon" to encodedIcon,
                        "permissions" to grantedPermissions
                    )
                )
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        return apps
    }
}
