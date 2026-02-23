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
      return InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(12.r),

        child: Container(
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
              Positioned(top: -23.w,left:25.w,
                  child: Container(child: Image.asset(image,width: 100.w,height: 100.w,))),
              Positioned(top: 60.w,left: 35.w,
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
