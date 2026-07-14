import 'package:flutter/services.dart';

class AppSpecialPermissionPlatform {
  static const MethodChannel _channel =
  MethodChannel('app_permission_channel');

  // ===== Usage Access =====
  Future<void> openUsageAccessSettings() async {
    try {
      await _channel.invokeMethod('openUsageAccessSettings');
    } catch (_) {}
  }


  Future<bool> checkUsageAccess() async {
    try {
      final bool? result =
      await _channel.invokeMethod<bool>('checkUsageAccess');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getUsageAccessApps() async {
    try {
      final List result =
      await _channel.invokeMethod('getUsageAccessApps');

      return result
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }


  // ===== Overlay =====
  Future<void> openOverlaySettings() async {
    try {
      await _channel.invokeMethod('openOverlaySettings');
    } catch (_) {}
  }

  Future<List<Map<String, dynamic>>> getOverlayApps() async {
    try {
      final List result = await _channel.invokeMethod('getOverlayApps');
      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<bool> checkOverlayPermission() async {
    try {
      final bool? result =
      await _channel.invokeMethod<bool>('checkOverlayPermission');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> openAppOverlaySettings(String packageName) async {
    try {
      await _channel.invokeMethod('openAppOverlaySettings', {'packageName': packageName});
    } catch (_) {}
  }

  // ===== All Files Access (MANAGE_EXTERNAL_STORAGE) =====
  Future<void> openAppAllFilesAccessSettings(String packageName) async {
    try {
      await _channel.invokeMethod(
        'openAppAllFilesAccessSettings',
        {'packageName': packageName},
      );
    } catch (_) {}
  }

  // ===== Modify System Settings (WRITE_SETTINGS) =====
  Future<void> openAppWriteSettingsSettings(String packageName) async {
    try {
      await _channel.invokeMethod(
        'openAppWriteSettingsSettings',
        {'packageName': packageName},
      );
    } catch (_) {}
  }

  // ===== Notification Access =====
  Future<void> openNotificationAccessSettings() async {
    try {
      await _channel.invokeMethod('openNotificationAccessSettings');
    } catch (_) {}
  }

  Future<bool> checkNotificationAccess() async {
    try {
      final bool? result =
      await _channel.invokeMethod<bool>('checkNotificationAccess');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getNotificationAccessApps() async {
    try {
      final List result =
      await _channel.invokeMethod('getNotificationAccessApps');

      return result
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> openAppNotificationSettings(String packageName) async {
    await _channel.invokeMethod(
      'openAppNotificationSettings',
      {'packageName': packageName},
    );
  }


  // ===== Battery Optimization =====
  Future<void> openBatteryOptimizationSettings() async {
    try {
      await _channel.invokeMethod('openBatteryOptimizationSettings');
    } catch (_) {}
  }

  Future<bool> isIgnoringBatteryOptimizations() async {
    try {
      final bool? result =
      await _channel.invokeMethod<bool>('checkBatteryOptimization');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getBatteryOptimizationApps() async {
    try {
      final List result = await _channel.invokeMethod('getBatteryOptimizationApps');
      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> openAppBatteryOptimizationSettings(String packageName) async {
    try {
      await _channel.invokeMethod('openAppBatteryOptimizationSettings', {'packageName': packageName});
    } catch (_) {}
  }


  // ===== Do Not Disturb =====
  Future<void> openDoNotDisturbSettings() async {
    try {
      await _channel.invokeMethod('openDoNotDisturbSettings');
    } catch (_) {}
  }

  Future<bool> isDoNotDisturbEnabled() async {
    try {
      final bool? result =
      await _channel.invokeMethod<bool>('checkDoNotDisturb');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getDoNotDisturbApps() async {
    try {
      final List result = await _channel.invokeMethod('getDoNotDisturbApps');
      return result.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      return [];
    }
  }




}