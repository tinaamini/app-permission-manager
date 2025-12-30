import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/risk_level.dart';

class RiskBadge extends StatelessWidget {
  final RiskLevel riskLevel;

  const RiskBadge({
    super.key,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    final _data = _mapRisk(riskLevel);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 6.h,
      ),
      decoration: BoxDecoration(
        color: _data.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        _data.text,
        style: TextStyle(
          color: _data.color,
          fontSize: 12.sp,
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
