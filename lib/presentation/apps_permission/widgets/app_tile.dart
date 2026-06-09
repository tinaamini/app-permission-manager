import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/models/app_permission_ui.dart';

Widget appTile(
    BuildContext context,
    AppPermissionUi app, {
      required String actionText,
      required VoidCallback onTap,
    }) {
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  return Container(
    margin: EdgeInsets.only(bottom: screenHeight * 0.015),
    padding: EdgeInsets.all(screenWidth * 0.03),
    decoration: BoxDecoration(
      border:Border.all(width: 1,color: AppColor.CartDarkBorder) ,
      color: AppColor.CartDark,
      borderRadius: BorderRadius.circular(screenWidth * 0.06),
    ),
    child: Row(
      children: [
        SizedBox(width: screenWidth * 0.0125),

        Image.memory(
          base64Decode(app.iconBase64),
          width: screenWidth * 0.09,
          height: screenWidth * 0.09,
        ),
        SizedBox(width: screenWidth * 0.045),
        Expanded(
          child: Text(
            app.appName,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        GestureDetector(
          onTap:onTap ,
          child: Container(
            width: screenWidth * 0.2,
            height: screenHeight * 0.04,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: AppColor.summary.withOpacity(0.2)
            ),
            child: Center(child: Text(actionText,style: AppTextStyle.summaryValue(context),)),
          ),
        ),
        SizedBox(width: screenWidth * 0.02),

      ],
    ),
  );
}
