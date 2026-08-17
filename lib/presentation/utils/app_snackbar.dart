import 'package:Privio/core/extensions/context_extension.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  AppSnackBar._();

  static void show(
      BuildContext context, {
        required String message,
        bool isSuccess = true,
        Color accentColor = Colors.blueAccent,
        IconData icon = Icons.verified_rounded,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(seconds: 3),
        margin: EdgeInsets.symmetric(
          horizontal: AppSize.width * 0.04,
          vertical: AppSize.height * 0.02,
        ),
        padding: EdgeInsets.zero,
        content: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.width * 0.04,
            vertical: AppSize.height * 0.017,
          ),
          decoration: BoxDecoration(
            color: isSuccess
                ? accentColor.withValues(alpha: 0.15)
                : (context.isDark ? AppColor.CartDark : AppColor.btnLight),
            borderRadius: BorderRadius.circular(AppSize.width * 0.04),
            border: Border.all(
              color: isSuccess
                  ? accentColor
                  : (context.isDark ? Colors.white12 : AppColor.borderLight),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSuccess
                    ? accentColor
                    : (context.isDark ? Colors.white70 : AppColor.CartDarkBorder),
                size: AppSize.width * 0.055,
              ),
              SizedBox(width: AppSize.width * 0.02),
              Flexible(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSuccess
                        ? accentColor
                        : (context.isDark ? Colors.white70 : AppColor.CartDarkBorder),
                    fontSize: AppSize.width * 0.035,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
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