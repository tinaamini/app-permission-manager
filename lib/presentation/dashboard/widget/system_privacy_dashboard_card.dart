import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/core/servises/system_settings_platform.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

class SystemPrivacyDashboardCard extends StatelessWidget {
  const SystemPrivacyDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.width * 0.035),
      decoration: BoxDecoration(
        color: AppColor.CartDark,
        borderRadius: BorderRadius.circular(AppSize.width * 0.03),
        border: Border.all(color: AppColor.CartDarkBorder),
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      Row(
      children: [
      SvgPicture.asset("assets/dashboard/shield-tick.svg"),
      SizedBox(width: AppSize.width * 0.02),
      Expanded(
        child: Text(
          'System Privacy Dashboard',
          style: AppTextStyle.dashboardTitle,
        ),
      ),
      ],
    ),
    SizedBox(height: AppSize.height * 0.012),
    Text(
    'View permission activity and manage access directly in your phone settings.',
    style: AppTextStyle.trustDescription.copyWith(color: AppColor.green2),
    ),
    SizedBox(height: AppSize.height * 0.015),

    Row(
    children: [
    Expanded(
    child: _ActionBtn(
    color: AppColor.green1,
    text: 'Open Privacy',
    onTap: () => SystemSettingsPlatform.openPrivacySettings(),
    ),
    ),
    SizedBox(width: AppSize.width * 0.025),
    Expanded(
    child: _ActionBtn(
    color: AppColor.green1,
    text: 'Permission Manager',
    onTap: () => SystemSettingsPlatform.openPermissionManager(),
    ),
    ),
    ],
    ),

    SizedBox(height: AppSize.height * 0.015),
    Text(
      'If it doesn’t open:\nSettings → Privacy → ...',
    style: TextStyle(
    color: AppColor.green2,
    fontSize: AppSize.width * 0.028,
    height: 1.35,
    ),
    ),
    ],
    ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;

  const _ActionBtn({
    required this.text,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSize.width * 0.025),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSize.height * 0.012),
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          border: Border.all(width: 1, color: color),
          borderRadius: BorderRadius.circular(AppSize.width * 0.025),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: AppSize.width * 0.03,
            ),
          ),
        ),
      ),
    );
  }
}