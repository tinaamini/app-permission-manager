import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/servises/system_settings_platform.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/utils/app_size.dart';

class SystemPrivacyDashboardCard extends StatelessWidget {
  const SystemPrivacyDashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(AppSize.width * 0.035),
      decoration: BoxDecoration(
        color: context.isDark ? AppColor.CartDark : AppColor.btnLight,
        borderRadius: BorderRadius.circular(AppSize.width * 0.03),
        border: Border.all(
            color: context.isDark
                ? AppColor.CartDarkBorder
                : AppColor.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/dashboard/shield-tick.svg"),
              SizedBox(width: AppSize.width * 0.02),
              Expanded(
                child: Text(
                  l10n.systemPrivacyDashboard,
                  style: AppTextStyle.dashboardTitle(context),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.height * 0.012),
          Text(
            l10n.systemPrivacyDashboardDesc,
            style: AppTextStyle.lastScan(context).copyWith(
                color: context.isDark ? AppColor.green2 : AppColor.green4),
          ),
          SizedBox(height: AppSize.height * 0.015),
          Row(
            children: [
              Expanded(
                child: _ActionBtn(
                  text: l10n.openPrivacy,
                  onTap: () => SystemSettingsPlatform.openPrivacySettings(),
                ),
              ),
              SizedBox(width: AppSize.width * 0.025),
              Expanded(
                child: _ActionBtn(
                  text: l10n.permissionManager,
                  onTap: () => SystemSettingsPlatform.openPermissionManager(),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.height * 0.015),
          Text(l10n.ifItDoesntOpen,
              style: AppTextStyle.dashboardTitle(context).copyWith(
                color: context.isDark ? AppColor.green2 : AppColor.green4,
              )),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSize.width * 0.025),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSize.height * 0.012),
        decoration: BoxDecoration(
          color: context.isDark ? AppColor.CartDark : AppColor.btnLight,
          border: Border.all(
            width: 1,
            color: context.isDark ? AppColor.green1 : AppColor.green3,
          ),
          borderRadius: BorderRadius.circular(AppSize.width * 0.025),
        ),
        child: Center(
          child: Text(text,
              style: AppTextStyle.lastScan(context).copyWith(
                color: context.isDark ? AppColor.green1 : AppColor.green3,
              )),
        ),
      ),
    );
  }
}
