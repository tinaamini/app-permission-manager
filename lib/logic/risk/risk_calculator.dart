import '../../constant/risk_level.dart';
import '../../constant/permissionConst.dart';

class RiskCalculator {
  RiskCalculator._();

  static RiskLevel calculate({
    required List<String> permissions,
    required String packageName,
    required String appName,
  }) {
    int score = 0;

    /* --------------------------------------------------
     * 1️⃣ Base risk (قدرت ذاتی permission)
     * -------------------------------------------------- */
    for (final p in permissions) {
      if (PermissionConst.sensitive.contains(p)) score += 10;
      if (PermissionConst.dangerous.contains(p)) score += 25;
      if (PermissionConst.special.contains(p)) score += 40;
    }

    /* --------------------------------------------------
     * 2️⃣ Dangerous combinations
     * -------------------------------------------------- */
    if (_hasAll(permissions, {
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
    })) {
      score += 20;
    }

    if (_hasAll(permissions, {
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.INTERNET',
    })) {
      score += 20;
    }

    if (_hasAny(permissions, PermissionConst.callRelated) &&
        permissions.contains('android.permission.INTERNET')) {
      score += 30;
    }

    /* --------------------------------------------------
     * 3️⃣ Context-aware penalties
     * -------------------------------------------------- */
    final category = _inferCategoryFromPermissions(permissions);

    for (final p in permissions) {
      // 📞 Call permissions برای اپ Utility
      if (PermissionConst.callRelated.contains(p) &&
          category == AppCategory.utility) {
        score += 80;
      }

      // ✉️ SMS خارج از Messaging
      if (PermissionConst.smsRelated.contains(p) &&
          category != AppCategory.messaging) {
        score += 70;
      }

      // 🎤 Microphone برای Utility
      if (p == 'android.permission.RECORD_AUDIO' &&
          category == AppCategory.utility) {
        score += 40;
      }

      // 📍 Location بدون Internet برای Utility
      if (PermissionConst.locationRelated.contains(p) &&
          category == AppCategory.utility &&
          !permissions.contains('android.permission.INTERNET')) {
        score += 30;
      }
    }

    /* --------------------------------------------------
     * 4️⃣ Final mapping
     * -------------------------------------------------- */
    if (score == 0) return RiskLevel.noRisk;
    if (score <= 40) return RiskLevel.lowRisk;
    if (score <= 100) return RiskLevel.mediumRisk;
    return RiskLevel.highRisk;
  }

  /* --------------------------------------------------
   * Helpers
   * -------------------------------------------------- */
  static bool _hasAll(List<String> list, Set<String> targets) =>
      targets.every(list.contains);

  static bool _hasAny(List<String> list, Set<String> targets) =>
      list.any(targets.contains);

  static AppCategory _inferCategoryFromPermissions(
      List<String> permissions) {
    final hasCamera = permissions.contains('android.permission.CAMERA');
    final hasMic = permissions.contains('android.permission.RECORD_AUDIO');
    final hasInternet = permissions.contains('android.permission.INTERNET');

    final hasCall =
    PermissionConst.callRelated.any(permissions.contains);
    final hasSms =
    PermissionConst.smsRelated.any(permissions.contains);

    if (hasCall || hasSms) {
      return AppCategory.telephony;
    }

    if (hasCamera && hasMic && hasInternet) {
      return AppCategory.messaging;
    }

    if (hasInternet && permissions.length <= 3) {
      return AppCategory.network;
    }


    return AppCategory.utility;
  }
}

enum AppCategory {
  messaging,
  telephony,
  network,
  utility,
}
