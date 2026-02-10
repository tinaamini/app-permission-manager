import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class BtnCard extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback ontap;
  const BtnCard({super.key, required this.image, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(width: 364.w,height: 80.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(width: 1.w,color: AppColor.CartDarkBorder),

        ),
        child: Padding(
          padding:  EdgeInsets.only(top: 5.w),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(image,width: 48.w,height: 48.h,),
              SizedBox(width: 7.w,),

                  Center(child: Text(text,style: AppTextStyle.btnHome,)),

            ],
          ),
        ),
      ),
    );
  }
}
