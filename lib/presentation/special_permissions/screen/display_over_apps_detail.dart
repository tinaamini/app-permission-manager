import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

class DisplayOverAppsDetail extends StatelessWidget {
  const DisplayOverAppsDetail({super.key});

  RiskLevel _overlayLevel(bool enabled) {
    return enabled ? RiskLevel.mediumRisk : RiskLevel.noRisk;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Display over other apps'),
          paragraph(
            'Apps with this permission can appear on top of other apps. '
                'This may be used for chat heads, floating tools, or overlays.',
          ),

          SizedBox(height: AppSize.height * 0.02),

          FutureBuilder<bool>(
            future: AppSpecialPermissionPlatform().checkOverlayPermission(),
            builder: (context, snapshot) {
              final enabled = snapshot.data ?? false;
              return riskBadge(level: _overlayLevel(enabled));
            },
          ),

          SizedBox(height: AppSize.height * 0.03),

          GestureDetector(
            onTap: () {
              AppSpecialPermissionPlatform().openOverlaySettings();
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
                  'Open Display Over Apps Settings',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.greenFont,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          SizedBox(height: AppSize.height * 0.04),

          Expanded(
            child: Text(
              'Android does not allow apps to list overlay permissions directly. '
                  'To review apps with this access, use the system settings.',
              style: AppTextStyle.trustDescription.copyWith(color: AppColor.green2),
            ),
          ),
        ],
      ),
    );
  }
}