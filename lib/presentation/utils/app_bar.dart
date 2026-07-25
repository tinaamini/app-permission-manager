import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'btn_language_util.dart';
import 'package:Privio/routs/rout_name.dart';

class AppBarWidget extends StatelessWidget {
  final String text;
  final VoidCallback ontap;
  final bool showBack;
  final bool showHome;

  const AppBarWidget({
    super.key,
    required this.text,
    required this.ontap,
    this.showBack = true,
    this.showHome = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool _fa(BuildContext context) =>
        Localizations.localeOf(context).languageCode == 'fa';
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Container(
      height: screenHeight * 0.09,
      color: isDark ? AppColor.CartDark : AppColor.btnLight,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Row(
        children: [
          if (showBack)
            GestureDetector(
              onTap: ontap,
              child: AnimatedRotation(
                turns: _fa(context) ? 0.5 : 0.0,
                duration: const Duration(milliseconds: 700),
                child: SvgPicture.asset(
                  "assets/main/back_icon.svg",
                  width: screenWidth * 0.035,
                  height: screenHeight * 0.035,
                ),
              ),
            ),
          Expanded(
            child: Center(
              child: Text(
                text,
                style: AppTextStyle.nameApp(context).copyWith(
                  color: isDark ? AppColor.white : AppColor.black,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          BtnLanguageUtil(),
          if (showHome)
            Semantics(
              button: true,
              label: 'Home',
              child: GestureDetector(
                onTap: () => context.goNamed(RouteName.home),
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: screenWidth * 0.035,
                  ),
                  child: SvgPicture.asset(
                    'assets/utils/home_green_icon.svg',
                    width: screenWidth * 0.06,
                    height: screenHeight * 0.04,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
