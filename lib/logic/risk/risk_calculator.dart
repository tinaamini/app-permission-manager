import 'package:permissions_app/constant/permissionConst.dart';

import '../../constant/risk_level.dart';

class RiskCalculator {
  static RiskLevel calculate(List<String> permissions) {
    int score = 0;

    for (final p in permissions) {
      if (PermissionConst.sensitive.contains(p)) score += 10;
      if (PermissionConst.dangerous.contains(p)) score += 25;
      if (PermissionConst.special.contains(p)) score += 40;
    }

    // ترکیب‌های خطرناک
    if (permissions.contains('android.permission.CAMERA') &&
        permissions.contains('android.permission.RECORD_AUDIO')) {
      score += 20;
    }

    if (permissions.contains('android.permission.ACCESS_FINE_LOCATION') &&
        permissions.contains('android.permission.INTERNET')) {
      score += 20;
    }

    if (score == 0) return RiskLevel.noRisk;
    if (score <= 20) return RiskLevel.lowRisk;
    if (score <= 60) return RiskLevel.mediumRisk;
    return RiskLevel.highRisk;
  }
}
