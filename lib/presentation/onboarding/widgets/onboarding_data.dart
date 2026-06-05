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
    title: "Complete \n Transparency",
    description:"We scan every app on your device to\n reveal exactly what data they're accessing \n behind the scenes.",

    svg: 'assets/utils/eye.svg',
    color: AppColor.blue1,
  ),
  OnboardingData(
    title: "Risk \n Intelligence",
    description:
    "Our AI categorizes apps into risk levels,\n helping you identify threats before they \n compromise your privacy.",
    svg: 'assets/utils/shield-search.svg',
    color: AppColor.red,
  ),
  OnboardingData(
    title: "Take \n Control",
    description:
    "Easily whitelist trusted apps or remove\n permissions from suspicious ones with a \n single tap.",
    svg: 'assets/utils/lock.svg',
    color: AppColor.green1,
  )
];

