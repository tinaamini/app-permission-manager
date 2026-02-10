import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/core/models/app_permission_ui.dart';

Widget appTile(
    BuildContext context,
    AppPermissionUi app, {
      required String actionText,
      required VoidCallback onTap,
    }) {
  return Container(width: 364.w,height: 80.h,
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      border:Border.all(width: 1.w,color: AppColor.CartDarkBorder) ,
      color: AppColor.CartDark,
      borderRadius: BorderRadius.circular(24.r),
    ),
    child: Row(
      children: [
        SizedBox(width: 5.w,),

        Image.memory(
          base64Decode(app.iconBase64),
          width: 36,
          height: 36,
        ),
        SizedBox(width: 18.w),
        Expanded(
          child: Text(
            app.appName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap:onTap ,
          child: Container(width:80.w,height: 32.h ,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColor.summary.withOpacity(0.2)
            ),
            child: Center(child: Text(actionText,style: AppTextStyle.summaryValue,)),
          ),
        ),
        SizedBox(width: 8.w),

      ],
    ),
  );
}
