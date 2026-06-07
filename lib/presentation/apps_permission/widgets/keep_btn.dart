import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/generated/app_localizations.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

class KeepAppButton extends StatelessWidget {
  final bool isKept;
  final VoidCallback onTap;

  const KeepAppButton({
    super.key,
    required this.isKept,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(vertical: AppSize.height * 0.017),
        decoration: BoxDecoration(
          color: isKept
              ? Colors.green.withValues(alpha: 0.15)
              : AppColor.CartDark,
          borderRadius: BorderRadius.circular(AppSize.width * 0.04),
          border: Border.all(
            color: isKept ? Colors.green : Colors.white12,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: AppSize.width * 0.03,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isKept ? Icons.verified_rounded : Icons.push_pin_outlined,
              color: isKept ? Colors.green : Colors.white70,
              size: AppSize.width * 0.055,
            ),
            SizedBox(width: AppSize.width * 0.025),
            Flexible(
              child: Text(
                isKept ? l10n.appIsKept : l10n.keepApp,
                style: TextStyle(
                  color: isKept ? Colors.green : Colors.white,
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