import 'special_permission_risk.dart';

class SpecialRiskCalculator {
  static int calculate({
    required bool usageAccess,
    required bool notificationAccess,
    required bool overlay,
    required bool batteryOptimization,
    required bool doNotDisturb,
  }) {
    int score = 0;

    if (usageAccess) {
      score += SpecialPermissionRisk.usageAccess;
    }
    if (notificationAccess) {
      score += SpecialPermissionRisk.notificationAccess;
    }
    if (overlay) {
      score += SpecialPermissionRisk.overlay;
    }
    if (batteryOptimization) {
      score += SpecialPermissionRisk.batteryOptimization;
    }
    if (doNotDisturb) {
      score += SpecialPermissionRisk.doNotDisturb;
    }

    return score;
  }

  static int percent(int score) {
    return ((score / SpecialPermissionRisk.maxScore) * 100).round();
  }
}
