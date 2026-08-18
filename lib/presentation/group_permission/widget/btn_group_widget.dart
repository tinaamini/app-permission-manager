import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
class BtnGroupWidget extends StatelessWidget {
  final String image;
  final String text;
  final int count;
  final VoidCallback ontap;

  const BtnGroupWidget({
    super.key,
    required this.image,
    required this.text,
    required this.ontap,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final formattedCount =
    NumberFormat.decimalPattern(locale.languageCode).format(count);

    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(AppSize.width * 0.03),
      child: Container(
        padding: EdgeInsets.all(AppSize.width * 0.03),
        decoration: BoxDecoration(
          color: context.isDark?AppColor.CartDark:AppColor.btnLight,
          borderRadius: BorderRadius.circular(AppSize.width * 0.03),
border: Border.all(width: context.isDark?0:1, color: AppColor.borderLight)
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: AppSize.height * 0.010,
              left: 0,
              right: 0,
              child: Center(
                child: SvgPicture.asset(
                  image,
                  width: AppSize.width * 0.1,
                  height: AppSize.width * 0.1,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              right: AppSize.width * 0.001,

              child: Container(
                width: AppSize.width * 0.075,
                height: AppSize.width * 0.075,
                decoration: BoxDecoration(
                  color:context.isDark? AppColor.CartDark:AppColor.btnCount,
                  borderRadius: BorderRadius.circular(AppSize.width * 0.02),
                ),
                child: Center(
                  child: Text(formattedCount, style: AppTextStyle.emptyPage(context)),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: AppSize.height * 0.008),
                child: Text(
                  text,
                  style: AppTextStyle.groupPermission(context),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}