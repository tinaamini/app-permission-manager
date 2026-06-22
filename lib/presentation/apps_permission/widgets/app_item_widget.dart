import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/constant/permissionConst.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:Privio/presentation/apps_permission/widgets/risk_circle_widget.dart';
import 'package:Privio/presentation/apps_permission/widgets/trusted_badge.dart';
import 'package:Privio/presentation/utils/permission_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'kept_badge.dart';

List<String> getDangerousPermissions(List<String> permissions) {
  return permissions
      .where(PermissionConst.dangerousPermissions.contains)
      .toList();
}

class AppItem extends StatelessWidget {
  final String appName;
  final String packageName;
  final Widget icon;
  final List<String> permissions;
  final RiskLevel riskLevel;

  const AppItem({
    super.key,
    required this.appName,
    required this.packageName,
    required this.icon,
    required this.permissions,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    final dangerousPermissions = getDangerousPermissions(permissions);
    final riskPercent = calculateRiskPercent(permissions);
    final isTrusted = context.select<AppPermissionCubit, bool>(
      (c) => c.isAppTrusted(packageName),
    );

    final isKept = context.select<AppPermissionCubit, bool>(
      (cubit) => cubit.isAppKept(packageName),
    );

    return Container(
      padding: EdgeInsets.all(
        screenWidth * 0.03,
      ),
      decoration: BoxDecoration(
        border: Border.all(
            width: 1,
            color: isDark ? AppColor.CartDarkBorder : AppColor.borderLight),
        color: isDark ? AppColor.CartDark : AppColor.btnLight,
        borderRadius: BorderRadius.circular(
          screenWidth * 0.06,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.0125,
          ),
          SizedBox(
            width: screenWidth * 0.11,
            height: screenWidth * 0.11,
            child: icon,
          ),
          SizedBox(
            width: screenWidth * 0.05,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    appName,
                    style:AppTextStyle.appName(context))
                ),
                if (isTrusted)
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 22.w),
                    child: const TrustedBadge(),
                  )
                else if (isKept)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: const KeptBadge(),
                  ),
              ],
            ),
          ),
          RiskCircle(
            percent: riskPercent,
            riskLevel: riskLevel,
            hasDangerousPermissions: dangerousPermissions.isNotEmpty,
          ),
        ],
      ),
    );
  }
}
