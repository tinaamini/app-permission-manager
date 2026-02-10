import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class AppBarWidget extends StatelessWidget {
  final String text;
  final int width;
  final VoidCallback ontap;
  const AppBarWidget({super.key, required this.text, required this.ontap, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(height: 80.w,color: AppColor.CartDark,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w),
        child: Row(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(onTap: ontap,
              child: Padding(
                padding:  EdgeInsets.only(left: 10.w),
                child: SvgPicture.asset("assets/main/back_icon.svg",width: 28.w,height: 28.w,)
              ),
            )  ,
          SizedBox(width: width.w,),
          Text(text,style: AppTextStyle.nameApp,)],
        ),
      ),
    );
  }
}
