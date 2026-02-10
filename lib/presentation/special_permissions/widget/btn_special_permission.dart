import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/constant/risk_level.dart';

class BtnSpecialPermission extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  final VoidCallback ontap;
  final RiskLevel riskLevel;
  final bool enabled;

  const BtnSpecialPermission({
    super.key,
    required this.image,
    required this.title,
    required this.text,
    required this.ontap,
    required this.riskLevel,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {


    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          borderRadius: BorderRadius.circular(12.r),
border: Border.all(width: 1.w,color: AppColor.CartDarkBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: 56.w,
              height: 56.w,
              fit: BoxFit.contain,
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.SpecialPermission,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.SpecialPermissiontitle,
                  ),
                ],
              ),
            ),

            SizedBox(width: 12.w),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _riskBadge(),
                SizedBox(height: 10.h),
                _statusText(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _riskBadge() {
    late final Color color;
    late final String label;

    switch (riskLevel) {
      case RiskLevel.highRisk:
        color = Colors.redAccent;
        label = 'HIGH RISK';
        break;
      case RiskLevel.mediumRisk:
        color = Colors.orangeAccent;
        label = 'MEDIUM RISK';
        break;
      case RiskLevel.lowRisk:
        color = Colors.greenAccent;
        label = 'LOW RISK';
        break;
      case RiskLevel.noRisk:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color, width: 0.8),
      ),
      child: Text(
        label,
        style: AppTextStyle.SpecialPermission.copyWith(
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _statusText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled ? Colors.greenAccent : Colors.grey,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          enabled ? 'Enabled' : 'Disabled',
          style: AppTextStyle.SpecialPermissiontitle.copyWith(
            color:
            enabled ? AppColor.summary : AppColor.white1,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
