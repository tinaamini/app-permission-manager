import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class BtnCard extends StatelessWidget {
  final String image;
  final String text;
  final VoidCallback ontap;
  const BtnCard({super.key, required this.image, required this.text, required this.ontap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: ontap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: screenHeight * 0.1,
        ),

        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          borderRadius: BorderRadius.circular(screenWidth * 0.06),
          border: Border.all(width: 1,color: AppColor.CartDarkBorder),

        ),
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.006),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(image,
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,),
              SizedBox(width: screenWidth * 0.025),

                  Expanded(child: Text(text,style: AppTextStyle.btnHome(context),)),

            ],
          ),
        ),
      ),
    );
  }
}
