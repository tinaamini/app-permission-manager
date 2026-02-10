import 'package:flutter/services.dart';
import 'package:permissions_app/core/models/scan_model.dart';

class ScanService {
  ScanService._();

  static const MethodChannel _installedAppsChannel =
  MethodChannel('permission_channel');

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
