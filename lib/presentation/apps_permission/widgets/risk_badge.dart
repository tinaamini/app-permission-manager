import 'package:flutter/material.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

class RiskBadge extends StatelessWidget {
  final RiskLevel riskLevel;

  const RiskBadge({
    super.key,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    final data = _mapRisk(riskLevel);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width * 0.035,
        vertical: AppSize.height * 0.007,
      ),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(
          AppSize.width * 0.05,
        ),
      ),
      child: Text(
        data.text,
        style: TextStyle(
          color: data.color,
          fontSize: AppSize.width * 0.03,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  _RiskData _mapRisk(RiskLevel level) {
    switch (level) {
      case RiskLevel.noRisk:
        return _RiskData('SAFE', Colors.blue);
      case RiskLevel.lowRisk:
        return _RiskData('LOW RISK', Colors.green);
      case RiskLevel.mediumRisk:
        return _RiskData('MEDIUM RISK', Colors.orange);
      case RiskLevel.highRisk:
        return _RiskData('HIGH RISK', Colors.red);
    }
  }
}

class _RiskData {
  final String text;
  final Color color;

  _RiskData(this.text, this.color);
}