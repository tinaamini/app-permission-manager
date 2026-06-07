import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:permissions_app/generated/app_localizations.dart';

import 'device_risk_status.dart';

class DeviceRiskResolver {
  const DeviceRiskResolver();

  DeviceRiskStatus resolve(BuildContext context,{
    required int high,
    required int medium,
    required int low,
  }) {
    final l10n = AppLocalizations.of(context)!;

    if (high > 0) {
      return  DeviceRiskStatus(
        level: DeviceRiskLevel.danger,
        title:l10n.deviceRiskStatusTitleDanger ,
        subtitle: l10n.highRisk,
        svgAsset: 'assets/main/danger_alert.svg',
        color: Color(0xFFF24A4D),
      );
    }

    if (medium > 0) {
      return  DeviceRiskStatus(
        level: DeviceRiskLevel.warning,
        title: l10n.attentionNeeded,
        subtitle: l10n.attentionNeededSubtitle,
        svgAsset: 'assets/main/warning_alert.svg',
        color: Color(0xFFF2B24A),
      );
    }

    if (low > 0) {
      return  DeviceRiskStatus(
        level: DeviceRiskLevel.low,
        title: l10n.mostlyProtected,
        subtitle: l10n.minorRisksDetected,
        svgAsset: 'assets/main/low.svg',
        color: Color(0xFF4AF296),
      );
    }

    return  DeviceRiskStatus(
      level: DeviceRiskLevel.safe,
      title: l10n.allGood,
      subtitle: l10n.yourPrivacyLooksStrong,
      svgAsset: 'assets/main/safe_alert.svg',
      color: Color(0xFF4A82F2),
    );
  }
}