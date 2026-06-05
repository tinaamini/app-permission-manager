import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

class PermissionSwitchTile extends StatelessWidget {
  final String title;
  final bool enabled;
  final bool isDangerous;
  final VoidCallback onTap;

  const PermissionSwitchTile({
    super.key,
    required this.title,
    required this.enabled,
    required this.isDangerous,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeColor = isDangerous ? Colors.red : Colors.orange;

    return Container(
      margin: EdgeInsets.only(        bottom: AppSize.height * 0.012,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width * 0.035,
        vertical: AppSize.height * 0.012,
      ),
      decoration: BoxDecoration(
        color: AppColor.CartDark,
        borderRadius: BorderRadius.circular(
          AppSize.width * 0.035,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: AppSize.width * 0.03,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.width * 0.035,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: enabled,
              onChanged: (_) => onTap(),
              activeColor: activeColor,
              inactiveThumbColor: Colors.white30,
              inactiveTrackColor: Colors.white12,
            ),
          ),
        ],
      ),
    );
  }
}