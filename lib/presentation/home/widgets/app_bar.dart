import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class AppBarWidget extends StatelessWidget {
  final String text;
  final VoidCallback ontap;

  const AppBarWidget({
    super.key,
    required this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight* 0.08, // ✅ h
      color: AppColor.CartDark,
      padding: EdgeInsets.symmetric(horizontal: screenWidth *0.04),
      child: Row(
        children: [
          GestureDetector(
            onTap: ontap,
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: SvgPicture.asset(
                "assets/main/back_icon.svg",
                width: screenWidth * 0.035,
                height: screenHeight * 0.035,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                text,
                style: AppTextStyle.nameApp,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          SizedBox(width: 28 + 10),
        ],
      ),
    );
  }
}