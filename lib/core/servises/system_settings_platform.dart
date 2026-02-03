import 'package:flutter/services.dart';

class SystemSettingsPlatform {
  static const MethodChannel _ch = MethodChannel('system_settings');

  static Future<void> openPrivacySettings() async {
    await _ch.invokeMethod('openPrivacySettings');
  }

  static Future<void> openPermissionManager() async {
    await _ch.invokeMethod('openPermissionManager');
  }
}
