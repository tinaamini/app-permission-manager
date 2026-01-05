import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class BtnPermissionWidget extends StatelessWidget {
  final String image;
  final String text;
  final String integer;
  final Color color;
  final VoidCallback ontap;

  const BtnPermissionWidget({super.key, required this.image, required this.text, required this.integer, required this.color, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child:  Container(width: 340.w,height: 100.h,
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
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.asset(image),

                        Text(text,style: AppTextStyle.nameApp.copyWith(color: color),),
                        Container(width: 30.w,height: 30.w,
                          decoration: BoxDecoration(
                            color: AppColor.BlurStyle,
                            borderRadius: BorderRadius.circular(8.w),
                          ),
                          child: Center(child: Text(integer,style: AppTextStyle.btnHome.copyWith(color: color),)),
                        )
                      ],
                    ),
                  ),
    );
  }
}
