import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/core/servises/app_permission_service.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/presentation/special_permissions/widget/helper_widgets.dart';

class BatteryOptimizationDetail extends StatelessWidget {
  const BatteryOptimizationDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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

          actionButton(
            text: 'Open Battery Optimization Settings',
            onTap: () {
              AppSpecialPermissionPlatform().openBatteryOptimizationSettings();
            },
          ),
        ],
      ),
    );
  }
}
