import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class KeptBadge extends StatelessWidget {
  const KeptBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.only(right: 40.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 3.h),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.green, width: 0.8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.push_pin,
              size: 12,
              color: Colors.green,
            ),
            SizedBox(width: 4.w),
            Text(
              'Kept',
              style: TextStyle(
                color: Colors.green,
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
