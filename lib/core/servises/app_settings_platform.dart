import 'package:flutter/services.dart';

class AppSettingsPlatform {
  static const MethodChannel _ch = MethodChannel('permission_channel');

  static Future<void> openAppSettings(String packageName) async {
    await _ch.invokeMethod('openAppSettings', {'packageName': packageName});
  }
}
