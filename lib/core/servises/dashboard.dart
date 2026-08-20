import 'package:flutter/services.dart';
import 'package:Privio/core/models/app_permission_item.dart';
import 'package:Privio/core/servises/dashboard_location_storage_hive.dart';
import 'package:Privio/core/servises/dashboard_permission_service.dart';

class DashboardPermissionService {
  DashboardPermissionService._();

  static const MethodChannel _installedAppsChannel =
  MethodChannel('permission_channel');

  static bool _isBackgroundRefreshing = false;

  static Future<List<AppPermissionItem>> fetchAppsWithLocationFromNative() async {
    final List<dynamic> raw = await _installedAppsChannel
        .invokeMethod('getInstalledAppsListWithLocation');

    return raw
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
  }

  static Future<List<AppPermissionItem>> loadAppsWithLocation({
    int concurrency = 6,
  }) {
    return fetchAppsWithLocationFromNative();
  }

  static Future<({List<AppPermissionItem> apps, bool accessibilityOn})?>
  loadCached() {
    return DashboardLocationStorageHive.load();
  }

  static Future<({List<AppPermissionItem> apps, bool accessibilityOn})>
  fetchAndSave() async {
    final access = await SafeDashboardPlatform.isAccessibilityEnabled();
    final apps = await fetchAppsWithLocationFromNative();
    await DashboardLocationStorageHive.save(
      apps: apps,
      accessibilityOn: access,
    );
    return (apps: apps, accessibilityOn: access);
  }

  static Future<void> refreshInBackground({
    void Function(List<AppPermissionItem> apps, bool accessibilityOn)? onUpdated,
  }) async {
    if (_isBackgroundRefreshing) return;
    _isBackgroundRefreshing = true;
    try {
      final fresh = await fetchAndSave();
      onUpdated?.call(fresh.apps, fresh.accessibilityOn);
    } catch (_) {
      // silent
    } finally {
      _isBackgroundRefreshing = false;
    }
  }

  static Future<void> clearCache() => DashboardLocationStorageHive.clear();
}