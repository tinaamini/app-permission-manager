import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

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
              : AppColor.CartDark,
          borderRadius: BorderRadius.circular(
            AppSize.width * 0.04,
          ),
          border: Border.all(
            color: isTrusted
                ? Colors.blueAccent
                : Colors.white12,
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
                    : Colors.white70,
                size: AppSize.width * 0.055,
              ),

            SizedBox(width: AppSize.width * 0.02),

            Flexible(
              child: Text(
                isTrusting
                    ? 'Trusting...'
                    : isTrusted
                    ? 'Trusted'
                    : 'Trust App',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isTrusting
                      ? Colors.white
                      : (isTrusted
                      ? Colors.blueAccent
                      : Colors.white),
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