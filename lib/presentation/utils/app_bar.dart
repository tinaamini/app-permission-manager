import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'btn_language_util.dart';

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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool _fa(BuildContext context) =>
        Localizations.localeOf(context).languageCode == 'fa';
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Container(
      height: screenHeight * 0.08,
      color: isDark ?AppColor.CartDark:AppColor.btnLight,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ontap,
            child: Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
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
          ),
          SizedBox(
            width: AppSize.width * 0.12,
          ),
          Expanded(
            child: Center(
              child: Text(
                text,
                style: AppTextStyle.nameApp(context).copyWith(color: isDark?AppColor.white:AppColor.black),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.w),
            child: BtnLanguageUtil(),
          ),
        ],
      ),
    );
  }
}
