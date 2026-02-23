import 'dart:ui';
import 'device_risk_status.dart';

class DeviceRiskResolver {
  const DeviceRiskResolver();

  DeviceRiskStatus resolve({
    required int high,
    required int medium,
    required int low,
  }) {
    if (high > 0) {
      return const DeviceRiskStatus(
        level: DeviceRiskLevel.danger,
        title: 'Device is not safe ',
        subtitle: 'System Critical',
        svgAsset: 'assets/main/danger_alert.svg',
        color: Color(0xFFF24A4D),
      );
    }

    if (medium > 0) {
      return const DeviceRiskStatus(
        level: DeviceRiskLevel.warning,
        title: 'Device alert',
        subtitle: 'System Warning',
        svgAsset: 'assets/main/warning_alert.svg',
        color: Color(0xFFF2B24A),
      );
    }

    if (low > 0) {
      return const DeviceRiskStatus(
        level: DeviceRiskLevel.low,
        title: 'Mostly secure',
        subtitle: 'System Risky',
        svgAsset: 'assets/main/low.svg',
        color: Color(0xFF4AF296),
      );
    }

    return const DeviceRiskStatus(
      level: DeviceRiskLevel.safe,
      title: 'Device is safe',
      subtitle: 'System Secure',
      svgAsset: 'assets/main/safe_alert.svg',
      color: Color(0xFF4A82F2),
    );
  }
}
