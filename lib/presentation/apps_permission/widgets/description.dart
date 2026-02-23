import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget description(String text) => Padding(
  padding: EdgeInsets.only(bottom: 12.h),
  child: Text(
    text,
    style: TextStyle(
      color: Colors.white60,
      fontSize: 12.sp,
    ),
    textAlign: TextAlign.start,
    softWrap: true,
  ),
);