import 'package:flutter/services.dart';
import 'package:Privio/core/models/scan_model.dart';

class SafeDashboardPlatform {
  static const MethodChannel _channel =
  MethodChannel('permissions/safe_dashboard');

  static Future<bool> isAccessibilityEnabled() async {
    final bool? result =
    await _channel.invokeMethod<bool>('isAccessibilityEnabled');
    return result ?? false;
  }

  static Future<void> openAccessibilitySettings() async {
    await _channel.invokeMethod('openAccessibilitySettings');
  }

  static Future<Map<String, dynamic>> getLocationState(String packageName) async {
    final Map result = await _channel.invokeMethod('getLocationState', {
      'packageName': packageName,
    });
    return Map<String, dynamic>.from(result);
  }

  static Future<void> openAppLocationSettings(String packageName) async {
    await _channel.invokeMethod('openAppLocationSettings', {
      'packageName': packageName,
    });
  }


}
