import 'package:flutter/material.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/utils/app_size.dart';

class BtnSpecialPermission extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  final VoidCallback ontap;
  final RiskLevel riskLevel;
  final bool enabled;

  const BtnSpecialPermission({
    super.key,
    required this.image,
    required this.title,
    required this.text,
    required this.ontap,
    required this.riskLevel,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(AppSize.width * 0.025),
      child: Container(
        padding: EdgeInsets.all(AppSize.width * 0.025),
        decoration: BoxDecoration(
          color: AppColor.CartDark,
          borderRadius: BorderRadius.circular(AppSize.width * 0.03),
          border: Border.all(width: 1, color: AppColor.CartDarkBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(89),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              image,
              width: AppSize.width * 0.175,
              height: AppSize.width * 0.175,
              fit: BoxFit.cover,
            ),

            SizedBox(width: AppSize.width * 0.03),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.specialPermission(context),
                  ),
                  SizedBox(height: AppSize.height * 0.005),
                  Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.specialPermissiontitle(context),
                  ),
                ],
              ),
            ),

            SizedBox(width: AppSize.width * 0.03),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _riskBadge(context),
                  SizedBox(height: AppSize.height * 0.012),
                  _statusText(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _riskBadge(BuildContext context) {
    late final Color color;
    late final String label;
    final l10n=AppLocalizations.of(context)!;


    switch (riskLevel) {
      case RiskLevel.highRisk:
        color = Colors.redAccent;
        label = l10n.highRisk;
        break;
      case RiskLevel.mediumRisk:
        color = Colors.orangeAccent;
        label = l10n.mediumRisk;
        break;
      case RiskLevel.lowRisk:
        color = Colors.greenAccent;
        label = l10n.lowRisk;
        break;
      case RiskLevel.noRisk:
        color = Colors.lightBlueAccent;
        label = l10n.noRisk;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width * 0.025,
        vertical: AppSize.height * 0.005,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha(38),
        borderRadius: BorderRadius.circular(AppSize.width * 0.015),
        border: Border.all(color: color, width: 0.8),
      ),
      child: Text(
        label,
        style: AppTextStyle.specialPermission(context).copyWith(
          color: color,
          fontSize: AppSize.width * 0.028,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _statusText(BuildContext context) {
    final l10n=AppLocalizations.of(context)!;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSize.width * 0.015,
          height: AppSize.width * 0.015,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled ? Colors.greenAccent : Colors.grey,
          ),
        ),
        SizedBox(width: AppSize.width * 0.015),
        Text(
          enabled ? l10n.enabled : l10n.disabled,
          style: AppTextStyle.specialPermissiontitle(context).copyWith(
            color: enabled ? AppColor.summary : AppColor.white1,
            fontSize: AppSize.width * 0.03,
          ),
        ),
      ],
    );
  }
}