import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/onboarding/widgets/svg_page_one.dart';
import 'package:Privio/presentation/onboarding/widgets/svg_page_three.dart';
import 'package:Privio/presentation/onboarding/widgets/svg_page_two.dart';
import 'package:flutter/material.dart';

class OnboardingData {
  final String title;
  final String description;
  final Widget? bottomWidget;
  final Widget svgWidget;

  OnboardingData({
    required this.title,
    required this.description,
    this.bottomWidget, required this.svgWidget,
  });
}

List<OnboardingData> getOnboardingPages(BuildContext context) {
  final l10n = AppLocalizations.of(context);

  return [
    OnboardingData(
      title: l10n.onboardingTitle1,
      description: l10n.onboardingDesc1,
      svgWidget: SvgPageOne()

    ),
    OnboardingData(
      title: l10n.onboardingTitle2,
      description: l10n.onboardingDesc2,
      svgWidget: SvgPageTwo()

    ),
    OnboardingData(
      title: l10n.onboardingTitle3,
      description: l10n.onboardingDesc3,
        svgWidget: SvgPageThree()


    ),
  ];
}
