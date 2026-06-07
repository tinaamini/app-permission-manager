import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/generated/app_localizations.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

Widget sectionTitle(String text,BuildContext context) {
  return Text(text, style: AppTextStyle.trustTitle(context));
}

Widget paragraph(String text,BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(top: AppSize.height * 0.01),
    child: Text(
      text,
      style: AppTextStyle.trustDescription(context).copyWith(color: AppColor.green2),
    ),
  );
}

Widget riskBadge(BuildContext context,{required RiskLevel level,}) {
  late Color color;
  late String label;
  final l10n=AppLocalizations.of(context)!;

  switch (level) {
    case RiskLevel.highRisk:
      color = Colors.red;
      label = l10n.actionNeeded;
      break;
    case RiskLevel.mediumRisk:
      color = Colors.orange;
      label = l10n.review;
      break;
    case RiskLevel.lowRisk:
      color = Colors.green;
      label = l10n.low;
      break;
    case RiskLevel.noRisk:
      color = Colors.blue;
      label = l10n.secure;
      break;
  }

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: AppSize.width * 0.03,
      vertical: AppSize.height * 0.008,
    ),
    decoration: BoxDecoration(
      color: color.withAlpha(38),
      borderRadius: BorderRadius.circular(AppSize.width * 0.05),
    ),
    child: Text(
      label,
      style: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
        fontSize: AppSize.width * 0.03,
      ),
    ),
  );
}

Widget actionButton({
  required String text,
  required VoidCallback onTap,
}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColor.CartDark,
        padding: EdgeInsets.symmetric(vertical: AppSize.height * 0.018),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.width * 0.03),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppSize.width * 0.035,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    ),
  );
}