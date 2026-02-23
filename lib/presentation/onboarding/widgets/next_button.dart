import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class NextButton extends StatelessWidget {
  final VoidCallback OnTap;
  final String text;

  const NextButton({super.key, required this.OnTap, required this.text,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: OnTap,
      child: Container(width: 314.w,height: 48.h,
        decoration: BoxDecoration(
          color: AppColor.blue1,
          borderRadius: BorderRadius.all(Radius.circular(16.r)),
        ),
        child: Center(child: Text(text,style: AppTextStyle.nameApp,)),
      ),
    );
  }
}
