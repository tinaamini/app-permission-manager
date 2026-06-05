import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';

class NextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const NextButton({super.key, required this.onTap, required this.text,});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container( height: screenHeight * 0.06,
        decoration: BoxDecoration(
          color: AppColor.blue1,
          borderRadius: BorderRadius.all(Radius.circular( screenWidth * 0.038,)),
        ),
        child: Center(child: Text(text,style: AppTextStyle.nameApp,)),
      ),
    );
  }
}
