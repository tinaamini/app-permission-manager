import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/logic/locale/locale_cubit.dart';
import 'package:Privio/logic/onboarding/onboarding_cubit.dart';

import 'app_size.dart';
import 'btn_language_widget.dart';

class BtnLanguageUtil extends StatelessWidget {
  const BtnLanguageUtil({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          final buttons = [
            BtnLanguageWidget(
              index: 0,
              onTap: () {
                context.read<BtnLanguageCubit>().select(0);
                context.read<LocaleCubit>().setLocale(const Locale('en'));
              },
              text: "EN",
            ),
            BtnLanguageWidget(
              index: 1,
              onTap: () {
                context.read<BtnLanguageCubit>().select(1);
                context.read<LocaleCubit>().setLocale(const Locale('fa'));
              },
              text: "FA",
            ),
          ];
          final isEnglish = locale.languageCode == 'en';

          return   Container(
            width: AppSize.width * 0.25,
            height: AppSize.height * 0.04,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.boxSh, width: 1),
              borderRadius: BorderRadius.circular(AppSize.width * 0.07),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: isEnglish ? buttons : buttons.reversed.toList(),


            ),
          );
        }
    );
  }
}
