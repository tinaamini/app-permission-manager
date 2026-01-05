import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/risk_level.dart';

class RiskCircle extends StatelessWidget {
  final double percent;
  final RiskLevel riskLevel;
  final bool hasDangerousPermissions;

  const RiskCircle({
    required this.percent,
    required this.riskLevel,

    required this.hasDangerousPermissions,
  });

  Color _color() {
    switch (riskLevel) {
      case RiskLevel.highRisk:
        return Colors.red;
      case RiskLevel.mediumRisk:
        return Colors.orange;
      case RiskLevel.lowRisk:
        return Colors.green;
      case RiskLevel.noRisk:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(

        boxShadow: [
          BoxShadow(
            color:   hasDangerousPermissions?
        _color().withOpacity(0.25):Colors.transparent,
            blurRadius: 22,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percent,
            strokeWidth: 4,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation(_color()),
          ),
          if (hasDangerousPermissions)
            Icon(
              Icons.warning_amber_rounded,
              size: 18.sp,
              color: _color(),
            ),
        ],
      ),
    );
  }
}
