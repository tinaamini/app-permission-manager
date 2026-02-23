import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int length;

  const PageIndicator({super.key, required this.currentIndex, required this.length});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
            (index) => Container(
          margin:  EdgeInsets.symmetric(horizontal:1.w),
          width: currentIndex == index ? 60.w : 18.w,
          height:3.w,
          decoration: BoxDecoration(
            color: currentIndex == index ? AppColor.blue1 : AppColor.blue2,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
