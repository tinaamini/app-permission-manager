import 'package:flutter/material.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/core/servises/app_special_permiision_service.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/base_screen.dart';

class BatteryOptimizationDetail extends StatelessWidget {
  const BatteryOptimizationDetail({super.key});

  RiskLevel _levelFromIgnoring(bool ignoring) {
    return ignoring ? RiskLevel.mediumRisk : RiskLevel.noRisk;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      child: Padding(
        padding: EdgeInsets.all(AppSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sectionTitle(l10n.batteryOptimization,context),
            paragraph(l10n.batteryOptimizationDesc,context),

            SizedBox(height: AppSize.height * 0.02),

            FutureBuilder<bool>(
              future: AppSpecialPermissionPlatform().isIgnoringBatteryOptimizations(),
              builder: (context, snapshot) {
                final ignoring = snapshot.data ?? false;
                return riskBadge(level: _levelFromIgnoring(ignoring),context);
              },
            ),

            SizedBox(height: AppSize.height * 0.03),

            GestureDetector(
              onTap: () {
                AppSpecialPermissionPlatform().openBatteryOptimizationSettings();
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
                    l10n.openBatteryOptimizationSettings,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.greenFont(context),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}