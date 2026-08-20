package com.microdev.permissiondetector

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build

object LocationUtils {

    fun getLocationStateForPackage(context: Context, pkg: String): Map<String, String> {
        val pm = context.packageManager

        val fineGranted =
            pm.checkPermission(Manifest.permission.ACCESS_FINE_LOCATION, pkg) ==
                    PackageManager.PERMISSION_GRANTED

        val coarseGranted =
            pm.checkPermission(Manifest.permission.ACCESS_COARSE_LOCATION, pkg) ==
                    PackageManager.PERMISSION_GRANTED

        if (!fineGranted && !coarseGranted) {
            return mapOf("state" to "denied", "precision" to "none")
        }

        val precision = if (fineGranted) "precise" else "approximate"

        val bgGranted = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            pm.checkPermission(Manifest.permission.ACCESS_BACKGROUND_LOCATION, pkg) ==
                    PackageManager.PERMISSION_GRANTED
        } else {
            true
        }

        val state = if (bgGranted) "always" else "while_in_use"
        return mapOf("state" to state, "precision" to precision)
    }
}
