
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/logic/onboarding/onboarding_cubit.dart';
import 'package:permissions_app/logic/onboarding/show_onboarding/show_onboarding_cubit.dart';
import 'package:permissions_app/presentation/onboarding/widgets/onboarding_data.dart';
import 'package:permissions_app/presentation/onboarding/widgets/onboarding_page.dart';
import 'package:permissions_app/presentation/onboarding/widgets/page_indicator.dart';
import 'package:permissions_app/routs/rout_name.dart';

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

  void _nextPage(BuildContext context, int currentPage)async {
    if (currentPage < onboardingPages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // context.replaceNamed(RouteName.home);
       await context.read<OnboardingShowCubit>().complete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Scaffold(
        body: BlocBuilder<OnboardingCubit, int>(
          builder: (context, currentPage) {
            return Stack(
              alignment: Alignment.topCenter,
              children: [
                PageView.builder(
                  controller: _controller,
                  itemCount: onboardingPages.length,
                  onPageChanged: (index) {
                    context.read<OnboardingCubit>().setPage(index);
                  },
                  itemBuilder: (context, index) {
                    return OnboardPage(
                      data: onboardingPages[index],
                      currentPage: index,
                      totalPages: onboardingPages.length,
                      onNext: () => _nextPage(context, currentPage),
                    );
                  },
                ),
                Positioned(
                  child: SafeArea(
                    child: Visibility(
                      visible: currentPage == 0,
                      child: Padding(
                        padding:  EdgeInsets.only(top: 18.h, left: 300.w),
                        child: TextButton(
                          onPressed: () {
                            // context.goNamed(RouteName.home);
                            context.read<OnboardingShowCubit>().complete();
                          },
                          child: Text(
                            "skip",
                            style: AppTextStyle.onboardingSkip
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100.w,
                  child: PageIndicator(
                    currentIndex: currentPage,
                    length: onboardingPages.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
