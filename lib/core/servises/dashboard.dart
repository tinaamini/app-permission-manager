import 'package:flutter/services.dart';
import 'package:Privio/core/models/app_permission_item.dart';


class DashboardPermissionService {
  DashboardPermissionService._();

  static const MethodChannel _installedAppsChannel =
  MethodChannel('permission_channel');

  static final Map<String, Map<String, dynamic>> _locationCache = {};

  static Future<List<AppPermissionItem>> loadAppsWithLocation({
    int concurrency = 6,
  }) async {

    final List<dynamic> raw = await _installedAppsChannel
        .invokeMethod('getInstalledAppsListWithLocation');

    final apps = raw
        .map((e) => Map<String, dynamic>.from(e as Map))
        .map((m) => AppPermissionItem(
      name: (m['name'] ?? '').toString(),
      packageName: (m['package'] ?? '').toString(),
      iconBase64: m['icon']?.toString(),
      locationState: (m['locationState'] ?? 'denied').toString(),
      locationPrecision: (m['locationPrecision'] ?? 'none').toString(),
    ))
        .where((a) => a.packageName.isNotEmpty)
        .toList();

    return apps;
  }

  static void clearCache() => _locationCache.clear();
}