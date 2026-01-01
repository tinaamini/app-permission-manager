import 'package:flutter/services.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/models/app_permission_ui.dart';

class AppPermissionPlatform {
  static const MethodChannel _channel =
  MethodChannel('permission_channel');

  Future<List<AppPermissionUi>> getInstalledApps() async {
    final List<dynamic> data =
    await _channel.invokeMethod('getInstalledAppsList');

    return data.map((e) {
      return AppPermissionUi(
        appName: e['name'],
        packageName: e['package'],
        iconBase64: e['icon'],
        permissions: List<String>.from(e['permissions'] ?? []),
        riskLevel: RiskLevel.noRisk,
      );
    }).toList();
  }


  Future<void> openAppSettings(String packageName) async {
    await _channel.invokeMethod(
      'openAppSettings',
      {'packageName': packageName},
    );
  }
  Future<void> openAccessibilitySettings() async {
    await _channel.invokeMethod('openAccessibilitySettings');
  }



}
