import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/permissionConst.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

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
    final Color activeColor = isDangerous ? Colors.red : Colors.orange;

    return Container(
      padding: EdgeInsets.all(AppSize.width * 0.03),
      decoration: BoxDecoration(
        color: AppColor.CartDark,
        borderRadius: BorderRadius.circular(AppSize.width * 0.06),
        border: Border.all(width: 1, color: AppColor.CartDarkBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(128),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: AppSize.width * 0.03),
          SizedBox(
            width: AppSize.width * 0.11,
            height: AppSize.width * 0.11,
            child: icon,
          ),
          SizedBox(width: AppSize.width * 0.03),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSize.width * 0.035,
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
