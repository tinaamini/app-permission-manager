import 'package:Privio/core/extensions/context_extension.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrustBtn extends StatelessWidget {
  final bool isTrusted;
  final bool isTrusting;
  final VoidCallback onTap;

  const TrustBtn({
    super.key,
    required this.isTrusted,
    required this.isTrusting,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: isTrusting ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width * 0.03,
          vertical: AppSize.height * 0.017,
        ),
        decoration: BoxDecoration(
          color: isTrusted
              ? Colors.blueAccent.withValues(alpha: 0.15)
              : (context.isDark ?AppColor.CartDark:AppColor.btnLight),
          borderRadius: BorderRadius.circular(
            AppSize.width * 0.04,
          ),
          border: Border.all(
            color: isTrusted
                ? Colors.blueAccent
                : (context.isDark ?Colors.white12:AppColor.borderLight),
            width: 1.2,
          ),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (isTrusting)
              SizedBox(
                width: AppSize.width * 0.04,
                height: AppSize.width * 0.04,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Icon(
                isTrusted
                    ? Icons.verified_rounded
                    : Icons.verified_outlined,
                color: isTrusted
                    ? Colors.blueAccent
                    : (context.isDark?Colors.white70:AppColor.CartDarkBorder),
                size: AppSize.width * 0.055,
              ),

            SizedBox(width: AppSize.width * 0.02),

            Flexible(
              child: Text(
                isTrusting
                    ? l10n.trusting
                    : isTrusted
                    ? l10n.trusted
                    : l10n.trustApp,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isTrusting
                      ? Colors.white
                      : (isTrusted
                      ? Colors.blueAccent
                      : (context.isDark?Colors.white70:AppColor.CartDarkBorder)),
                  fontSize: AppSize.width * 0.035,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}