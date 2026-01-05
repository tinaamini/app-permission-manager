import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/core/servises/usage_access_service.dart';

class UsageAccessScreen extends StatelessWidget {
  const UsageAccessScreen({super.key});

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.data_usage,
                color: Colors.blue,
                size: 34,
              ),
            ),
            SizedBox(height: 24.h),

            Text(
              "To show the apps used today, please enable Usage Access permission." , style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
              height: 1.5,
            ),
            ),
             SizedBox(height: 24.h),
            GestureDetector(
              onTap: ()async{
                await UsageAccessService.openUsageAccessSettings();

              },
              child: Container(width: 200.w,height: 50.h,
                decoration: BoxDecoration(
                  color:  AppColor.CartDark,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color:  Colors.white12,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],),
                child:  Center(child: Text('Open Usage Access Settings',style: AppTextStyle.usage,)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
