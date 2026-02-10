import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_color.dart';

class AppTextStyle {
  static TextStyle get nameApp => TextStyle(
      fontFamily: 'Inter',
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white);

  static TextStyle get btnHome =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white);


  static TextStyle get btnAppPermissionInt =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
     );

  static TextStyle get CartDarkCount =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.CartDarkCount);

  static TextStyle get greenFont =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.green1);

  static TextStyle get greenWarning =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.green1);

  static TextStyle get blueFont =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.blue1);

  static TextStyle get trustTitle =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: AppColor.white);

  static TextStyle get trustDescription  =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.blue2);




  static TextStyle get titleSecure =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 22.sp,
      fontWeight: FontWeight.w700,
      color: AppColor.CartDarkCount);

  static TextStyle get System =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,);

  static TextStyle get keepbtn =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 8.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white);

  static TextStyle get usage =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white,
  height: 1.4.h);

  static TextStyle get summary =>TextStyle(
      fontFamily: 'Inter',
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.summary,
  height: 1.4.h);

  static TextStyle get summaryValue =>TextStyle(

      fontFamily: 'Inter',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.summary,
  height: 1.4.h);


  static TextStyle get groupPermission =>TextStyle(

      fontFamily: 'Inter',
      fontSize: 11.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.white,
  height: 1.4.h);

  static TextStyle get SpecialPermission =>TextStyle(

      fontFamily: 'Inter',
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white,
      height: 1.4.h);

  static TextStyle get SpecialPermissiontitle =>TextStyle(

      fontFamily: 'Inter',
      fontSize: 10.sp,
      fontWeight: FontWeight.w300,
      color: AppColor.white1,
      height: 1.4.h);

  static TextStyle get warning =>TextStyle(

      fontFamily: 'Inter',
      fontSize: 9.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.warningborder,
      height: 1.4.h);
  static TextStyle get dashboardTitle =>TextStyle(

      fontFamily: 'Inter',
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.white,
      );


}

