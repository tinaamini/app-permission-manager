import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:permissions_app/core/models/scan_model.dart';

class ScanStorageHive {
  static const String _boxName = 'scan_box_v1';
  static const String _keyLastSnapshot = 'last_snapshot_json';

  static Future<Box> _box() async {
    if (Hive.isBoxOpen(_boxName)) return Hive.box(_boxName);
    return Hive.openBox(_boxName);
  }

  static Future<void> saveLastSnapshot(ScanSnapshot snapshot) async {
    final box = await _box();
    final jsonStr = jsonEncode(snapshot.toJson());
    await box.put(_keyLastSnapshot, jsonStr);
  }

  static Future<ScanSnapshot?> loadLastSnapshot() async {
    final box = await _box();
    final jsonStr = box.get(_keyLastSnapshot);

    if (jsonStr == null || jsonStr is! String || jsonStr.isEmpty) return null;

    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return ScanSnapshot.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clear() async {
    final box = await _box();
    await box.delete(_keyLastSnapshot);
  }
}
