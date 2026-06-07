import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/generated/app_localizations.dart';

class OnboardingData {
  final String title;
  final String description;
  final String svg;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.svg,
    required this.color,
  });
}

// لیست صفحات Onboarding با Localization
List<OnboardingData> getOnboardingPages(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return [
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