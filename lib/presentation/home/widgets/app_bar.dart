import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class AppBarWidget extends StatelessWidget {
  final String text;
  final VoidCallback ontap;

  const AppBarWidget({
    super.key,
    required this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h, // ✅ h
      color: AppColor.CartDark,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: ontap,
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: SvgPicture.asset(
                "assets/main/back_icon.svg",
                width: 28.w,
                height: 28.w,
              ),
            ),
          ),

          // ✅ این باعث میشه عنوان وسط واقعی بشه
          Expanded(
            child: Center(
              child: Text(
                text,
                style: AppTextStyle.nameApp,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // ✅ این برای بالانس سمت راست تا title دقیقاً وسط بمونه
          SizedBox(width: 28.w + 10.w),
        ],
      ),
    );
  }
}