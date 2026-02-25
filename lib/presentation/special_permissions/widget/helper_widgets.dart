import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/constant/risk_level.dart';

Widget sectionTitle(String text) {
  return Text(
    text,
    style: AppTextStyle.trustTitle
  );
}

Widget paragraph(String text) {
  return Padding(
    padding: EdgeInsets.only(top: 8.h),
    child: Text(
      text,
      style:AppTextStyle.trustDescription.copyWith(color: AppColor.green2)
    ),
  );
}

Widget riskBadge({required RiskLevel level}) {
  late Color color;
  late String label;

  switch (level) {
    case RiskLevel.highRisk:
      color = Colors.red;
      label = 'ACTION NEEDED';
      break;

    case RiskLevel.mediumRisk:
      color = Colors.orange;
      label = 'REVIEW';
      break;

    case RiskLevel.lowRisk:
      color = Colors.green;
      label = 'LOW';
      break;

    case RiskLevel.noRisk:
      color = Colors.blue;
      label = 'SECURE';
      break;
  }

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: color.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: 12.sp,
      ),
    ),
  );
}

Widget actionButton({
  required String text,
  required VoidCallback onTap,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.CartDark,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,

        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
