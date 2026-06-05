import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

class DoNotDisturbDetail extends StatelessWidget {
  const DoNotDisturbDetail({super.key});

  RiskLevel _levelFromDnd(bool enabled) {
    return enabled ? RiskLevel.lowRisk : RiskLevel.noRisk;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Do Not Disturb'),
          paragraph(
            'Do Not Disturb silences notifications and alerts. '
                'This setting affects how and when notifications are delivered.',
          ),
          SizedBox(height: AppSize.height * 0.02),

          FutureBuilder<bool>(
            future: AppSpecialPermissionPlatform().isDoNotDisturbEnabled(),
            builder: (context, snapshot) {
              final dndEnabled = snapshot.data ?? false;
              return riskBadge(level: _levelFromDnd(dndEnabled));
            },
          ),

          SizedBox(height: AppSize.height * 0.03),

          GestureDetector(
            onTap: () {
              AppSpecialPermissionPlatform().openDoNotDisturbSettings();
            },
            child: Container(
              width: double.infinity,
              height: AppSize.height * 0.06,
              decoration: BoxDecoration(
                color: AppColor.CartDark,
                border: Border.all(width: 1, color: AppColor.green1),
                borderRadius: BorderRadius.circular(AppSize.width * 0.04),
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
          ),
        ],
      ),
    );
  }
}