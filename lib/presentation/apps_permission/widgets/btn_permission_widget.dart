import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class BtnPermissionWidget extends StatelessWidget {
  final String image;
  final String text;
  final String integer;
  final Color color;
  final VoidCallback ontap;

  const BtnPermissionWidget(
      {super.key,
      required this.image,
      required this.text,
      required this.integer,
      required this.color,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
        
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: AppColor.CartDark,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(width: 1.w, color: color),
          ),
          child: Column(
            children: [
              SizedBox(height: 20.h,),
              SizedBox(width: 55.w,height: 59.w,
                child: Stack(children: [
                  Positioned(top:9.h,
                      child: SvgPicture.asset(image)),
                  Positioned(
                      top: 0.w,left: 32.w,
                      child: Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color:color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30.w),
                    ),
                    child: Center(
                        child: Text(
                      integer,
                      style: AppTextStyle.btnAppPermissionInt.copyWith(color: color),  maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                    )),
                  ))
                ]),
              ),
              SizedBox(height: 15.h,),
        
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),                child: Text(
                  text,
                  style: AppTextStyle.nameApp,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
