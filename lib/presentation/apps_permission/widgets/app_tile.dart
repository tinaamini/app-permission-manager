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
  return Container(
    margin: EdgeInsets.only(bottom: 12.h),
    padding: EdgeInsets.all(12.w),
    decoration: BoxDecoration(
      color: AppColor.CartDark,
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: Row(
      children: [
        Image.memory(
          base64Decode(app.iconBase64),
          width: 36,
          height: 36,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            app.appName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(actionText,style: AppTextStyle.summaryValue,),
        ),
      ],
    ),
  );
}
