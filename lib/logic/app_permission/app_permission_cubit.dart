import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/core/models/app_permission_ui.dart';
import 'package:Privio/core/models/scan_model.dart';
import 'package:Privio/core/servises/scan_storage_hive.dart';
import 'package:Privio/core/utils/scan_diff.dart';
import 'package:Privio/logic/utils/scan/scan_cubit.dart';
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
  final ScanCubit _scanCubit;

  Future<void>? _activeFetch;

  AppPermissionCubit(this._scanCubit) : super(AppPermissionInitial());

  Future<void> runInitialScan() async {
    if (_scanCubit.state.isScanning) return;

    _scanCubit.startScan();
    await refreshAll();

    // A successful fetch reports a snapshot and changes ScanCubit to loaded.
    // Remaining in loading means the native fetch failed before that point.
    _scanCubit.resetInitialScan();
  }

  /// هر بار که یه فچ واقعی و موفق از native انجام میشه (چه اولین بار،
  /// چه رفرش پس‌زمینه)، همون داده رو به‌عنوان یه «اسکن» هم ثبت می‌کنیم:
  /// snapshot رو می‌سازیم، diff رو نسبت به اسکن قبلی حساب می‌کنیم، تو
  /// Hive ذخیره می‌کنیم و state مربوط به ScanCubit رو آپدیت می‌کنیم.
  /// اینجوری دیگه نیازی نیست ScanService.takeSnapshot() جدا و دوباره
  /// همون permission_channel رو صدا بزنه، و کاربری که هیچ‌وقت دستی دکمه‌ی
  /// اسکن رو نزده هم دیگه پشت overlay «برو اسکن کن» گیر نمی‌مونه.
  Future<void> _reportAsScan(List<AppPermissionUi> apps) async {
    try {
      final map = <String, AppPermSnapshot>{
        for (final a in apps)
          a.packageName: AppPermSnapshot(
            packageName: a.packageName,
            name: a.appName,
            iconBase64: a.iconBase64,
            grantedPerms: a.permissions.toSet(),
          ),
      };

      final curr = ScanSnapshot(
        timestampMs: DateTime.now().millisecondsSinceEpoch,
        appsByPackage: map,
      );

      final prev = await ScanStorageHive.loadLastSnapshot();
      final diff = prev == null ? null : diffSnapshots(prev, curr);

      await ScanStorageHive.saveLastSnapshot(curr);
      if (diff != null) await ScanStorageHive.saveLastDiff(diff);

      _scanCubit.markScanned(
        time: DateTime.fromMillisecondsSinceEpoch(curr.timestampMs),
        diff: diff,
      );
    } catch (e) {
      debugPrint('AppPermissionCubit._reportAsScan failed: $e');
    }
  }


  Future<void> loadApps() async {
    debugPrint(
      '[SHORTCUT_TRACE] cubit:loadApps start state=${state.runtimeType} '
      'activeFetch=${_activeFetch != null}',
    );
    if (state is AppPermissionLoading) {
      await _activeFetch;
      return;
    }

    final cached = await AppPermissionStorageHive.loadApps();
    debugPrint(
      '[SHORTCUT_TRACE] cubit:cache loaded count=${cached?.length ?? 0} '
      'usable=${_isUsableSnapshot(cached)}',
    );

    if (_isUsableSnapshot(cached)) {
      _emitGrouped(cached!);
      debugPrint('[SHORTCUT_TRACE] cubit:emitted cache, refreshing background');

      _refreshInBackground();
      return;
    }

    emit(AppPermissionLoading());
    debugPrint('[SHORTCUT_TRACE] cubit:no usable cache, fetching native');
    await _runSingleFlight(
      () => _fetchFromNativeAndSave(retriesLeft: 1),
    );
  }

  Future<void> refreshAll() async {
    if (state is AppPermissionLoading) {
      await _activeFetch;
      return;
    }

    if (state is AppPermissionLoaded) {
      await _refreshInBackground(force: true);
      return;
    }

    emit(AppPermissionLoading());
    await _runSingleFlight(
      () => _fetchFromNativeAndSave(retriesLeft: 1),
    );
  }

  Future<void> _runSingleFlight(Future<void> Function() operation) async {
    final active = _activeFetch;
    if (active != null) {
      debugPrint('[SHORTCUT_TRACE] cubit:singleFlight waiting active fetch');
      await active;
      return;
    }

    final future = operation();
    _activeFetch = future;
    try {
      await future;
    } finally {
      if (identical(_activeFetch, future)) {
        _activeFetch = null;
      }
    }
  }


  Future<void> _fetchFromNativeAndSave({required int retriesLeft}) async {
    try {
      final trusted = trustedApps;
      final apps = await _platform.getInstalledApps();
      debugPrint(
        '[SHORTCUT_TRACE] cubit:native initial result count=${apps.length} '
        'withPermissions=${apps.where((a) => a.permissions.isNotEmpty).length}',
      );
      final cached = await AppPermissionStorageHive.loadApps();
      _validateNativeSnapshot(apps);

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

      final all = [...highRisk, ...mediumRisk, ...lowRisk, ...noRisk];
      await AppPermissionStorageHive.saveApps(all);
      await _reportAsScan(all);

      emit(AppPermissionLoaded(
        noRisk: noRisk,
        lowRisk: lowRisk,
        mediumRisk: mediumRisk,
        highRisk: highRisk,
      ));
      debugPrint(
        '[SHORTCUT_TRACE] cubit:initial emitted '
        'high=${highRisk.length} medium=${mediumRisk.length} '
        'low=${lowRisk.length} safe=${noRisk.length}',
      );
    } catch (e, st) {
      debugPrint('[SHORTCUT_TRACE] cubit:initial failed error=$e');
      debugPrint('AppPermissionCubit._fetchFromNativeAndSave: $e\n$st');

      if (retriesLeft > 0) {
        await Future.delayed(const Duration(milliseconds: 400));
        return _fetchFromNativeAndSave(retriesLeft: retriesLeft - 1);
      }

      emit(AppPermissionError(e.toString()));
      final cached = await AppPermissionStorageHive.loadApps();
      if (_isUsableSnapshot(cached)) {
        _emitGrouped(cached!);
      }
    }
  }

  Future<void> _refreshInBackground({bool force = false}) async {
    await _runSingleFlight(() => _performBackgroundRefresh(force: force));
  }

  Future<void> _performBackgroundRefresh({required bool force}) async {
    try {
      final trusted = trustedApps;
      final apps = await _platform.getInstalledApps();
      debugPrint(
        '[SHORTCUT_TRACE] cubit:native background result count=${apps.length} '
        'withPermissions=${apps.where((a) => a.permissions.isNotEmpty).length}',
      );
      final cached = await AppPermissionStorageHive.loadApps();
      _validateNativeSnapshot(apps);

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

      final changed = force || _hasMeaningfulChange(cached, freshAll);
      debugPrint(
        '[SHORTCUT_TRACE] cubit:background grouped changed=$changed force=$force '
        'high=${highRisk.length} medium=${mediumRisk.length} '
        'low=${lowRisk.length} safe=${noRisk.length}',
      );

      if (changed) {
        await AppPermissionStorageHive.saveApps(freshAll);
        await _reportAsScan(freshAll);
        // فقط اگر هنوز در همین بخش هستیم state را آپدیت کن
        if (!isClosed) {
          emit(AppPermissionLoaded(
            noRisk: noRisk,
            lowRisk: lowRisk,
            mediumRisk: mediumRisk,
            highRisk: highRisk,
          ));
          debugPrint('[SHORTCUT_TRACE] cubit:background emitted loaded state');
        }
      }
    } catch (e) {
      debugPrint('AppPermissionCubit._refreshInBackground failed: $e');
    }
  }

  bool _hasMeaningfulChange(
      List<AppPermissionUi>? cached,
      List<AppPermissionUi> fresh,
      ) {
    if (cached == null) return true;
    if (cached.length != fresh.length) return true;

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

  void _validateNativeSnapshot(List<AppPermissionUi> fresh) {
    if (fresh.isEmpty) {
      throw StateError('Native app scan returned an empty list');
    }

    // On a few devices PackageManager can transiently return the installed
    // apps while reporting no granted permissions for any of them. Accepting
    // that partial snapshot would classify every app as safe and overwrite a
    // healthy cache. Keep the last good snapshot and retry on the next scan.
    final freshHasPermissions = fresh.any((app) => app.permissions.isNotEmpty);
    if (!freshHasPermissions) {
      throw StateError('Native app scan returned no permission data');
    }
  }

  bool _isUsableSnapshot(List<AppPermissionUi>? apps) {
    return apps != null &&
        apps.isNotEmpty &&
        apps.any((app) => app.permissions.isNotEmpty);
  }

  void _emitGrouped(List<AppPermissionUi> apps) {
    final noRisk = <AppPermissionUi>[];
    final lowRisk = <AppPermissionUi>[];
    final mediumRisk = <AppPermissionUi>[];
    final highRisk = <AppPermissionUi>[];

    final trusted = trustedApps.toSet();
    for (final app in apps) {
      final riskLevel = trusted.contains(app.packageName)
          ? RiskLevel.noRisk
          : RiskCalculator.calculate(
              permissions: app.permissions,
              packageName: app.packageName,
              appName: app.appName,
            );
      final updated = app.copyWith(riskLevel: riskLevel);

      switch (riskLevel) {
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

    emit(AppPermissionLoaded(
      noRisk: noRisk,
      lowRisk: lowRisk,
      mediumRisk: mediumRisk,
      highRisk: highRisk,
    ));
  }


  Future<void> refreshApp(String packageName) async {
    await _runSingleFlight(() => _refreshAppInternal(packageName));
  }

  Future<void> _refreshAppInternal(String packageName) async {
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
