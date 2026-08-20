import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/core/models/app_permission_ui.dart';
import 'package:flutter/foundation.dart';

import '../risk/risk_calculator.dart';
import '../../core/servises/app_permission_service.dart';
import '../../core/servises/app_permission_storage_hive.dart';
import 'app_permission_state.dart';

Map<String, List<AppPermissionUi>> processAppsInIsolate(
  Map<String, dynamic> input,
) {
  final List<AppPermissionUi> apps = input['apps'] as List<AppPermissionUi>;
  final Set<String> trusted = (input['trusted'] as List<String>).toSet();

  final List<AppPermissionUi> noRisk = [];
  final List<AppPermissionUi> lowRisk = [];
  final List<AppPermissionUi> mediumRisk = [];
  final List<AppPermissionUi> highRisk = [];

  for (final app in apps) {
    final risk = RiskCalculator.calculate(
      permissions: app.permissions,
      packageName: app.packageName,
      appName: app.appName,
    );

    final finalRisk =
        trusted.contains(app.packageName) ? RiskLevel.noRisk : risk;

    final updated = app.copyWith(riskLevel: finalRisk);

    switch (finalRisk) {
      case RiskLevel.noRisk:
        noRisk.add(updated);
        break;
      case RiskLevel.lowRisk:
        lowRisk.add(updated);
        break;
      case RiskLevel.mediumRisk:
        mediumRisk.add(updated);
        break;
      case RiskLevel.highRisk:
        highRisk.add(updated);
        break;
    }
  }

  return {
    'noRisk': noRisk,
    'lowRisk': lowRisk,
    'mediumRisk': mediumRisk,
    'highRisk': highRisk,
  };
}

class AppPermissionCubit extends Cubit<AppPermissionState> {
  final AppPermissionPlatform _platform = AppPermissionPlatform();
  final Box _prefBox = Hive.box('app_preferences');

  /// جلوگیری از چندبار اجرای همزمان refresh پس‌زمینه
  bool _isBackgroundRefreshing = false;

  AppPermissionCubit() : super(AppPermissionInitial());

  // ---------------------------------------------------------------------------
  // بارگذاری اصلی: کش‌اول + رفرش پس‌زمینه
  // ---------------------------------------------------------------------------

  /// اولین ورود → از native می‌خواند و در Hive ذخیره می‌کند (با لودینگ).
  /// دفعات بعد → فوری از Hive نشان می‌دهد، بعد در پس‌زمینه چک می‌کند
  /// و اگر تغییری بود دیتابیس و UI را آپدیت می‌کند (بدون لودینگ کامل).
  Future<void> loadApps() async {
    if (state is AppPermissionLoading) return;

    // ۱) سعی کن از کش بخوانی
    final cached = await AppPermissionStorageHive.loadApps();

    if (cached != null && cached.isNotEmpty) {
      // فوری UI را با داده کش پر کن → کاربر لودینگ نمی‌بیند
      _emitGrouped(cached);

      // در پس‌زمینه از native بخوان و در صورت تغییر آپدیت کن
      _refreshInBackground();
      return;
    }

    // ۲) کش خالی است (اولین بار) → لودینگ + خواندن از native
    emit(AppPermissionLoading());
    await _fetchFromNativeAndSave(retriesLeft: 1);
  }

  /// رفرش اجباری (مثلاً دکمه refresh) — همیشه از native
  Future<void> refreshAll() async {
    if (state is AppPermissionLoading) return;

    // اگر قبلاً داده داریم، لودینگ کامل نشان نده؛ فقط پس‌زمینه
    if (state is AppPermissionLoaded) {
      await _refreshInBackground(force: true);
      return;
    }

    emit(AppPermissionLoading());
    await _fetchFromNativeAndSave(retriesLeft: 1);
  }

  // ---------------------------------------------------------------------------
  // داخلی
  // ---------------------------------------------------------------------------

  Future<void> _fetchFromNativeAndSave({required int retriesLeft}) async {
    try {
      final trusted = trustedApps;
      final apps = await _platform.getInstalledApps();

      final result = await compute(
        processAppsInIsolate,
        {
          'apps': apps,
          'trusted': trusted,
        },
      );

      final noRisk = result['noRisk']!;
      final lowRisk = result['lowRisk']!;
      final mediumRisk = result['mediumRisk']!;
      final highRisk = result['highRisk']!;

      // ذخیره در Hive
      final all = [...highRisk, ...mediumRisk, ...lowRisk, ...noRisk];
      await AppPermissionStorageHive.saveApps(all);

      emit(AppPermissionLoaded(
        noRisk: noRisk,
        lowRisk: lowRisk,
        mediumRisk: mediumRisk,
        highRisk: highRisk,
      ));
    } catch (e, st) {
      debugPrint('AppPermissionCubit._fetchFromNativeAndSave: $e\n$st');

      if (retriesLeft > 0) {
        await Future.delayed(const Duration(milliseconds: 400));
        return _fetchFromNativeAndSave(retriesLeft: retriesLeft - 1);
      }

      emit(AppPermissionError(e.toString()));
      // اگر کش قدیمی داشتیم همان را نگه می‌داریم؛ وگرنه لیست خالی
      final cached = await AppPermissionStorageHive.loadApps();
      if (cached != null && cached.isNotEmpty) {
        _emitGrouped(cached);
      } else {
        emit(AppPermissionLoaded(
          noRisk: const [],
          lowRisk: const [],
          mediumRisk: const [],
          highRisk: const [],
        ));
      }
    }
  }

