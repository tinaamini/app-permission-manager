import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/constant/specialPermissionType.dart';

class SpecialPermissionRiskResolver {
  const SpecialPermissionRiskResolver();

  static RiskLevel fromCount({
    required SpecialPermissionType type,
    required int count,
  }) {
    if (count == 0) return RiskLevel.noRisk;

    switch (type) {
      case SpecialPermissionType.notificationAccess:
      case SpecialPermissionType.usageAccess:
        if (count <= 2) return RiskLevel.mediumRisk;
        return RiskLevel.highRisk;

      default:
        return RiskLevel.mediumRisk;
    }
  }

  static RiskLevel fromEnabled({
    required SpecialPermissionType type,
    required bool enabled,
  }) {
    if (!enabled) return RiskLevel.noRisk;

    switch (type) {
      case SpecialPermissionType.displayOverApps:
      case SpecialPermissionType.batteryOptimization:
        return RiskLevel.mediumRisk;

      case SpecialPermissionType.doNotDisturb:
        return RiskLevel.lowRisk;

      case SpecialPermissionType.notificationAccess:
      case SpecialPermissionType.usageAccess:
        return RiskLevel.mediumRisk;
    }
  }
}