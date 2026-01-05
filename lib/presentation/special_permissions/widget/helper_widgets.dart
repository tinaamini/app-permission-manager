import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';

Widget sectionTitle(String text) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
}

Widget paragraph(String text) {
  return Padding(
    padding: EdgeInsets.only(top: 8.h),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        color: Colors.white70,
        height: 1.5,
      ),
    ),
  );
}

Widget riskBadge({required bool high}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: high ? Colors.red.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      high ? 'HIGH RISK' : 'LOW RISK',
      style: TextStyle(
        color: high ? Colors.red : Colors.orange,
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
      ),
    ),
  );
}