  /// خواندن از native در پس‌زمینه و آپدیت کش/UI فقط در صورت تغییر
  Future<void> _refreshInBackground({bool force = false}) async {
    if (_isBackgroundRefreshing && !force) return;
    _isBackgroundRefreshing = true;

    try {
      final trusted = trustedApps;
      final apps = await _platform.getInstalledApps();

      final result = await compute(
        processAppsInIsolate,
        {
          'apps': apps,
          'trusted': trusted,
        },
      );

      final noRisk = result['noRisk']!;
      final lowRisk = result['lowRisk']!;
      final mediumRisk = result['mediumRisk']!;
      final highRisk = result['highRisk']!;
      final freshAll = [...highRisk, ...mediumRisk, ...lowRisk, ...noRisk];

      final cached = await AppPermissionStorageHive.loadApps();
      final changed = force || _hasMeaningfulChange(cached, freshAll);

      if (changed) {
        await AppPermissionStorageHive.saveApps(freshAll);
        // فقط اگر هنوز در همین بخش هستیم state را آپدیت کن
        if (!isClosed) {
          emit(AppPermissionLoaded(
            noRisk: noRisk,
            lowRisk: lowRisk,
            mediumRisk: mediumRisk,
            highRisk: highRisk,
          ));
        }
      }
    } catch (e) {
      debugPrint('AppPermissionCubit._refreshInBackground failed: $e');
      // خطا در پس‌زمینه → state قبلی دست‌نخورده می‌ماند
    } finally {
      _isBackgroundRefreshing = false;
    }
  }

  /// مقایسه: اپ جدید/حذف، permission، risk، یا پر شدن آیکون بعد از cold start
  bool _hasMeaningfulChange(
    List<AppPermissionUi>? cached,
    List<AppPermissionUi> fresh,
  ) {
    if (cached == null) return true;
    if (cached.length != fresh.length) return true;

    // cold start از Hive بدون آیکون بود → باید با داده native (با آیکون) جایگزین شود
    final cacheMissingIcons = cached.any((a) => a.iconBase64.isEmpty);
    final freshHasIcons = fresh.any((a) => a.iconBase64.isNotEmpty);
    if (cacheMissingIcons && freshHasIcons) return true;

    final cachedMap = {
      for (final a in cached) a.packageName: a,
    };

    for (final a in fresh) {
      final old = cachedMap[a.packageName];
      if (old == null) return true;

      final oldPerms = old.permissions.toSet();
      final newPerms = a.permissions.toSet();
      if (oldPerms.length != newPerms.length ||
          !oldPerms.containsAll(newPerms)) {
        return true;
      }

      if (old.riskLevel != a.riskLevel) return true;
    }

    final freshPkgs = fresh.map((a) => a.packageName).toSet();
    for (final a in cached) {
      if (!freshPkgs.contains(a.packageName)) return true;
    }

    return false;
  }

  void _emitGrouped(List<AppPermissionUi> apps) {
    final noRisk = <AppPermissionUi>[];
    final lowRisk = <AppPermissionUi>[];
    final mediumRisk = <AppPermissionUi>[];
    final highRisk = <AppPermissionUi>[];

    for (final app in apps) {
      switch (app.riskLevel) {
        case RiskLevel.noRisk:
          noRisk.add(app);
          break;
        case RiskLevel.lowRisk:
          lowRisk.add(app);
          break;
        case RiskLevel.mediumRisk:
          mediumRisk.add(app);
          break;
        case RiskLevel.highRisk:
          highRisk.add(app);
          break;
      }
    }

    emit(AppPermissionLoaded(
      noRisk: noRisk,
      lowRisk: lowRisk,
      mediumRisk: mediumRisk,
      highRisk: highRisk,
    ));
  }

  // ---------------------------------------------------------------------------
  // refresh تک‌اپ (بعد از برگشت از تنظیمات)
  // ---------------------------------------------------------------------------

