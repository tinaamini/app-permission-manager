import 'package:flutter/services.dart';

class InstalledAppsPlatform {
  InstalledAppsPlatform._();

  static const MethodChannel _channel = MethodChannel('permission_channel');

  static Future<int> getInstalledAppsCount() async {
    final int count = await _channel.invokeMethod<int>('getInstalledAppsCount')
        .then((v) => v ?? 0);
    return count;
  }

  static Future<int> getInstalledAppsCountFromList() async {
    final List<dynamic> apps =
    await _channel.invokeMethod<List<dynamic>>('getInstalledAppsList')
        .then((v) => v ?? <dynamic>[]);
    return apps.length;
  }
}
