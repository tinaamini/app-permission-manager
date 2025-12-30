import 'package:permissions_app/constant/risk_level.dart';

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
}
