import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class AppBarWidget extends StatelessWidget {
  final String text;
  final int width;
  final VoidCallback ontap;
  const AppBarWidget({super.key, required this.text, required this.ontap, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(height: 50.w,color: AppColor.CartDark,
      child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(onTap: ontap,
            child: Padding(
              padding:  EdgeInsets.only(left: 10.w),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColor.white,size: 30.w,
              ),
            ),
          )  ,
        SizedBox(width: width.w,),
        Text(text,style: AppTextStyle.nameApp,)],
      ),
    );
  }
}
