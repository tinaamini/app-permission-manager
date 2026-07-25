import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
    final height = MediaQuery.of(context).size.height;
    final isFa = Localizations.localeOf(context).languageCode == 'fa';
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final padding = 10.w;
    final appBarHeight = (height * 0.09).clamp(80.0, 96.0).toDouble();
    const sideWidth = 112.0;

    final back = Semantics(
      button: true,
      label: 'Back',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: ontap,
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: AnimatedRotation(
              turns: isFa ? 0.5 : 0,
              duration: const Duration(milliseconds: 700),
              child: SvgPicture.asset(
                'assets/main/back_icon.svg',
                width: 34,
                height: 34,
              ),
            ),
          ),
        ),
      ),
    );

    final home = Semantics(
      button: true,
      label: 'Home',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => context.goNamed(RouteName.home),
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: SvgPicture.asset(
              'assets/utils/home_green_icon.svg',
              width: 32,
              height: 32,
              colorFilter: ColorFilter.mode(
                isDark ? Colors.white70 : AppColor.textLight,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );

    final leftGroup = isFa
        ? (showHome ? home : const SizedBox.shrink())
        : (showBack ? back : const SizedBox.shrink());
    final rightGroup = isFa
        ? (showBack ? back : const SizedBox.shrink())
        : (showHome ? home : const SizedBox.shrink());

    return Container(
      height: appBarHeight,
      color: isDark ? AppColor.CartDark : AppColor.btnLight,
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Row(
              textDirection: TextDirection.ltr,
              children: [
                SizedBox(
                  width: sideWidth,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: leftGroup,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: sideWidth,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: rightGroup,
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            left: sideWidth,
            right: sideWidth,
            child: IgnorePointer(
              child: Center(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.nameApp(context).copyWith(
                    color: isDark ? AppColor.white : AppColor.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
