package com.microdev.permissiondetector

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.provider.Settings

object AppSettingsNavigator {

    fun openAppLocationSettings(context: Context, pkg: String) {
        // ✅ Always available on all Android versions:
        // Opens app details page where user can manage permissions (including Location)
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
            data = Uri.parse("package:$pkg")
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }

        try {
            context.startActivity(intent)
        } catch (_: Exception) {
            // fallback to general settings
            val fallback = Intent(Settings.ACTION_SETTINGS).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK
            }
            context.startActivity(fallback)
        }
    }

    fun openLocationSettings(context: Context) {
        // Optional: opens general location settings (not per-app)
        val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        try {
            context.startActivity(intent)
        } catch (_: Exception) {}
    }
}
