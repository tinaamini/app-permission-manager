import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class BtnHomeWidget extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback ontap;
  const BtnHomeWidget({super.key, required this.image, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(width: 150.w,height: 130.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding:  EdgeInsets.only(top: 5.w),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(image,width: 150.w,height: 65.h,),
              Center(child: Text(text,style: AppTextStyle.btnHome,))
            ],
          ),
        ),
      ),
    );
  }
}
