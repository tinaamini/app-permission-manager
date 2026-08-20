import 'package:Privio/constant/risk_level.dart';

class AppPermissionUi {
  final String appName;
  final String packageName;
  final String iconBase64;
  final List<String> permissions;
  final RiskLevel riskLevel;

  AppPermissionUi({
    required this.appName,
    required this.packageName,
    required this.iconBase64,
    required this.permissions,
    required this.riskLevel,
  });

  AppPermissionUi copyWith({
    String? appName,
    String? packageName,
    String? iconBase64,
    List<String>? permissions,
    RiskLevel? riskLevel,
  }) {
    return AppPermissionUi(
      appName: appName ?? this.appName,
      packageName: packageName ?? this.packageName,
      iconBase64: iconBase64 ?? this.iconBase64,
      permissions: permissions ?? this.permissions,
      riskLevel: riskLevel ?? this.riskLevel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appName': appName,
      'packageName': packageName,
      'iconBase64': iconBase64,
      'permissions': permissions,
      'riskLevel': riskLevel.name,
    };
  }

  static AppPermissionUi fromJson(Map<String, dynamic> json) {
    return AppPermissionUi(
      appName: (json['appName'] ?? '').toString(),
      packageName: (json['packageName'] ?? '').toString(),
      iconBase64: (json['iconBase64'] ?? '').toString(),
      permissions: ((json['permissions'] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(),
      riskLevel: _riskFromName(json['riskLevel']?.toString()),
    );
  }

  static RiskLevel _riskFromName(String? name) {
    switch (name) {
      case 'lowRisk':
        return RiskLevel.lowRisk;
      case 'mediumRisk':
        return RiskLevel.mediumRisk;
      case 'highRisk':
        return RiskLevel.highRisk;
      case 'noRisk':
      default:
        return RiskLevel.noRisk;
    }
  }
}
