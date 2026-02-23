import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class BtnHomeWidget extends StatelessWidget {
  final String image;
  final String text;
  final String textCount;
  final VoidCallback ontap;

  const BtnHomeWidget({
    super.key,
    required this.image,
    required this.text,
    required this.ontap,
    required this.textCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(


        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 16.h,
        ),
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            width: 1.w,
            color: AppColor.CartDarkBorder,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              image,
              width: 48.w,
              height: 48.h,
            ),
            SizedBox(height: 8.h),

            Text(
              text,
              style: AppTextStyle.btnHome,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 4.h),

            Text(
              textCount,
              style: AppTextStyle.CartDarkCount,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}