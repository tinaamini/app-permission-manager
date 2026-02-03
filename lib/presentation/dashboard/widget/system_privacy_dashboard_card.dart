import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/core/servises/system_settings_platform.dart';

class SystemPrivacyDashboardCard extends StatelessWidget {
  const SystemPrivacyDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Colors.white70, size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'System Privacy Dashboard',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            'View permission activity and manage access directly in your phone settings.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
              height: 1.35,
            ),
          ),
          SizedBox(height: 12.h),

          // Buttons
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  text: 'Open Privacy',
                  onTap: () => SystemSettingsPlatform.openPrivacySettings(),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _ActionBtn(
                  text: 'Permission Manager',
                  onTap: () => SystemSettingsPlatform.openPermissionManager(),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),
          Text(
            'If it doesn’t open:\nSettings → Privacy → (Privacy dashboard / Permission manager)',
            style: TextStyle(
              color: Colors.white38,
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
  const _ActionBtn({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }
}
