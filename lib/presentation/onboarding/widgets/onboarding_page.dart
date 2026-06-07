import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/generated/app_localizations.dart';
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return  ColoredBox(
      color: Colors.black,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05  ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.03),

              // ===== Top visual area =====
              Expanded(
                flex: 45,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Glow
                      Container(
                        width: screenWidth * 0.5,
                        height:screenHeight * 0.5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: data.color.withValues(alpha: 0.40),
                              blurRadius: 88,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),

                      // Illustration
                      SizedBox(
                        width: currentPage == 0 ? screenWidth * 0.45 :screenWidth * 0.75 ,
                        height: currentPage == 0 ? screenHeight * 0.45  :screenHeight * 0.75 ,
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
                      style: AppTextStyle.onboardingTitle(context),
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    Text(
                      data.description,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.onboardingDescription(context)
                          .copyWith(color: data.color),
                    ),
                  ],
                ),
              ),

              // ===== Button area =====
              Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                child: SizedBox(
                  width: double.infinity,
                  child: NextButton(
                    onTap: onNext,

                    text: isLast ? l10n.getStarted : l10n.next,
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