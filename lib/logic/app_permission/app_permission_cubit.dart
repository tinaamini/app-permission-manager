import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/models/app_permission_ui.dart';

import '../risk/risk_calculator.dart';
import 'app_permission_platform.dart';
import 'app_permission_state.dart';

class AppPermissionCubit extends Cubit<AppPermissionState> {
  final AppPermissionPlatform _platform = AppPermissionPlatform();
  final Box _prefBox = Hive.box('app_preferences');

  AppPermissionCubit() : super(AppPermissionInitial());

  Future<void> loadApps() async {
    final List<AppPermissionUi> apps =
    await _platform.getInstalledApps();

    final calculated = apps.map((app) {
      final risk = RiskCalculator.calculate(
        permissions: app.permissions,
        packageName: app.packageName,
        appName: app.appName,);
      return app.copyWith(riskLevel: risk);
    }).toList();

    emit(AppPermissionLoaded(
      noRisk:
      calculated.where((e) => e.riskLevel == RiskLevel.noRisk).toList(),
      lowRisk:
      calculated.where((e) => e.riskLevel == RiskLevel.lowRisk).toList(),
      mediumRisk:
      calculated.where((e) => e.riskLevel == RiskLevel.mediumRisk).toList(),
      highRisk:
      calculated.where((e) => e.riskLevel == RiskLevel.highRisk).toList(),
    ));
  }

  Future<void> refreshApp(String packageName) async {
    if (state is! AppPermissionLoaded) return;

    final current = state as AppPermissionLoaded;

    final freshApps = await _platform.getInstalledApps();

    final updatedApp = freshApps.firstWhere(
          (a) => a.packageName == packageName,
      orElse: () => throw Exception('App not found'),
    );

    final newRisk =
    RiskCalculator.calculate( permissions: updatedApp.permissions,
      packageName: updatedApp.packageName,
      appName: updatedApp.appName,);

    final newApp = updatedApp.copyWith(riskLevel: newRisk);

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
      emit(loaded);}

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
}