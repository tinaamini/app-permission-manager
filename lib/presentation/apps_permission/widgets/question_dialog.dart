import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';

class QuestionDialog extends StatelessWidget {
  final VoidCallback ontapManual;
  // final VoidCallback ontapGuided;

  const QuestionDialog({
    super.key,
    required this.ontapManual,
    // required this.ontapGuided,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "APP PERMISSION",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 12.h),

          // /// Automatic
          // Text(
          //   "Guided Mode",
          //   style: TextStyle(
          //     color: Colors.green,
          //     fontSize: 14.sp,
          //     fontWeight: FontWeight.w600,
          //   ),
          // ),
          // SizedBox(height: 6.h),
          // Text("Automatically guides you to the correct permission settings so you can review and disable risky permissions quickly.",
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Colors.white70,
          //     fontSize: 12.sp,
          //   ),
          // ),
          //
          // SizedBox(height: 16.h),

          /// Manual
          Text(
            "Manual",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "You will manually navigate through the system settings to manage app permissions.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 24.h),

          Row(
            children: [
              // Expanded(
              //   child: GestureDetector(
              //     onTap: ontapGuided,
              //     child: Container(
              //       padding: EdgeInsets.symmetric(vertical: 14.h),
              //       decoration: BoxDecoration(
              //         color: Colors.green,
              //         borderRadius: BorderRadius.circular(20.r),
              //       ),
              //       child: const Center(
              //         child: Text(
              //           "Guided Mode",
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              //
              // SizedBox(width: 12.w),

              Expanded(
                child: GestureDetector(
                  onTap: ontapManual,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: const Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
