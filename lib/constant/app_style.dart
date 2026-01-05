import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_color.dart';

class AppTextStyle {
  static TextStyle get nameApp => TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18.w,
      fontWeight: FontWeight.w600,
      color: AppColor.white);

  static TextStyle get btnHome =>TextStyle(
      fontFamily: 'Poppins',
      fontSize: 13.w,
      fontWeight: FontWeight.w400,
      color: AppColor.white);

  static TextStyle get keepbtn =>TextStyle(
      fontFamily: 'Poppins',
      fontSize: 8.w,
      fontWeight: FontWeight.w400,
      color: AppColor.white);
  static TextStyle get usage =>TextStyle(
      fontFamily: 'Poppins',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white,
  height: 1.4.h);
  static TextStyle get summary =>TextStyle(
      fontFamily: 'Poppins',
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.summary,
  height: 1.4.h);
  static TextStyle get summaryValue =>TextStyle(

      fontFamily: 'Poppins',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.summary,
  height: 1.4.h);
  static TextStyle get groupPermission =>TextStyle(

      fontFamily: 'Poppins',
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.white,
  height: 1.4.h);

  static TextStyle get SpecialPermission =>TextStyle(

      fontFamily: 'Poppins',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white,
      height: 1.4.h);
  static TextStyle get SpecialPermissiontitle =>TextStyle(

      fontFamily: 'Poppins',
      fontSize: 10.sp,
      fontWeight: FontWeight.w300,
      color: AppColor.white1,
      height: 1.4.h);
  static TextStyle get warning =>TextStyle(

      fontFamily: 'Poppins',
      fontSize: 9.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.warningborder,
      height: 1.4.h);


}

