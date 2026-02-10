import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/permissionConst.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/presentation/utils/permission_ui_helper.dart';


List<String> getDangerousPermissions(List<String> permissions) {
  return permissions
      .where(PermissionConst.dangerousPermissions.contains)
      .toList();
}

class PermissionItem extends StatelessWidget {
  final String appName;
  final String packageName;
  final Widget icon;
  final List<String> permissions;
  final bool enabled;
  final bool isDangerous;
  final VoidCallback onTap;

  const PermissionItem({
    super.key,
    required this.appName,
    required this.packageName,
    required this.icon,
    required this.permissions,
    required this.enabled,
    required this.isDangerous,
    required this.onTap,

  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor =
    isDangerous ? Colors.red : Colors.orange;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.CartDark,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(width: 1.w,color: AppColor.CartDarkBorder),
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
          SizedBox(width: 12.w),
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

                Switch(
                  value: enabled,
                  onChanged: (_) => onTap(),
                  activeColor: activeColor,
                  inactiveThumbColor: Colors.white30,
                  inactiveTrackColor: Colors.white12,
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}
