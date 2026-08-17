import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              top: h * 0.14,
              left: w * 0.24,
              child: SvgPicture.asset(
                isDark
                    ? "assets/utils/pageDark1.svg"
                    : "assets/utils/pageLight1.svg",
                width: w * 0.65,
                height: w * 0.55,
              ),
            ),

            Positioned(
              top: h * 0.012,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: h * 0.012),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: _widgetEmoji(
                            context, w, h,
                            image: isDark
                                ? 'assets/app_permission/highRisk.svg'
                                : "assets/app_permission/Frame 8 (3).svg",
                            text: l10n.highRisks,
                            integer: "8",
                            color: Colors.red,
                          ),
                        ),
                        Flexible(
                          child: _widgetEmoji(
                            context, w, h,
                            image: isDark
                                ? 'assets/app_permission/noRisk.svg'
                                : "assets/app_permission/Frame 8.svg",
                            text: l10n.riskFree,
                            integer: "50",
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: h * 0.028),
                    child: SvgPicture.asset(
                      "assets/main/safe_alert.svg",
                      height: w * 0.30,
                      width: w * 0.30,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: _widgetEmoji(
                          context, w, h,
                          image: isDark
                              ? 'assets/app_permission/lowRisk.svg'
                              : "assets/app_permission/Frame 8 (1).svg",
                          text: l10n.lowRisks,
                          integer: "5",
                          color: Colors.green,
                        ),
                      ),
                      Flexible(
                        child: _widgetEmoji(
                          context, w, h,
                          image: isDark
                              ? 'assets/app_permission/mediumRisk.svg'
                              : "assets/app_permission/Frame 8 (2).svg",
                          text: l10n.mediumRisks,
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
      BuildContext context,
      double w,
      double h, {
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
          width: w * 0.19,
          height: w * 0.18,
          child: Stack(children: [
            Positioned(
              top: h * 0.03,
              right: w * 0.025,
              child: SvgPicture.asset(image),
            ),
            Positioned(
              top: 0,
              right: w * 0.015,
              child: Container(
                width: w * 0.058,
                height: w * 0.058,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(w * 0.02),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(2),
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
            ),
          ]),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.02, vertical: h * 0.01),
          child: Text(
            text,
            style: AppTextStyle.summary(context)
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