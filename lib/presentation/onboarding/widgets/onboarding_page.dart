import 'package:Privio/constant/app_color.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final size = MediaQuery.of(context).size;
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(top: 35.h),
          child: Column(
            children: [
              // ===== TOP VISUAL =====
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: AppSize.width * 0.1),
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow

                        Container(
                          width: size.width * 0.75,
                          height: size.width * 0.75,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: data.color.withValues(alpha:isDark ? 0.35:0.7),
                                blurRadius: 90,
                              ),
                            ],
                          ),
                        ),

                        // SVG
                        FractionallySizedBox(
                          widthFactor: currentPage == 1 ? 0.45 : 0.85,
                          child: SvgPicture.asset(
                            data.svg,
                            fit: currentPage == 2 ? BoxFit.none : BoxFit.fitWidth,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ===== TEXT =====
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: AppTextStyle.onboardingTitle(context).copyWith(color: isDark?AppColor.white:AppColor.black),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        data.description,
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        style: AppTextStyle.onboardingDescription(context)
                            .copyWith(color: data.color),
                      ),
                    ],
                  ),
                ),
              ),
              currentPage == 0 ? SizedBox.shrink() : Spacer(flex: 1),
              // ===== BOTTOM WIDGET =====
              Expanded(
                  flex: 3, child: data.bottomWidget ?? const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }
}
