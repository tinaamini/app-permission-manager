
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isKept
              ? Colors.green.withOpacity(0.15)
              : AppColor.CartDark,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isKept ? Colors.green : Colors.white12,
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
          children: [
            Icon(
              isKept ? Icons.verified_rounded : Icons.push_pin_outlined,
              color: isKept ? Colors.green : Colors.white70,
              size: 22,
            ),
            SizedBox(width: 10.w),
            Flexible(
              child: Text(
                isKept ? 'App is Kept' : 'Keep App',
                style: TextStyle(
                  color: isKept ? Colors.green : Colors.white,
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
