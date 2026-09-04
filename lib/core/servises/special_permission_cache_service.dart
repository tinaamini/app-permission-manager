import 'package:Privio/constant/specialPermissionType.dart';
import 'package:Privio/core/servises/app_special_permiision_service.dart';
import 'package:Privio/core/servises/special_permission_storage_hive.dart';
import 'package:Privio/logic/special_permission/special_risk_calculator.dart';

/// لایه کش برای status + لیست اپ‌های Special Permission
class SpecialPermissionCacheService {
  SpecialPermissionCacheService._();

  static final AppSpecialPermissionPlatform _platform =
      AppSpecialPermissionPlatform();

  static bool _refreshingStatus = false;
  static final Set<SpecialPermissionType> _refreshingApps = {};

  // ---------- Apps ----------

  static Future<List<Map<String, dynamic>>> fetchAppsNative(
    SpecialPermissionType type,
  ) async {
    switch (type) {
      case SpecialPermissionType.usageAccess:
        return _platform.getUsageAccessApps();
      case SpecialPermissionType.notificationAccess:
        return _platform.getNotificationAccessApps();
      case SpecialPermissionType.displayOverApps:
        return _platform.getOverlayApps();
      case SpecialPermissionType.batteryOptimization:
        return _platform.getBatteryOptimizationApps();
      case SpecialPermissionType.doNotDisturb:
        return _platform.getDoNotDisturbApps();
    }
  }

  /// cache-first برای لیست اپ‌های یک type
  static Future<List<Map<String, dynamic>>> loadApps(
    SpecialPermissionType type, {
    bool forceNative = false,
  }) async {
    if (!forceNative) {
      final cached = await SpecialPermissionStorageHive.loadApps(type);
      if (cached != null) {
        // The disk cache stores metadata only. Hydrate icons before returning
        // it on a cold start; otherwise this screen has no state update when
        // the background refresh finishes and keeps showing placeholders.
        final hasIcons = cached.any(
          (app) => (app['icon']?.toString() ?? '').isNotEmpty,
        );
        if (!hasIcons && cached.isNotEmpty) {
          final fresh = await fetchAppsNative(type);
          await SpecialPermissionStorageHive.saveApps(type, fresh);
          return fresh;
        }
        // پس‌زمینه رفرش
        _refreshAppsInBackground(type);
        return cached;
      }
    }

    final fresh = await fetchAppsNative(type);
    await SpecialPermissionStorageHive.saveApps(type, fresh);
    return fresh;
  }

  static Future<void> _refreshAppsInBackground(
    SpecialPermissionType type,
  ) async {
    if (_refreshingApps.contains(type)) return;
    _refreshingApps.add(type);
    try {
      final fresh = await fetchAppsNative(type);
      await SpecialPermissionStorageHive.saveApps(type, fresh);
    } catch (_) {
    } finally {
      _refreshingApps.remove(type);
    }
  }

  /// رفرش اجباری (مثلاً بعد از resume از Settings)
  static Future<List<Map<String, dynamic>>> refreshApps(
    SpecialPermissionType type,
  ) async {
    final fresh = await fetchAppsNative(type);
    await SpecialPermissionStorageHive.saveApps(type, fresh);
    return fresh;
  }

  // ---------- Status + counts ----------

  static Future<Map<String, dynamic>> fetchStatusAndCountsNative() async {
    final results = await Future.wait([
      _platform.checkUsageAccess(),
      _platform.checkNotificationAccess(),
      _platform.checkOverlayPermission(),
      _platform.isIgnoringBatteryOptimizations(),
      _platform.isDoNotDisturbEnabled(),
      _platform.getUsageAccessApps(),
      _platform.getNotificationAccessApps(),
      _platform.getOverlayApps(),
      _platform.getBatteryOptimizationApps(),
      _platform.getDoNotDisturbApps(),
    ]);

    final usage = results[0] as bool;
    final notification = results[1] as bool;
    final overlay = results[2] as bool;
    final battery = results[3] as bool;
    final dnd = results[4] as bool;

    final usageApps = results[5] as List<Map<String, dynamic>>;
    final notifApps = results[6] as List<Map<String, dynamic>>;
    final overlayApps = results[7] as List<Map<String, dynamic>>;
    final batteryApps = results[8] as List<Map<String, dynamic>>;
    final dndApps = results[9] as List<Map<String, dynamic>>;

    await SpecialPermissionStorageHive.saveApps(
        SpecialPermissionType.usageAccess, usageApps);
    await SpecialPermissionStorageHive.saveApps(
        SpecialPermissionType.notificationAccess, notifApps);
    await SpecialPermissionStorageHive.saveApps(
        SpecialPermissionType.displayOverApps, overlayApps);
    await SpecialPermissionStorageHive.saveApps(
        SpecialPermissionType.batteryOptimization, batteryApps);
    await SpecialPermissionStorageHive.saveApps(
        SpecialPermissionType.doNotDisturb, dndApps);

    final score = SpecialRiskCalculator.calculate(
      usageAccess: usage,
      notificationAccess: notification,
      overlay: overlay,
      batteryOptimization: battery,
      doNotDisturb: dnd,
    );
    final percent = SpecialRiskCalculator.percent(score);

    final map = {
      'usageAccess': usage,
      'notificationAccess': notification,
      'overlay': overlay,
      'batteryOptimization': battery,
      'doNotDisturb': dnd,
      'riskPercent': percent,
      'usageCount': usageApps.length,
      'notificationCount': notifApps.length,
      'overlayCount': overlayApps.length,
      'batteryCount': batteryApps.length,
      'dndCount': dndApps.length,
    };

    await SpecialPermissionStorageHive.saveStatus(
      usageAccess: usage,
      notificationAccess: notification,
      overlay: overlay,
      batteryOptimization: battery,
      doNotDisturb: dnd,
      riskPercent: percent,
      usageCount: usageApps.length,
      notificationCount: notifApps.length,
      overlayCount: overlayApps.length,
      batteryCount: batteryApps.length,
      dndCount: dndApps.length,
    );

    return map;
  }

  static Future<Map<String, dynamic>?> loadStatusCached() {
    return SpecialPermissionStorageHive.loadStatus();
  }

  static Future<Map<String, dynamic>> loadStatusCacheFirst({
    void Function(Map<String, dynamic> fresh)? onBackgroundUpdated,
  }) async {
    final cached = await SpecialPermissionStorageHive.loadStatus();
    if (cached != null) {
      if (!_refreshingStatus) {
        _refreshingStatus = true;
        fetchStatusAndCountsNative().then((fresh) {
          onBackgroundUpdated?.call(fresh);
        }).whenComplete(() => _refreshingStatus = false);
      }
      return cached;
    }
    return fetchStatusAndCountsNative();
  }
}
