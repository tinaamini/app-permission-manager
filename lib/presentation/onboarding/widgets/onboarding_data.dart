import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'language_btn_onboarding.dart';

class OnboardingData {
  final String title;
  final String description;
  final String svg;
  final Color color;
  final Widget? bottomWidget;

  OnboardingData({
    required this.title,
    required this.description,
    required this.svg,
    required this.color,
    this.bottomWidget,
  });
}

List<OnboardingData> getOnboardingPages(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

  return [
    OnboardingData(
      title: l10n.onboardingTitle4,
      description: l10n.onboardingDesc4,
      svg: 'assets/utils/global.svg',
      color:isDark? AppColor.yellow:AppColor.shadowSvgPageOne,
      bottomWidget: LanguageBtnOnboarding(),
    ),

    OnboardingData(
      title: l10n.onboardingTitle1,
      description: l10n.onboardingDesc1,
      svg: 'assets/utils/eye.svg',
      color: AppColor.blue1,
    ),
    OnboardingData(
      title: l10n.onboardingTitle2,
      description: l10n.onboardingDesc2,
      svg: 'assets/utils/shield-search.svg',
      color: AppColor.red,
    ),
    OnboardingData(
      title: l10n.onboardingTitle3,
      description: l10n.onboardingDesc3,
      svg: 'assets/utils/lock.svg',
      color: AppColor.green1,
    ),
  ];
}