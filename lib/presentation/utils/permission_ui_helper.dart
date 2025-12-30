import 'package:permissions_app/constant/permissionConst.dart';

/// Returns risk percent between 0.0 and 1.0
double calculateRiskPercent(List<String> permissions) {
  if (permissions.isEmpty) return 0.0;

  final dangerousCount = permissions
      .where(PermissionConst.dangerousPermissions.contains)
      .length;

  const maxDangerous = 6;

  final percent = dangerousCount / maxDangerous;

  return percent.clamp(0.0, 1.0);
}
