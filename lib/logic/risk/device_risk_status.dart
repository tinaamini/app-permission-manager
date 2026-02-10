import 'dart:ui';

enum DeviceRiskLevel { safe, low, warning, danger }

class DeviceRiskStatus {
  final DeviceRiskLevel level;
  final String title;
  final String subtitle;
  final String svgAsset;
  final Color color;

  const DeviceRiskStatus({
    required this.level,
    required this.title,
    required this.subtitle,
    required this.svgAsset,
    required this.color,
  });
}
