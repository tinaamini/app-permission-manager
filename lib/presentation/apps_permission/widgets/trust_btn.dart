import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isTrusted ? Colors.blueAccent.withOpacity(0.15) : AppColor.CartDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isTrusted ? Colors.blueAccent : Colors.white12,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 12,
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
                width: 16.w,
                height: 16.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              Icon(
                isTrusted ? Icons.verified_rounded : Icons.verified_outlined,
                color: isTrusted ? Colors.blueAccent : Colors.white70,
                size: 22.sp,
              ),

            SizedBox(width: 8.w),

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
                      : (isTrusted ? Colors.blueAccent : Colors.white),
                  fontSize: 14.sp,
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