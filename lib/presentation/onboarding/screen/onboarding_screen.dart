import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Privio/constant/app_style.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/onboarding/onboarding_cubit.dart';
import 'package:Privio/logic/onboarding/show_onboarding/show_onboarding_cubit.dart';
import 'package:Privio/presentation/onboarding/widgets/next_button.dart';
import 'package:Privio/presentation/onboarding/widgets/onboarding_data.dart';
import 'package:Privio/presentation/onboarding/widgets/onboarding_page.dart';
import 'package:Privio/presentation/onboarding/widgets/page_indicator.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _nextPage(BuildContext context, int currentPage, int length) async {
    if (currentPage < length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await context.read<OnboardingShowCubit>().complete();
      if (!mounted) return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = getOnboardingPages(context);
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, int>(
            builder: (context, currentPage) {
              final isLast = currentPage == pages.length - 1;

              return Stack(
                alignment: Alignment.center,
                children: [
                  // ===== PAGE VIEW =====
                  PageView.builder(
                    controller: _controller,
                    itemCount: pages.length,
                    onPageChanged: (index) {
                      context.read<OnboardingCubit>().setPage(index);
                    },
                    itemBuilder: (context, index) {
                      return OnboardPage(
                        data: pages[index],
                        currentPage: index,
                        totalPages: pages.length,
                      );
                    },
                  ),

                  // ===== SKIP BUTTON =====

                  Positioned(
                    top: 30.h,
                    left: 25.w,
                    child: GestureDetector(
                        onTap: () {
                          context.read<ThemeCubit>().toggle();
                        },
                        child: isDark
                            ? SvgPicture.asset("assets/utils/sun.svg")
                            : SvgPicture.asset("assets/utils/moon.svg")),
                  ),
                  Positioned(
                    top: 10.h,
                    right: 10.w,
                    child: Visibility(
                      visible: currentPage == 0,
                      child: TextButton(
                        onPressed: () {
                          context.read<OnboardingShowCubit>().complete();
                        },
                        child: Text(
                          l10n.skip,
                          style: AppTextStyle.onboardingSkip(context),
                        ),
                      ),
                    ),
                  ),

                  // ===== INDICATOR =====
                  Positioned(
                    bottom: AppSize.height * 0.12,
                    child: PageIndicator(
                      currentIndex: currentPage,
                      length: pages.length,
                    ),
                  ),

                  // ===== NEXT BUTTON =====
                  Positioned(
                    bottom: AppSize.height * 0.03,
                    child: SizedBox(
                      height: AppSize.height * 0.06,
                      width: 0.8.sw,
                      child: NextButton(
                        onTap: () => _nextPage(
                          context,
                          currentPage,
                          pages.length,
                        ),
                        text: isLast ? l10n.getStarted : l10n.next,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