  Future<void> refreshApp(String packageName) async {
    if (state is! AppPermissionLoaded) return;

    final current = state as AppPermissionLoaded;

    try {
      final freshApps = await _platform.getInstalledApps();

      final updatedApp = freshApps.firstWhere(
        (a) => a.packageName == packageName,
        orElse: () => throw Exception('App not found'),
      );

      final newRisk = RiskCalculator.calculate(
        permissions: updatedApp.permissions,
        packageName: updatedApp.packageName,
        appName: updatedApp.appName,
      );

      final finalRisk = isAppTrusted(updatedApp.packageName)
          ? RiskLevel.noRisk
          : newRisk;

      final newApp = updatedApp.copyWith(riskLevel: finalRisk);

      List<AppPermissionUi> noRisk =
          current.noRisk.where((a) => a.packageName != packageName).toList();
      List<AppPermissionUi> lowRisk =
          current.lowRisk.where((a) => a.packageName != packageName).toList();
      List<AppPermissionUi> mediumRisk = current.mediumRisk
          .where((a) => a.packageName != packageName)
          .toList();
      List<AppPermissionUi> highRisk =
          current.highRisk.where((a) => a.packageName != packageName).toList();

      switch (finalRisk) {
        case RiskLevel.noRisk:
          noRisk.add(newApp);
          break;
        case RiskLevel.lowRisk:
          lowRisk.add(newApp);
          break;
        case RiskLevel.mediumRisk:
          mediumRisk.add(newApp);
          break;
        case RiskLevel.highRisk:
          highRisk.add(newApp);
          break;
      }

      final loaded = AppPermissionLoaded(
        noRisk: noRisk,
        lowRisk: lowRisk,
        mediumRisk: mediumRisk,
        highRisk: highRisk,
      );
      emit(loaded);

      // کش را هم آپدیت کن
      await AppPermissionStorageHive.saveApps(loaded.allApps);
    } catch (e) {
      debugPrint('AppPermissionCubit.refreshApp failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // keep / trust (مثل قبل)
  // ---------------------------------------------------------------------------

  List<String> _readKeepApps() {
    final raw = _prefBox.get('keep_apps');
    if (raw == null) return [];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is Set) return raw.map((e) => e.toString()).toList();
    return [];
  }

  bool isAppKept(String packageName) {
    return _readKeepApps().contains(packageName);
  }

  void keepApp(String packageName) {
    final current = _readKeepApps();
    if (current.contains(packageName)) return;

    final updated = {...current}..add(packageName);
    _prefBox.put('keep_apps', updated.toList());

    if (state is AppPermissionLoaded) {
      final loaded = state as AppPermissionLoaded;
      emit(AppKeptSuccess(packageName));
      emit(loaded);
    }
  }

  void unkeepApp(String packageName) {
    final current = _readKeepApps();
    if (!current.contains(packageName)) return;

    final updated = {...current}..remove(packageName);
    _prefBox.put('keep_apps', updated.toList());

    if (state is AppPermissionLoaded) {
      final loaded = state as AppPermissionLoaded;
      emit(AppUnkeptSuccess(packageName));
      emit(loaded);
    }
  }

  List<String> _readList(String key) {
    final raw = _prefBox.get(key);
    if (raw == null) return [];
    if (raw is List) return raw.map((e) => e.toString()).toList();
    if (raw is Set) return raw.map((e) => e.toString()).toList();
    return [];
  }

  bool isAppTrusted(String packageName) {
    return _readList('trusted_apps').contains(packageName);
  }

  void trustApp(String packageName) {
    final trusted = _readList('trusted_apps');
    if (trusted.contains(packageName)) return;

    final prev =
        state is AppPermissionLoaded ? state as AppPermissionLoaded : null;
    if (prev != null) {
      emit(AppTrusting(packageName: packageName, previous: prev));
    }

    final updatedTrusted = {...trusted}..add(packageName);
    _prefBox.put('trusted_apps', updatedTrusted.toList());

    emit(AppTrustedSuccess(packageName));

    if (prev != null) {
      emit(prev);
    }

    // بعد از trust باید risk دوباره حساب شود → رفرش از native + آپدیت کش
    loadApps();
  }

  void untrustApp(String packageName) {
    final trusted = _readList('trusted_apps');
    if (!trusted.contains(packageName)) return;

    final prev =
        state is AppPermissionLoaded ? state as AppPermissionLoaded : null;
    if (prev != null) {
      emit(AppTrusting(packageName: packageName, previous: prev));
    }

    final updatedTrusted = {...trusted}..remove(packageName);
    _prefBox.put('trusted_apps', updatedTrusted.toList());

    emit(AppUntrustedSuccess(packageName));

    if (prev != null) {
      emit(prev);
    }

    loadApps();
  }

  List<String> get keptApps => _readList('keep_apps');
  List<String> get trustedApps => _readList('trusted_apps');
}
