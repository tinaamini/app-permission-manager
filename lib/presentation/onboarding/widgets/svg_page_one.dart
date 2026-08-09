import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SvgPageOne extends StatelessWidget {
  const SvgPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return Stack(
          children: [
            Positioned(
              top: h * 0.15,
              left: w * 0.27,
              child: SvgPicture.asset(
                isDark
                    ? "assets/utils/pageDark1.svg"
                    : "assets/utils/pageLight1.svg",
                width: w * 0.65,
                height: h * 0.45,
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: _widgetEmoji(
                            context,
                            image: isDark
                                ? 'assets/app_permission/highRisk.svg'
                                : "assets/app_permission/Frame 8 (3).svg",
                            text: l10n.highRisk,
                            integer: "8",
                            color: Colors.red,
                          ),
                        ),
                        Flexible(
                          child: _widgetEmoji(
                            context,
                            image: isDark
                                ? 'assets/app_permission/noRisk.svg'
                                : "assets/app_permission/Frame 8.svg",
                            text: l10n.noRisk,
                            integer: "50",
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SvgPicture.asset("assets/main/low.svg"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: _widgetEmoji(
                          context,
                          image: isDark
                              ? 'assets/app_permission/lowRisk.svg'
                              : "assets/app_permission/Frame 8 (1).svg",
                          text: l10n.lowRisk,
                          integer: "5",
                          color: Colors.green,
                        ),
                      ),
                      Flexible(
                        child: _widgetEmoji(
                          context,
                          image: isDark
                              ? 'assets/app_permission/mediumRisk.svg'
                              : "assets/app_permission/Frame 8 (2).svg",
                          text: l10n.mediumRisk,
                          integer: "13",
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _widgetEmoji(
      BuildContext context, {
        required String image,
        required String text,
        required String integer,
        required Color color,
      }) {
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 65.w,
          height: 63.h,
          child: Stack(children: [
            Positioned(top: 10.h, left: 12.w, child: SvgPicture.asset(image)),
            Positioned(
              top: 0,
              right: 0.w,
              child: Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Center(
                  child: Text(
                    integer,
                    style: AppTextStyle.btnAppPermissionInt(context)
                        .copyWith(color: color),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Text(
            text,
            style: AppTextStyle.nameApp(context)
                .copyWith(color: isDark ? AppColor.white : AppColor.black),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}