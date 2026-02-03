import 'package:flutter/services.dart';
import 'package:permissions_app/core/models/scan_model.dart';

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

  static Future<ScanSnapshot> takeSnapshot() async {
    final List<dynamic> raw =
    await _installedAppsChannel.invokeMethod('getInstalledAppsList');

    final apps = raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();

    final map = <String, AppPermSnapshot>{};

    for (final m in apps) {
      final pkg = (m['package'] ?? '').toString();
      if (pkg.isEmpty) continue;

      final perms = (m['permissions'] as List<dynamic>? ?? const [])
          .map((x) => x.toString())
          .toSet();

      map[pkg] = AppPermSnapshot(
        packageName: pkg,
        name: (m['name'] ?? '').toString(),
        iconBase64: m['icon']?.toString(),
        grantedPerms: perms,
      );
    }

    return ScanSnapshot(
      timestampMs: DateTime.now().millisecondsSinceEpoch,
      appsByPackage: map,
    );
  }

}
