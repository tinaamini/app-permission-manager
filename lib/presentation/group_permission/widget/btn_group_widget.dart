import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

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
    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(AppSize.width * 0.03),
      child: Container(
        padding: EdgeInsets.all(AppSize.width * 0.03),
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          borderRadius: BorderRadius.circular(AppSize.width * 0.03),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(128),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -AppSize.height * 0.022,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  image,
                  width: AppSize.width * 0.23,
                  height: AppSize.width * 0.23,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              right: AppSize.width * 0.025,
              child: Container(
                width: AppSize.width * 0.075,
                height: AppSize.width * 0.075,
                decoration: BoxDecoration(
                  color: AppColor.CartDark,
                  borderRadius: BorderRadius.circular(AppSize.width * 0.02),
                ),
                child: Center(
                  child: Text("$count", style: AppTextStyle.emptyPage),
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: AppSize.height * 0.008),
                child: Text(
                  text,
                  style: AppTextStyle.groupPermission,
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