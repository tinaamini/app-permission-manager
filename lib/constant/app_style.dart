import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Privio/presentation/utils/app_size.dart';

import 'app_color.dart';

class AppTextStyle {
  static String _font(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return lang == 'fa' ? 'Shabnam' : 'Inter';
  }

  static bool _fa(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'fa';

  static TextStyle nameApp(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize:  16.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white);

  static TextStyle onboardingTitle(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 40.sp,
      fontWeight: FontWeight.w700,
      color: AppColor.white);

  static TextStyle onboardingDescription(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white);

  static TextStyle onboardingSkip(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: _fa(context) ? 18.sp : 16.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.blue1);

  static TextStyle emptyPage(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: context.isDark ?AppColor.green2:AppColor.green4.withAlpha(250));

  static TextStyle btnHome(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white);

  static TextStyle btnAppPermissionInt(BuildContext context) => TextStyle(
      fontFamily: _font(context), fontSize: 14.sp, fontWeight: FontWeight.w700);

  static TextStyle cartDarkCount(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.CartDarkCount);

  static TextStyle greenFont(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: context.isDark ?AppColor.green1:AppColor.green3);

  static TextStyle greenWarning(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: context.isDark?AppColor.green1:AppColor.green3);

  static TextStyle blueFont(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 15.sp,
      fontWeight: FontWeight.w600,
      color: AppColor.blue1);

  static TextStyle trustTitle(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 20.sp,
      fontWeight: FontWeight.w700,
      color: context.isDark?AppColor.white:AppColor.black);

  static TextStyle trustDescription(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.blue2);

  static TextStyle titleSecure(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: _fa(context) ? 15.sp : 22.sp,
      fontWeight: FontWeight.w700,
      color: AppColor.white);

  static TextStyle lastScan(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColor.CartDarkBorder);

  static TextStyle system(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize:  12.sp,
      fontWeight: FontWeight.w500);

  static TextStyle keepBtn(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 8.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.white);

  static TextStyle usage(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: context.isDark?AppColor.white:AppColor.black,
      height: 1.4);
  static TextStyle btnUsage(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 12.sp,
      fontWeight: FontWeight.w700,
      color: context.isDark?AppColor.white:Colors.blue,
      height: 1.4);

  static TextStyle summary(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.summary,
      height: 1.4);

  static TextStyle summaryValue(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.summary,
      height: 1.4);

  static TextStyle groupPermission(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 15.sp,
      fontWeight: FontWeight.w500,
      color:context.isDark? AppColor.white:AppColor.bcGround,
      height: 1.4);

  static TextStyle specialPermission(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color:context.isDark? AppColor.white:AppColor.bcGround,
      height: 1.4);

  static TextStyle specialPermissiontitle(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 10.sp,
      fontWeight: FontWeight.w300,
      color:context.isDark? AppColor.white:AppColor.textLight,
      height: 1.4);

  static TextStyle warning(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 10.sp,
      fontWeight: FontWeight.w700,
      color: AppColor.warningBorder,
      height: 1.4);

  static TextStyle dashboardTitle(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: context.isDark?AppColor.white:AppColor.bcGround);

  static TextStyle questionTitle(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: context.isDark ? Colors.white : AppColor.black);

  static TextStyle questionTitle2(BuildContext context) => TextStyle(
        fontFamily: _font(context),
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: context.isDark ? AppColor.green1 : AppColor.green3,
      );

  static TextStyle questionDescription(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: context.isDark ? AppColor.green2 : AppColor.green4);

  static TextStyle appName(BuildContext context) => TextStyle(
      fontFamily: _font(context),
      color: context.isDark ? Colors.white : AppColor.black,
      fontSize: 15.sp,
      fontWeight: FontWeight.w600);

  static TextStyle trusted(BuildContext context) => TextStyle(
  fontFamily: _font(context),

  color: Colors.blue,
  fontSize: AppSize.width * 0.03,
  fontWeight: FontWeight.w600,
  letterSpacing: 0.2);

  static TextStyle summaryRow(BuildContext context) => TextStyle(
  fontFamily: _font(context),

  color: context.isDark ?Colors.white54:AppColor.bcGround,
  fontSize: 14.sp,);


}
