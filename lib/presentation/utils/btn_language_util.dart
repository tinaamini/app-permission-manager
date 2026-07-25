import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/logic/locale/locale_cubit.dart';
import 'package:Privio/logic/onboarding/onboarding_cubit.dart';

import 'app_size.dart';
import 'btn_language_widget.dart';

class BtnLanguageUtil extends StatelessWidget {
  final bool compact;

  const BtnLanguageUtil({
    super.key,
    this.compact = false,
  });

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

          if (compact) {
            final nextLocale = isEnglish ? 'fa' : 'en';

            return Semantics(
              button: true,
              label: 'Switch language',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  final nextIndex = isEnglish ? 1 : 0;
                  context.read<BtnLanguageCubit>().select(nextIndex);
                  context.read<LocaleCubit>().setLocale(Locale(nextLocale));
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  width: 56,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColor.blue1.withOpacity(0.9),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Text(
                      isEnglish ? 'EN' : 'FA',
                      key: ValueKey(isEnglish),
                      style: const TextStyle(
                        color: AppColor.blue1,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          return Container(
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
