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

      child: Column(
        children: [
          languageButton(
              context,
              index: 0,
              text: "English",
              onTap: () {
                context.read<BtnLanguageCubit>().select(0);
                context.read<LocaleCubit>().toggle();
              }
          ),
          SizedBox(height: AppSize.height * 0.01,),
          languageButton(
              context,
              index: 1,
              text: "فارسی",
              onTap: () {
                context.read<BtnLanguageCubit>().select(1);
                context.read<LocaleCubit>().toggle();
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
    return BlocBuilder<BtnLanguageCubit, int>(
      builder: (context, selectedIndex) {
        final isSelected = index == selectedIndex;

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: AppSize.width * 0.9,
            height: AppSize.height * 0.07,
            decoration: BoxDecoration(
              color: AppColor.CartDark,
              borderRadius: BorderRadius.circular(AppSize.width * 0.06),
              border: Border.all(
                color: isSelected ? AppColor.yellow : AppColor.CartDark,
                width: 1,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.width * 0.05),
              child: Row(mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Text(text, style: AppTextStyle.onboardingDescription(context),
                  ),
                  SizedBox(width: AppSize.width * 0.04,),
                  Container(
                    width: AppSize.width * 0.06,
                    height: AppSize.height * 0.06,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.yellow : AppColor.CartDark,
                      shape: BoxShape.circle,
                    ),
                    child: isSelected ? Icon(Icons.check, color: AppColor.BcGround,
                      size: AppSize.width * 0.04,) : SizedBox.shrink(),
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
