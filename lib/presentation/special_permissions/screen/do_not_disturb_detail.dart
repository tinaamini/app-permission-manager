import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';

import '../widget/helper_widgets.dart';

class DoNotDisturbDetail extends StatelessWidget {
  const DoNotDisturbDetail({super.key});

  RiskLevel _levelFromDnd(bool enabled) {
    return enabled ? RiskLevel.lowRisk : RiskLevel.noRisk;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Do Not Disturb'),
          paragraph(
            'Do Not Disturb silences notifications and alerts. '
                'This setting affects how and when notifications are delivered.',
          ),
          SizedBox(height: 16.h),

          FutureBuilder<bool>(
            future: AppSpecialPermissionPlatform().isDoNotDisturbEnabled(),
            builder: (context, snapshot) {
              final dndEnabled = snapshot.data ?? false;
              return riskBadge(level: _levelFromDnd(dndEnabled));
            },
          ),

          SizedBox(height: 24.h),
          GestureDetector(
            child: Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColor.CartDark,
                border: Border.all(width: 1.w, color: AppColor.green1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  'Open Do Not Disturb Settings',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.greenFont,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () {
              AppSpecialPermissionPlatform().openDoNotDisturbSettings();
            },
          ),
        ],
      ),
    );
  }
}