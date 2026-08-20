import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:Privio/core/models/app_permission_ui.dart';

/// کش سبک App Permission:
/// - روی دیسک فقط metadata (بدون آیکون base64)
/// - در memory نسخه کامل (با آیکون) برای همان session
class AppPermissionStorageHive {
  static const String _boxName = 'app_permission_cache_v2';
  static const String _keyCache = 'apps_meta_json';
  static const String _keyTimestamp = 'apps_cache_timestamp_ms';

  /// کش memory برای همان session (با آیکون)
  static List<AppPermissionUi>? _memoryCache;

  static Future<Box> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box(_boxName);
    return Hive.openBox(_boxName);
  }

  /// ذخیره: memory = کامل، Hive = بدون آیکون
  static Future<void> saveApps(List<AppPermissionUi> apps) async {
    _memoryCache = List<AppPermissionUi>.from(apps);

    final box = await _box();
    final meta = apps
        .map((a) => a.copyWith(iconBase64: '').toJson())
        .toList();
    await box.put(_keyCache, jsonEncode(meta));
    await box.put(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

  /// ۱) memory  ۲) Hive (بدون آیکون)
  static Future<List<AppPermissionUi>?> loadApps() async {
    if (_memoryCache != null && _memoryCache!.isNotEmpty) {
      return List<AppPermissionUi>.from(_memoryCache!);
    }

    final box = await _box();
    final jsonStr = box.get(_keyCache);

    if (jsonStr == null || jsonStr is! String || jsonStr.isEmpty) {
      return null;
    }

    try {
      final list = jsonDecode(jsonStr) as List<dynamic>;
      final apps = list
          .map((e) =>
              AppPermissionUi.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      // cold start: بدون آیکون؛ background بعداً پر می‌کند
      _memoryCache = apps;
      return apps;
    } catch (_) {
      return null;
    }
  }

  static List<AppPermissionUi>? get memoryCache => _memoryCache;

  static Future<int?> loadTimestampMs() async {
    final box = await _box();
    final v = box.get(_keyTimestamp);
    if (v is int) return v;
    if (v is num) return v.toInt();
    return null;
  }

  static Future<bool> hasCache() async {
    if (_memoryCache != null && _memoryCache!.isNotEmpty) return true;
    final apps = await loadApps();
    return apps != null && apps.isNotEmpty;
  }

  static Future<void> clear() async {
    _memoryCache = null;
    final box = await _box();
    await box.delete(_keyCache);
    await box.delete(_keyTimestamp);
  }
}
