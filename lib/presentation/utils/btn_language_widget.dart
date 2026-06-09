import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/logic/onboarding/onboarding_cubit.dart';

import 'app_size.dart';

class BtnLanguageWidget extends StatelessWidget {
  final VoidCallback onTap;
final int index;
final String text;
  const BtnLanguageWidget({super.key ,required this.onTap,required this.text,  required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BtnLanguageCubit, int>(
        builder: (context, selectedIndex) {
          final isSelected = index == selectedIndex;
        return GestureDetector(
            onTap: onTap,
            child: Container(
        width: AppSize.width * 0.11,
              height: AppSize.height * 0.03,

              decoration: BoxDecoration(
                color:isSelected ? AppColor.blue1:CupertinoColors.transparent,
                borderRadius: BorderRadius.circular(AppSize.width * 0.06),
              ),
              child: Center(
                child: Text(
                  text,
                  style: AppTextStyle.btnHome(context).copyWith(color:isSelected ? AppColor.white :AppColor.blue1 ),
                ),
              ),
            ));
      }
    );
  }
}
