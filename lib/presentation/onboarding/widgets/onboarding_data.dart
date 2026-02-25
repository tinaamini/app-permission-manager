import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';

class OnboardingData {
  final String title;
  final String description;
  final String svg;
  final Color color;

  OnboardingData({
    required this.title,
    required this.description,
    required this.svg, required this.color
  });
}
final onboardingPages = [
  OnboardingData(
    title: "No Creepy \n Stuff",
    description:
    "Your privacy is sacred. We never read your messages,\n record your screen, or listen to your audio — ever.",
    svg: 'assets/utils/eye.svg',
    color: AppColor.blue1,
  ),
  OnboardingData(
    title: "Zero Ads \n Tracking",
    description:
    "No hidden trackers. No data selling.\n What you do on your device stays with you.",
    svg: 'assets/utils/shield-search.svg',
    color: AppColor.red,
  ),
  OnboardingData(
    title: "Private by \n Design",
    description:
    "Smart analysis happens right on your device.\n We only ask for access when you choose to use a feature.",
    svg: 'assets/utils/lock.svg',
    color: AppColor.green1,
  )
];
// final onboardingPages = [
//   OnboardingData(
//     title: "Complete \n Transparency",
//     description:
//     "We scan every app on your device \n to reveal exactly what data they're accessing \n  behind the scenes.",
//    svg: 'assets/utils/eye.svg',
//     color: AppColor.blue1,
//   ),
//   OnboardingData(
//     title: "Risk \nIntelligence",
//     description:
//     "Our AI categorizes apps into risk levels,\n helping you identify threats before they \n compromise your privacy.",
//       svg: 'assets/utils/shield-search.svg',
//     color: AppColor.red
//
//   ),
//   OnboardingData(
//     title: "Take \n Control",
//     description:
//     "Easily whitelist trusted apps or remove \n permissions from suspicious ones with a\n  single tap.",
//       svg: 'assets/utils/lock.svg',
//       color: AppColor.green1
//
//   )
// ];
