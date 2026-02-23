import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';

class QuestionDialog extends StatelessWidget {
  final VoidCallback ontapManual;

  const QuestionDialog({
    super.key,
    required this.ontapManual,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (size.width * 0.9).clamp(280.0, 520.0),
        maxHeight: (size.height * 0.6).clamp(220.0, 520.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColor.BcGround,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "APP PERMISSION",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),

              Text(
                "Manual",
                style: TextStyle(
                  color: AppColor.green1,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                "You will manually navigate through the system settings to manage app permissions.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColor.green2,
                  fontSize: 12.sp,
                ),
              ),

              SizedBox(height: 20.h),

              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: ontapManual,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: AppColor.CartDark,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(width: 1.w, color: AppColor.green1),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: AppColor.green1,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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