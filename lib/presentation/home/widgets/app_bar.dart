import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/generated/app_localizations.dart';  // ← اضافه کن

class AppBarWidget extends StatelessWidget {
  final String text;
  final VoidCallback ontap;

  const AppBarWidget({
    super.key,
    required this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool _fa(BuildContext context) =>
    Localizations.localeOf(context).languageCode == 'fa';

    return Container(
      height: screenHeight * 0.08,
      color: AppColor.CartDark,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Row(
        children: [
          GestureDetector(
            onTap: ontap,
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: AnimatedRotation(
                turns: _fa(context) ? 0.5 : 0.0, // فارسی: 180 درجه، انگلیسی: 0
                duration: const Duration(milliseconds: 300),
                child: SvgPicture.asset(
                  "assets/main/back_icon.svg",
                  width: screenWidth * 0.035,
                  height: screenHeight * 0.035,
                ),
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                text,
                style: AppTextStyle.nameApp(context),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          const SizedBox(width: 38),
        ],
      ),
    );
  }
}