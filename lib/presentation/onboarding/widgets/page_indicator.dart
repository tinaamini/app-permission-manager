import 'package:flutter/material.dart';
import 'package:Privio/constant/app_color.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int length;

  const PageIndicator({super.key, required this.currentIndex, required this.length});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
            (index) => Container(
          margin:  EdgeInsets.symmetric(horizontal:1),
              width: currentIndex == index ? screenWidth *0.1 : screenWidth*0.05,
          height:screenHeight * 0.005,
          decoration: BoxDecoration(
            color: currentIndex == index ? AppColor.blue1 : AppColor.blue2,
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
          ),
        ),
      ),
    );
  }
}
