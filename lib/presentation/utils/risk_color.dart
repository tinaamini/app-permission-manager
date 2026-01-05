import 'package:flutter/material.dart';
import 'package:permissions_app/constant/risk_level.dart';

Color riskColor(int percent) {
  if (percent >= 70) {
    return const Color(0xFFE53935); // Red (High risk)
  } else if (percent >= 40) {
    return const Color(0xFFFF9800); // Orange (Medium risk)
  } else {
    return const Color(0xFF4CAF50); // Green (Low risk)
  }
}
RiskLevel riskLevelFromPercent(int percent) {
  if (percent >= 70) {
    return RiskLevel.highRisk;
  } else if (percent >= 40) {
    return RiskLevel.mediumRisk;
  } else {
    return RiskLevel.lowRisk;
  }
}
