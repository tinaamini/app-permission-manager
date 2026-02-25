import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/logic/special_permission/pecial_permission_state.dart';
import 'package:permissions_app/logic/special_permission/special_risk_calculator.dart';


class SpecialPermissionCubit
    extends Cubit<SpecialPermissionState> {
  final AppSpecialPermissionPlatform platform;

  SpecialPermissionCubit(this.platform)
      : super(SpecialPermissionState.initial());

  Future<void> loadStatus() async {
    emit(state.copyWith(loading: true));

    final usage = await platform.checkUsageAccess();
    final notification =
    await platform.checkNotificationAccess();
    final overlay =
    await platform.checkOverlayPermission();
    final battery =
    await platform.isIgnoringBatteryOptimizations();
    final dnd =
    await platform.isDoNotDisturbEnabled();

    final score = SpecialRiskCalculator.calculate(
      usageAccess: usage,
      notificationAccess: notification,
      overlay: overlay,
      batteryOptimization: battery,
      doNotDisturb: dnd,
    );

    final percent =
    SpecialRiskCalculator.percent(score);

    emit(
      state.copyWith(
        usageAccess: usage,
        notificationAccess: notification,
        overlay: overlay,
        batteryOptimization: battery,
        doNotDisturb: dnd,
        riskPercent: percent,
        loading: false,
      ),
    );
  }

  Future<void> refresh() async {
    await loadStatus();
  }
}
