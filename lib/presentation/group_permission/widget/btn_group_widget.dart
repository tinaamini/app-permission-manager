import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class BtnGroupWidget extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback ontap;
  const BtnGroupWidget({super.key, required this.image, required this.text, required this.ontap});



    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onTap: ontap,
        child: Container(width: 100.w,height: 280.h,
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
          child: Stack(
            children: [
              Positioned(top: -30.w,left:-53.w,
                  child: Container(child: Image.asset(image,width: 180.w,height: 180.w,))),
              Positioned(top: 100.w,
                  child: Container(width: 80.w,height: 80.w,
                    child: Text(text,style: AppTextStyle.groupPermission ,  textAlign: TextAlign.center,
                    ),
                  ))
            ],
          ),
        ),
      );
    }
  }
