import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/core/models/app_permission_ui.dart';
import 'package:flutter/foundation.dart';

import '../risk/risk_calculator.dart';
import '../../core/servises/app_permission_service.dart';
import 'app_permission_state.dart';
Map<String, List<AppPermissionUi>> processAppsInIsolate(
    Map<String, dynamic> input,
    ) {
  final List<AppPermissionUi> apps =
  input['apps'] as List<AppPermissionUi>;
  final Set<String> trusted =
  (input['trusted'] as List<String>).toSet();

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
    trusted.contains(app.packageName)
        ? RiskLevel.noRisk
        : risk;

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

  AppPermissionCubit() : super(AppPermissionInitial());


  Future<void> loadApps() async {
    if (state is AppPermissionLoading) return;

    emit(AppPermissionLoading());
    await _loadAppsInternal(retriesLeft: 1);
  }

  // این متد جداست تا guard بالا (state is AppPermissionLoading) مانع retry نشه
  Future<void> _loadAppsInternal({required int retriesLeft}) async {
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

      emit(AppPermissionLoaded(
        noRisk: result['noRisk']!,
        lowRisk: result['lowRisk']!,
        mediumRisk: result['mediumRisk']!,
        highRisk: result['highRisk']!,
      ));
    } catch (e, st) {
      // قبلاً این خطا هیچ‌جا catch نمی‌شد و state برای همیشه روی
      // AppPermissionLoading می‌موند؛ یعنی هر صفحه‌ای که وابسته به این
      // cubit بود (خانه، لیست اپ‌ها، جزئیات اپ، keep/trusted و ...) تا
      // ابد اسپینر لودینگ نشون می‌داد. الان: یک بار دیگه امتحان می‌کنیم
      // (شاید خطا موقتی بوده)، و اگه بازم شکست خورد، به‌جای گیر کردن،
      // یک حالت خالی emit می‌شه تا UI آزاد بشه.
      debugPrint('AppPermissionCubit.loadApps failed: $e\n$st');

      if (retriesLeft > 0) {
        await Future.delayed(const Duration(milliseconds: 400));
        return _loadAppsInternal(retriesLeft: retriesLeft - 1);
      }

      emit(AppPermissionError(e.toString()));
      emit(AppPermissionLoaded(
        noRisk: const [],
        lowRisk: const [],
        mediumRisk: const [],
        highRisk: const [],
      ));
    }
  }

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
      List<AppPermissionUi> mediumRisk =
      current.mediumRisk.where((a) => a.packageName != packageName).toList();
      List<AppPermissionUi> highRisk =
      current.highRisk.where((a) => a.packageName != packageName).toList();

      switch (newRisk) {
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

      emit(AppPermissionLoaded(
        noRisk: noRisk,
        lowRisk: lowRisk,
        mediumRisk: mediumRisk,
        highRisk: highRisk,
      ));
    } catch (e) {
      // قبلاً بدون try-catch بود: اگه اپ پیدا نمی‌شد یا native خطا می‌داد،
      // exception از کل متد بیرون می‌زد. الان فقط لاگ می‌شه و state قبلی
      // (که همچنان معتبره) دست‌نخورده باقی می‌مونه.
      debugPrint('AppPermissionCubit.refreshApp failed: $e');
    }
  }

  List<String> _readKeepApps() {
    final raw = _prefBox.get('keep_apps');

    if (raw == null) return [];

    if (raw is List) {
      return raw.map((e) => e.toString()).toList();
    }

    if (raw is Set) {
      return raw.map((e) => e.toString()).toList();
    }

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
    if (raw is Set) return raw.map((e) => e.toString()).toList(); // migrate
    return [];
  }

  bool isAppTrusted(String packageName) {
    return _readList('trusted_apps').contains(packageName);
  }

  void trustApp(String packageName) {
    final trusted = _readList('trusted_apps');
    if (trusted.contains(packageName)) return;

    final prev = state is AppPermissionLoaded ? state as AppPermissionLoaded : null;
    if (prev != null) {
      emit(AppTrusting(packageName: packageName, previous: prev));
    }

    final updatedTrusted = {...trusted}..add(packageName);
    _prefBox.put('trusted_apps', updatedTrusted.toList());

    final kept = _readList('keep_apps');
    if (kept.contains(packageName)) {
      final updatedKept = {...kept}..remove(packageName);
      _prefBox.put('keep_apps', updatedKept.toList());
    }

    emit(AppTrustedSuccess(packageName));

    if (prev != null) {
      emit(prev);
    }

    loadApps();
  }
  void untrustApp(String packageName) {
    final trusted = _readList('trusted_apps');
    if (!trusted.contains(packageName)) return;

    final prev = state is AppPermissionLoaded ? state as AppPermissionLoaded : null;
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

  Future<void> refreshAll() async {
    await loadApps();
  }


}