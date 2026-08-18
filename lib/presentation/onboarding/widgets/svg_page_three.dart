import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SvgPageThree extends StatelessWidget {
  const SvgPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;


    return Container(
      child:Column(
        children: [
          SvgPicture.asset("assets/main/safe_alert.svg",height: 100.h,),
          SizedBox(height: 15.h,),
          Container(width: 122.w,height: 38.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(61.r),
              border: Border.all(width: 2.w,color: isDark ?AppColor.green1:AppColor.green3),
              color: isDark ?AppColor.green1.withAlpha(70):AppColor.green3.withAlpha(70)

            ),
            child: Padding(
              padding:  EdgeInsets.only(top: 6.h),
              child: Text(l10n.secureSystem,      textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyle.lastScan(context).copyWith(
                    color: isDark ?AppColor.green1:AppColor.green3
                ),),
            ),
          ),
          SizedBox(height: 15.h,),
          Text(l10n.theDeviceIsSecure, textAlign: TextAlign.center,
            maxLines: 2,
            style: AppTextStyle.nameApp(context).copyWith(
                color: isDark ?AppColor.white:AppColor.black
            ),),
          SizedBox(height: 5.h,),

          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(l10n.lastScann, textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyle.specialPermissiontitle(context).copyWith(
                    color: isDark ?AppColor.white:AppColor.blurStyle
                ),),
              Text(":", textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyle.specialPermissiontitle(context).copyWith(
                    color: isDark ?AppColor.white:AppColor.blurStyle
                ),),

              Text ( l10n.minutesAgo(2),
                textAlign: TextAlign.center,
                maxLines: 2,
                style: AppTextStyle.specialPermissiontitle(context).copyWith(
                    color: isDark ?AppColor.white:AppColor.blurStyle
                ),),
            ],
          ),
          SizedBox(height: 20.h,),
          
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _widgetContainer(context,color: AppColor.aboutAccentPink, svg:"assets/utils/elements (3).svg", text:l10n.permCamera),
                _widgetContainer(context,color: AppColor.aboutAccentOrange, svg:"assets/utils/elements (2).svg", text:l10n.permMicrophone),
                _widgetContainer(context,color: AppColor.aboutAccentBlue, svg:"assets/utils/elements (1).svg", text:l10n.calls),
                _widgetContainer(context,color: AppColor.redOnboarding, svg:"assets/utils/call.svg", text:l10n.permContacts)
              ],
            ),
          )




        ],
      ),
    );
  }

  Widget _widgetContainer (

      BuildContext context,
      {
        required Color color,
        required String svg,
        required String text,
      }
      ){
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Container(
      width: 82.w,
      height: 120.h,
      decoration: BoxDecoration(
        border: Border.all(width: 2.w, color: color),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(svg),
          Text(
            text,
            style: AppTextStyle.permissionOnboarding(context)
                .copyWith(color: isDark ? AppColor.white : AppColor.black),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SvgPicture.asset("assets/utils/tick-circle.svg"),

        ],
      ),

    );
  }
}
