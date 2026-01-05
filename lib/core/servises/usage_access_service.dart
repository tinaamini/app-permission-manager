import 'package:flutter/services.dart';

class UsageAccessService {
  static const _channel = MethodChannel('android_intent');

  static Future<void> openUsageAccessSettings() async {
    await _channel.invokeMethod('openUsageAccess');
  }

  static Future<bool> isUsageAccessGranted() async {
    final bool granted =
    await _channel.invokeMethod('checkUsageAccess');
    return granted;
  }

}
