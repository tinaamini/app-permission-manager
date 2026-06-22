import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/utils/app_size.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (AppSize.width * 0.9).clamp(280.0, 520.0),
        maxHeight: (AppSize.height * 0.75).clamp(260.0, 700.0),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.width * 0.05,
          vertical: AppSize.height * 0.02,
        ),
        decoration: BoxDecoration(
          color:context.isDark? AppColor.bcGround:AppColor.btnLight,
          borderRadius: BorderRadius.circular(AppSize.width * 0.05),

        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: AppSize.width * 0.15,
                height: AppSize.width * 0.15,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.security_rounded,
                  color: Colors.orange,
                  size: AppSize.width * 0.085,
                ),
              ),
              SizedBox(height: AppSize.height * 0.02),

              Text(
                l10n.securityOverview,
                style: TextStyle(
                  color: context.isDark?Colors.white:AppColor.black,
                  fontSize: AppSize.width * 0.04,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppSize.height * 0.01),

              Text(
                l10n.securityOverviewDesc,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.isDark?Colors.white70:AppColor.btnOnboardingDark,
                  fontSize: AppSize.width * 0.03,
                  height: 1.5,
                ),
              ),

              SizedBox(height: AppSize.height * 0.025),

              _RiskLevelItem(
                icon: Icons.check_circle_outline,
                title: l10n.lowRisk,
                description: l10n.lowRiskDesc,
                color: Colors.green,
              ),
              _RiskLevelItem(
                icon: Icons.remove_circle_outline,
                title: l10n.mediumRisk,
                description: l10n.mediumRiskDesc,
                color: Colors.orange,
              ),
              _RiskLevelItem(
                icon: Icons.warning_amber_rounded,
                title: l10n.highRisk,
                description: l10n.highRiskDesc,
                color: Colors.redAccent,
              ),

              SizedBox(height: AppSize.height * 0.02),

              Container(
                padding: EdgeInsets.all(AppSize.width * 0.035),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha:context.isDark? 0.25:0.1),
                  borderRadius: BorderRadius.circular(AppSize.width * 0.035),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: Colors.lightBlueAccent,
                      size: AppSize.width * 0.055,
                    ),
                    SizedBox(width: AppSize.width * 0.025),
                    Expanded(
                      child: Text(
                        l10n.reduceRiskTip,
                        style: TextStyle(
                          color:context.isDark? Colors.white70:AppColor.btnOnboardingDark,
                          fontSize: AppSize.width * 0.03,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSize.height * 0.015),
            ],
          ),
        ),
      ),
    );
  }
}

class _RiskLevelItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _RiskLevelItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.height * 0.012),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSize.width * 0.055),
          SizedBox(width: AppSize.width * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: AppSize.width * 0.032,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color:context.isDark? Colors.white60:AppColor.btnOnboardingDark,
                    fontSize: AppSize.width * 0.028,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}