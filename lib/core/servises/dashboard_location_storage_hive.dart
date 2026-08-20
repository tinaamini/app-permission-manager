import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:Privio/core/models/app_permission_item.dart';


class DashboardLocationStorageHive {
  static const String _boxName = 'dashboard_location_cache_v1';
  static const String _keyApps = 'apps_meta_json';
  static const String _keyAccessibility = 'accessibility_on';
  static const String _keyTimestamp = 'timestamp_ms';

  static List<AppPermissionItem>? _memoryApps;
  static bool? _memoryAccessibility;

  static Future<Box> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box(_boxName);
    return Hive.openBox(_boxName);
  }

  static Future<void> save({
    required List<AppPermissionItem> apps,
    required bool accessibilityOn,
  }) async {
    _memoryApps = List<AppPermissionItem>.from(apps);
    _memoryAccessibility = accessibilityOn;

    final box = await _box();
    final meta = apps
        .map((a) => a.copyWith(clearIcon: true).toJson(includeIcon: false))
        .toList();
    await box.put(_keyApps, jsonEncode(meta));
    await box.put(_keyAccessibility, accessibilityOn);
    await box.put(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<({List<AppPermissionItem> apps, bool accessibilityOn})?>
  load() async {
    if (_memoryApps != null && _memoryApps!.isNotEmpty) {
      return (
      apps: List<AppPermissionItem>.from(_memoryApps!),
      accessibilityOn: _memoryAccessibility ?? false,
      );
    }

    final box = await _box();
    final jsonStr = box.get(_keyApps);
    if (jsonStr == null || jsonStr is! String || jsonStr.isEmpty) {
      return null;
    }

    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final apps = list
          .map((e) =>
          AppPermissionItem.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      final access = box.get(_keyAccessibility) == true;
      _memoryApps = apps;
      _memoryAccessibility = access;
      return (apps: apps, accessibilityOn: access);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    _memoryApps = null;
    _memoryAccessibility = null;
    final box = await _box();
    await box.delete(_keyApps);
    await box.delete(_keyAccessibility);
    await box.delete(_keyTimestamp);
  }
}