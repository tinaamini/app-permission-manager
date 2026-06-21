import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';

class BtnPermissionWidget extends StatelessWidget {
  final String image;
  final String text;
  final String integer;
  final Color color;
  final VoidCallback ontap;

  const BtnPermissionWidget(
      {super.key,
      required this.image,
      required this.text,
      required this.integer,
      required this.color,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return GestureDetector(
      onTap: ontap,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: EdgeInsets.all(screenWidth * 0.03),
          decoration: BoxDecoration(
            // color: Colors.red,
            color:isDark? AppColor.CartDark:AppColor.btnHomeLight,
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            border: Border.all(width: 1, color: color),
          ),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.025),
                 SizedBox(
                  width: screenWidth * 0.15,
                  height: screenHeight * 0.08,
                  child: Stack(children: [
                    Positioned(
                        top: screenHeight * 0.012,
                        left:  screenWidth * 0.012,
                      child: SvgPicture.asset(image)),
                    Positioned(
                        top: 0,
                        right: screenWidth *0.0001,
                        child: Container(
                          width: screenWidth * 0.07,
                          height:  screenHeight* 0.03,

                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(                            screenWidth * 0.08,
                            ),
                          ),
                          child: Center(
                              child: Text(
                            integer,
                            style: AppTextStyle.btnAppPermissionInt(context)
                                .copyWith(color: color),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )),
                        ))
                  ]),
                ),


              SizedBox(height: screenHeight * 0.018),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.015,
                ),

                child: Text(
                  text,
                  style: AppTextStyle.nameApp(context).copyWith(color:isDark? AppColor.white:AppColor.black),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
