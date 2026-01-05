import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/permissionConst.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/risk_circle_widget.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/trusted_badge.dart';
import 'package:permissions_app/presentation/utils/permission_ui_helper.dart';

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
    final dangerousPermissions = getDangerousPermissions(permissions);
    final riskPercent = calculateRiskPercent(permissions);
    final isTrusted = context.select<AppPermissionCubit, bool>(
          (c) => c.isAppTrusted(packageName),
    );

    final isKept = context.select<AppPermissionCubit, bool>(
          (cubit) => cubit.isAppKept(packageName),
    );

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.CartDark,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 44.w, height: 44.w, child: icon),
          SizedBox(width: 12.w),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isTrusted)
                  const TrustedBadge()
                else if (isKept)
                  const KeptBadge(),
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
