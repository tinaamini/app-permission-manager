import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

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
                    style: AppTextStyle.specialPermission,
                  ),
                  SizedBox(height: AppSize.height * 0.005),
                  Text(
                    text,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.specialPermissiontitle,
                  ),
                ],
              ),
            ),

            SizedBox(width: AppSize.width * 0.03),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _riskBadge(),
                  SizedBox(height: AppSize.height * 0.012),
                  _statusText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _riskBadge() {
    late final Color color;
    late final String label;

    switch (riskLevel) {
      case RiskLevel.highRisk:
        color = Colors.redAccent;
        label = 'HIGH RISK';
        break;
      case RiskLevel.mediumRisk:
        color = Colors.orangeAccent;
        label = 'MEDIUM RISK';
        break;
      case RiskLevel.lowRisk:
        color = Colors.greenAccent;
        label = 'LOW RISK';
        break;
      case RiskLevel.noRisk:
        color = Colors.lightBlueAccent;
        label = 'ALL GOOD';
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
        style: AppTextStyle.specialPermission.copyWith(
          color: color,
          fontSize: AppSize.width * 0.028,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _statusText() {
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
          enabled ? 'Enabled' : 'Disabled',
          style: AppTextStyle.specialPermissiontitle.copyWith(
            color: enabled ? AppColor.summary : AppColor.white1,
            fontSize: AppSize.width * 0.03,
          ),
        ),
      ],
    );
  }
}