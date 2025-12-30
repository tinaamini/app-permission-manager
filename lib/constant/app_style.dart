import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_color.dart';

class AppTextStyle {
  static TextStyle get nameApp => TextStyle(
      fontFamily: 'Poppins',
      fontSize: 18.w,
      fontWeight: FontWeight.w600,
      color: AppColor.white);

  static TextStyle get btnHome =>TextStyle(
      fontFamily: 'Poppins',
      fontSize: 13.w,
      fontWeight: FontWeight.w400,
      color: AppColor.white);



}

