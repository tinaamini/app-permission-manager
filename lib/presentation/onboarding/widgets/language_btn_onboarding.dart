import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/logic/locale/locale_cubit.dart';
import 'package:Privio/logic/onboarding/onboarding_cubit.dart';
import 'package:Privio/presentation/utils/app_size.dart';


class LanguageBtnOnboarding extends StatelessWidget {
  const LanguageBtnOnboarding({super.key});

  @override
  Widget build(BuildContext context) {

    return    SizedBox(
      height: AppSize.height * 0.278,
      width: AppSize.width * 0.8,

      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          languageButton(
              context,
              index: 0,
              text: "English",
              onTap: () {
                context.read<BtnLanguageCubit>().select(0);
                context.read<LocaleCubit>().setLocale(const Locale('en'));
              }
          ),
          SizedBox(height: AppSize.height * 0.02,),
          languageButton(
              context,
              index: 1,
              text: "فارسی",
              onTap: () {
                context.read<BtnLanguageCubit>().select(1);
                context.read<LocaleCubit>().setLocale(const Locale('fa'));
              }
          ),
        ],
      ),
    ) ;


  }

  Widget languageButton(BuildContext context, {
    required int index,
    required String text,
    required VoidCallback onTap,
  }) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocBuilder<BtnLanguageCubit, int>(

      builder: (context, selectedIndex) {
        final isSelected = index == selectedIndex;
        final locale=context.watch<LocaleCubit>().state;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: AppSize.width * 0.9,
            height: AppSize.height * 0.07,
            decoration: BoxDecoration(
              color:isDark? AppColor.btnOnboardingDark:AppColor.btnOnboardingLight,
              borderRadius: BorderRadius.circular(AppSize.width * 0.06),
              border: Border.all(
                color: isSelected ?AppColor.boxSh : AppColor.CartDark,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color:isSelected ?AppColor.boxSh: AppColor.CartDark ,
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: Offset.zero,
                ),
              ],            ),
            child: Padding(
              padding: EdgeInsets.only(left:locale  == Locale('en')? AppSize.width * 0.08:AppSize.width * 0.5),
              child: Row(mainAxisAlignment: locale  == Locale('en')? MainAxisAlignment.start: MainAxisAlignment.end,
                children: [
                  Container(
                    width: AppSize.width * 0.06,
                    height: AppSize.height * 0.06,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.boxSh: (isDark ?AppColor.CartDark:AppColor.boxSh.withAlpha(400)),
                      shape: BoxShape.circle,
                    ),
                    child: isSelected ? Icon(Icons.check, color: isDark? AppColor.btnOnboardingLight:AppColor.btnOnboardingDark,
                      size: AppSize.width * 0.04,) : SizedBox.shrink(),
                  ),
                  SizedBox(width: AppSize.width * 0.04,),
                  Text(text, style: AppTextStyle.onboardingDescription(context),
                  ),


                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
