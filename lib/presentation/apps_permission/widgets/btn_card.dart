import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';

class BtnCard extends StatelessWidget {
  final String image;
  final String text;
  final String count;
  final VoidCallback ontap;
  const BtnCard({
    super.key,
    required this.image,
    required this.text,
    required this.count,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return GestureDetector(
      onTap: ontap,
      child: Container(
        constraints: BoxConstraints(
          minHeight: screenHeight * 0.1,
        ),

        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.02,
        ),
        decoration: BoxDecoration(
          color:isDark? AppColor.CartDark:AppColor.btnLight,
          borderRadius: BorderRadius.circular(screenWidth * 0.06),
          border: Border.all(width: 1,color:isDark? AppColor.CartDarkBorder:AppColor.borderLight),

        ),
        child: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.006),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(image,
                width: screenWidth * 0.12,
                height: screenWidth * 0.12,),
              SizedBox(width: screenWidth * 0.025),

              Expanded(
                child: Text(
                  text,
                  style: AppTextStyle.btnHome(context).copyWith(
                    color: isDark ? AppColor.white : AppColor.black,
                  ),
                ),
              ),
              Container(
                constraints: BoxConstraints(
                  minWidth: screenWidth * 0.075,
                  minHeight: screenHeight * 0.032,
                ),
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: AppColor.boxSh.withValues(alpha: 0.30),
                  borderRadius: BorderRadius.circular(screenWidth * 0.08),
                ),
                alignment: Alignment.center,
                child: Text(
                  count,
                  maxLines: 1,
                  style: AppTextStyle.btnAppPermissionInt(context).copyWith(
                    color:AppColor.boxSh ,
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
