
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/routs/rout_name.dart';
import 'next_button.dart';
import 'onboarding_data.dart';

class OnboardPage extends StatelessWidget {
  final OnboardingData data;
  final int currentPage;
  final int totalPages;
  final VoidCallback onNext;

  const OnboardPage({
    super.key,
    required this.data,
    required this.currentPage,
    required this.totalPages,
    required this.onNext,});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [

          Positioned(
            top: 100.h,left: 120.w,
            child:  Container(width:180.w,height: 180.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(75.w),
                  boxShadow: [
                    BoxShadow(
                      color: data.color.withOpacity(0.4),
                      blurRadius: 88,
                      spreadRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
            ),),

      Positioned(   top: currentPage == totalPages - 3  ? 100.h:70.h,left: currentPage == totalPages - 3  ? 120.h: 80.w,
          child: Container(width:  currentPage == totalPages - 3  ?180.w:270.w,height:  currentPage == totalPages - 3  ?180.w:270.w,
          child: SvgPicture.asset(data.svg,fit: BoxFit.cover,))),

          Positioned(top:320.h,left:  currentPage == totalPages - 3  ? 65.w : currentPage == totalPages - 2  ?100.w:130.w,
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style:  AppTextStyle.onboardingTitle
            ),
          ),

          Positioned(top:450.h,left:  currentPage == totalPages - 3  ? 20.w :50.w,
            child: Text(
              data.description,
              textAlign: TextAlign.center,
              style:AppTextStyle.onboardingDescription.copyWith(color: data.color)
            ),
          ),

          

          Positioned(
            bottom:37.h,
            left: 50.w,
            child:  NextButton(
              OnTap: currentPage == totalPages - 1  ? () {
          context.goNamed(RouteName.home);
          }
            : onNext,
            text: currentPage == totalPages - 1 ? "Get Started " : "Next",
          ),)
        ],
      ),
    );
  }
}
