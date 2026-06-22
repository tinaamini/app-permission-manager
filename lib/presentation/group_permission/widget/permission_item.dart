import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/permissionConst.dart';
import 'package:Privio/presentation/utils/app_size.dart';

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
        color: context.isDark?AppColor.CartDark:AppColor.btnLight,
        borderRadius: BorderRadius.circular(AppSize.width * 0.06),
        border: Border.all(width: 1, color: context.isDark?AppColor.CartDarkBorder:AppColor.borderLight),

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
                    style:AppTextStyle.appName(context))
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
