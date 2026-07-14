import 'package:Privio/constant/permissionConst.dart';

double calculateRiskPercent(List<String> permissions) {
  if (permissions.isEmpty) return 0.0;

  int score = 0;
  for (final p in permissions) {
    if (PermissionConst.sensitive.contains(p)) score += 10;
    if (PermissionConst.dangerous.contains(p)) score += 25;
    if (PermissionConst.special.contains(p)) score += 40;
  }

  const maxScore = 120;

  final percent = score / maxScore;

  return percent.clamp(0.0, 1.0);
}
 