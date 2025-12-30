import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/models/app_permission_ui.dart';

import '../risk/risk_calculator.dart';
import 'app_permission_platform.dart';
import 'app_permission_state.dart';

class AppPermissionCubit extends Cubit<AppPermissionState> {
  final AppPermissionPlatform _platform = AppPermissionPlatform();

  AppPermissionCubit() : super(AppPermissionInitial());

  Future<void> loadApps() async {
    final List<AppPermissionUi> apps =
    await _platform.getInstalledApps();

    final calculated = apps.map((app) {
      final risk = RiskCalculator.calculate(app.permissions);
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
}
