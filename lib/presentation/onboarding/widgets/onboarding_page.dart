import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
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
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final isLast = currentPage == totalPages - 1;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),

              // ===== Top visual area =====
              Expanded(
                flex: 55,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Glow
                      Container(
                        width: 180.w,
                        height: 180.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: data.color.withOpacity(0.40),
                              blurRadius: 88,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),

                      // Illustration
                      SizedBox(
                        width: currentPage == 0 ? 200.w :360.w,
                        height: currentPage == 0 ? 200.h :360.h,
                        child: SvgPicture.asset(
                          data.svg,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ===== Text area =====
              Expanded(
                flex: 65,
                child: Column(
                  children: [

                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.onboardingTitle,
                    ),

                    SizedBox(height: 5.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Text(
                        data.description,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.onboardingDescription
                            .copyWith(color: data.color),
                      ),
                    ),
                  ],
                ),
              ),

              // ===== Button area =====
              Padding(
                padding: EdgeInsets.only(bottom: 33.h),
                child: SizedBox(
                  width: double.infinity,
                  child: NextButton(
                    OnTap: onNext,

                    text: isLast ? "Get Started" : "Next",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}