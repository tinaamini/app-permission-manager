import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/core/servises/system_settings_platform.dart';

class SystemPrivacyDashboardCard extends StatelessWidget {
  const SystemPrivacyDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColor.CartDark,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color:AppColor.CartDarkBorder ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/dashboard/shield-tick.svg"),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'System Privacy Dashboard',
                  style: AppTextStyle.dashboardTitle
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'View permission activity and manage access directly in your phone settings.',
            style:AppTextStyle.trustDescription.copyWith(color: AppColor.green2)
          ),
          SizedBox(height: 12.h),

          // Buttons
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  color: AppColor.green1,

                  text: 'Open Privacy',
                  onTap: () => SystemSettingsPlatform.openPrivacySettings(),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _ActionBtn(
                  color: AppColor.green1,
                  text: 'Permission Manager',
                  onTap: () => SystemSettingsPlatform.openPermissionManager(),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          Text(
            'If it doesn’t open:\nSettings → Privacy → ...',
            style: TextStyle(
              color: AppColor.green2,
              fontSize: 11.sp,
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
  const _ActionBtn({required this.text, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          border: Border.all(width: 1.w,color: color),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,

            ),
          ),
        ),
      ),
    );
  }
}
