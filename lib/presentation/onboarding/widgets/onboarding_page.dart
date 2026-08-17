import 'package:Privio/constant/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'onboarding_data.dart';

class OnboardPage extends StatelessWidget {
  final OnboardingData data;
  final int currentPage;
  final int totalPages;

  const OnboardPage({
    super.key,
    required this.data,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 35.h),
          child: Column(
            children: [
              // ===== TOP VISUAL =====
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.only(top: AppSize.width * 0.05),
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor:  0.85,
                      child: data.svgWidget,
                    ),
                  ),
                ),
              ),

              // ===== TEXT =====
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: AppTextStyle.onboardingTitle(context).copyWith(
                          color: isDark ? AppColor.white : AppColor.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data.description,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        style: AppTextStyle.onboardingDescription(
                          context,
                        ).copyWith(color: AppColor.blue1),
                      ),
                    ],
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
