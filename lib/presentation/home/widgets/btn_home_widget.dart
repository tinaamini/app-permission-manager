import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';

class BtnHomeWidget extends StatelessWidget {
  final String image;
  final String text;
  final String textCount;
  final VoidCallback ontap;

  const BtnHomeWidget({
    super.key,
    required this.image,
    required this.text,
    required this.ontap,
    required this.textCount,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: ontap,
      child: Container(


        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.017,
        ),
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
          border: Border.all(
            width: 1,
            color: AppColor.CartDarkBorder,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              image,
              width: screenWidth * 0.05,
              height: screenHeight * 0.054,
            ),
            SizedBox(height: screenHeight * 0.008),

            Text(
              text,
              style: AppTextStyle.btnHome(context),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: screenHeight * 0.005),

            Text(
              textCount,
              style: AppTextStyle.cartDarkCount(context),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}