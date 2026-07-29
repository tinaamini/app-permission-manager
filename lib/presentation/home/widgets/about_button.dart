import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:Privio/routs/rout_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AboutButton extends StatelessWidget {
  const AboutButton();

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final isFa = Localizations.localeOf(context).languageCode == 'fa';
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final borderRadius = BorderRadius.circular(24);

    return Semantics(
      button: true,
      label: isFa ? 'درباره ما' : 'About us',
      child: Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          color: isDark ? AppColor.btnOnboardingDark : AppColor.btnLight2,
          borderRadius: borderRadius,
          border: Border.all(
            color: isDark ? AppColor.CartDarkBorder : AppColor.borderLight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => context.pushNamed(RouteName.about),
            borderRadius: borderRadius,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColor.boxSh.withValues(alpha: 0.22),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.info_outline_rounded,
                      size: 24,
                      color: AppColor.boxSh,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isFa ? 'درباره ما' : 'About us',
                    style: AppTextStyle.nameApp(context),
                  ),
                  const Spacer(),
                  Icon(
                    isRtl
                        ? Icons.chevron_right
                        : Icons.chevron_right_rounded,
                    size: 26,
                    color: isDark ? AppColor.white : AppColor.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}