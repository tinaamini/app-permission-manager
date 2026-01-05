import 'package:flutter/services.dart';

class RecentAppsService {
  static const _channel = MethodChannel('recent_apps');

  static Future<List<dynamic>> getTodayRecentApps() async {
    final result = await _channel.invokeMethod('getTodayRecentApps');
    return result;
  }
}
