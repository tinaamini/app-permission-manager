import 'dart:convert';

import 'package:Privio/core/models/app_permission_ui.dart';
import 'package:hive/hive.dart';

class AppPermissionStorageHive {

  static const String _boxName='app_permission_cache_v2';
  static const String _keyCache='apps_cache_json';
  static const String _keyTimestamp='apps_cache_timestamp_ms';
  static List<AppPermissionUi>? _memoryCache;


  static Future<Box>_box()async{
    if (Hive.isBoxOpen(_boxName)) return Hive.box(_boxName);
    return Hive.openBox(_boxName);

  }

  static Future<void> saveApps(List<AppPermissionUi> apps) async {
    final box = await _box();
    final list = apps.map((a) => a.toJson()).toList();
    final jsonStr = jsonEncode(list);
    await box.put(_keyCache, jsonStr);
    await box.put(_keyTimestamp, DateTime.now().millisecondsSinceEpoch);
  }

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