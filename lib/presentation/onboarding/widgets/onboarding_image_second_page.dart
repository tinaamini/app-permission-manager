import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class OnboardingImageSecondPage extends StatelessWidget {
  const OnboardingImageSecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
      SizedBox(height:55.w,),
    Container(
      width: 312.w,
      height: 125.w,
      child: Stack(
        children: [
          Positioned(top:53.w,
            child: Container(
              width: 312.w,
              height: 71.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.w)),
                  border: Border.all(width: 1.w, color: AppColor.green2)),
              child: Padding(
                padding:  EdgeInsets.only(right: 20.w,top: 10.w),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/icons/Vector (10).svg",width: 16.w,height: 16.w,),
                        SizedBox(width: 5.w,),
                        Text("رنگی‌کردن",style: AppTextStyle.trustDescription,)
                      ],
                    ),
                    SizedBox(height: 5.w,),
                    Text("عکس سیاه‌وسفید خود را به رنگی تبدیل کنید",style: AppTextStyle.trustDescription.copyWith(fontSize: 11.w),)
                  ],
                ),
              ),
            ),
          ),
          Positioned(left: 13.w,top: 50.w,
              child:Container( width: 140.w,height: 8.w,color: AppColor.CartDark,)),
          Positioned(left: 20.w,
              child: Center(child: Image.asset("assets/onboarding/ChatGPT Image Sep 16, 2025, 05_56_23 PM (1) 2.png"))),

        ],
      ),
    ),
            SizedBox(height:11.w,),

            Container(
      width: 312.w,
      height: 125.w,
      child: Stack(
        children: [
          Positioned(top:53.w,
            child: Container(
              width: 312.w,
              height: 71.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.w)),
                  border: Border.all(width: 1.w, color: AppColor.green2)),
              child: Padding(
                padding:  EdgeInsets.only(left: 20.w,top: 10.w),
                child: Column(crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                        Text("افزایش کیفیت",style: AppTextStyle.trustDescription,),
                        SizedBox(width: 5.w,),

                        SvgPicture.asset("assets/icons/Vector (10).svg",width: 16.w,height: 16.w),

                      ],
                    ),
                    SizedBox(height: 5.w,),

                    Text("وضوح و شفافیت تصویر را افزایش دهید",style:AppTextStyle.trustDescription.copyWith(fontSize: 11.w),)
                  ],
                ),
              ),
            ),
          ),
          Positioned(right: 20.w,
              child: Container(width: 140.w,height: 92.w,color: AppColor.CartDark,
              child: Center(child: Image.asset("assets/onboarding/ChatGPT Image Sep 16, 2025, 05_56_23 PM (1) 2 (1).png"))))


        ],
      ),
    ),
            SizedBox(height:11.w,),

    Container(
      width: 312.w,
      height: 125.w,
      child: Stack(
        children: [
          Positioned(top:53.w,
            child: Container(
              width: 312.w,
              height: 71.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15.w)),
                  border: Border.all(width: 1.w, color: AppColor.green2)),
              child: Padding(
                padding:  EdgeInsets.only(right: 20.w,top: 10.w),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset("assets/icons/Vector (10).svg"),
                        SizedBox(width: 5.w,),
                        Text("بازسازی تصاویر",style: AppTextStyle.trustDescription,)
                      ],
                    ),
                    SizedBox(height: 5.w,),
                    Text("هم‌زمان هم رنگی‌سازی و هم بهبود کیفیت را اعمال کنید",style: AppTextStyle.trustDescription.copyWith(fontSize: 11.w),)
                  ],
                ),
              ),
            ),
          ),
          Positioned(left: 20.w,
              child: Container(width: 140.w,height: 92.w,color: AppColor.CartDark,
                  child: Center(child: Image.asset("assets/onboarding/ChatGPT Image Sep 16, 2025, 05_56_23 PM (1) 2 (2).png"))))



        ],
      ),
    ),


          ],
        );
  }
}
