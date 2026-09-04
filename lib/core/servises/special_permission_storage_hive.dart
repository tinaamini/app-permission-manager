import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:Privio/constant/specialPermissionType.dart';

/// کش Special Permission:
/// - status flags (boolها)
/// - لیست اپ‌ها per type (روی دیسک بدون آیکون، memory با آیکون)
class SpecialPermissionStorageHive {
  static const String _boxName = 'special_permission_cache_v1';
  static const String _keyStatus = 'status_json';
  static const String _keyTimestamp = 'timestamp_ms';

  static Map<String, dynamic>? _memoryStatus;
  static final Map<SpecialPermissionType, List<Map<String, dynamic>>>
      _memoryApps = {};

  static String _appsKey(SpecialPermissionType t) => 'apps_${t.name}';

  static Future<Box> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box(_boxName);
    return Hive.openBox(_boxName);
  }

  // ---------- Status ----------

  static Future<void> saveStatus({
    required bool usageAccess,
    required bool notificationAccess,
    required bool overlay,
    required bool batteryOptimization,
    required bool doNotDisturb,
    required int riskPercent,
    required int usageCount,
    required int notificationCount,
    required int overlayCount,
    required int batteryCount,
    required int dndCount,
  }) async {
    final map = {
      'usageAccess': usageAccess,
      'notificationAccess': notificationAccess,
      'overlay': overlay,
      'batteryOptimization': batteryOptimization,
      'doNotDisturb': doNotDisturb,
      'riskPercent': riskPercent,
      'usageCount': usageCount,
      'notificationCount': notificationCount,
      'overlayCount': overlayCount,
      'batteryCount': batteryCount,
      'dndCount': dndCount,
    };
    _memoryStatus = map;
    final box = await _box();
    await box.put(_keyStatus, jsonEncode(map));
    await box.put(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<Map<String, dynamic>?> loadStatus() async {
    if (_memoryStatus != null) {
      return Map<String, dynamic>.from(_memoryStatus!);
    }
    final box = await _box();
    final raw = box.get(_keyStatus);
    if (raw == null || raw is! String || raw.isEmpty) return null;
    try {
      final map = Map<String, dynamic>.from(jsonDecode(raw) as Map);
      _memoryStatus = map;
      return map;
    } catch (_) {
      return null;
    }
  }

  // ---------- Apps list per type ----------

  static Future<void> saveApps(
    SpecialPermissionType type,
    List<Map<String, dynamic>> apps,
  ) async {
    _memoryApps[type] = apps
        .map((e) => Map<String, dynamic>.from(e))
        .toList();

    // دیسک بدون آیکون
    final box = await _box();
    // Persist the small native thumbnails so reopening a detail page does not
    // need another complete PackageManager scan.
    await box.put(_appsKey(type), jsonEncode(apps));
  }

  static Future<List<Map<String, dynamic>>?> loadApps(
    SpecialPermissionType type,
  ) async {
    final mem = _memoryApps[type];
    if (mem != null) {
      return mem.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    final box = await _box();
    final raw = box.get(_appsKey(type));
    if (raw == null || raw is! String || raw.isEmpty) return null;
    try {
      final list = (jsonDecode(raw) as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      _memoryApps[type] = list;
      return list;
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    _memoryStatus = null;
    _memoryApps.clear();
    final box = await _box();
    await box.clear();
  }
}
