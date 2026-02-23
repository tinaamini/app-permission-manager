import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_style.dart';

class EmptyPageWidget extends StatelessWidget {
  final String text;

  const EmptyPageWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/utils/emoji-sad.svg",
              width: 100.w,
              height: 100.h,
            ),
            SizedBox(height: 18.h),
            Text(
              text,
              style: AppTextStyle.EmptyPage,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}