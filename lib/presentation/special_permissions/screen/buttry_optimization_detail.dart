import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';

class BatteryOptimizationDetail extends StatelessWidget {
  const BatteryOptimizationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle('Battery Optimization'),
            paragraph(
              'Some apps can ignore battery optimizations and continue running '
                  'in the background, which may increase battery usage.',
            ),

            SizedBox(height: 16.h),

            riskBadge(high: false),

            SizedBox(height: 24.h),
            GestureDetector(
              child:
              Container(
                  width: double.infinity,height: 48.h,
                  decoration: BoxDecoration(
                      color: AppColor.CartDark,
                      border: Border.all(width: 1.w,color: AppColor.green1),
                      borderRadius: BorderRadius.circular(16.r)
                  ),
                  child: Center(child:
                  Text( 'Open Battery Optimization Settings',   maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.greenFont,
                    textAlign: TextAlign.center,))),
              onTap: () {
                AppSpecialPermissionPlatform().openBatteryOptimizationSettings();
              },
            ),

          ],
        ),
      ),
    );
  }
}
