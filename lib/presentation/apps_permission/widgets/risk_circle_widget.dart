import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  IconData _icon() {
    switch (riskLevel) {
      case RiskLevel.noRisk:
      case RiskLevel.lowRisk:
        return Icons.check_circle;
      case RiskLevel.mediumRisk:
      case RiskLevel.highRisk:
        return Icons.warning_amber_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final shouldMoveUp =
        riskLevel == RiskLevel.lowRisk ||
            riskLevel == RiskLevel.noRisk;
    return Container(

      width: screenWidth * 0.09,
      height: screenWidth * 0.09,
      decoration: BoxDecoration(

        boxShadow: [
          BoxShadow(
            color:   hasDangerousPermissions? _color().withValues(alpha: 0.18):Colors.transparent,
            blurRadius: screenWidth * 0.06,
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
            strokeWidth: screenWidth * 0.01,
            backgroundColor:isDark? Colors.white12:Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(_color()),
          ),
          if (hasDangerousPermissions ||
              riskLevel == RiskLevel.lowRisk ||
              riskLevel == RiskLevel.noRisk)



            Padding(
              padding:EdgeInsets.only(
                bottom: shouldMoveUp ? 0.h : 5.h,
              ),
              child: Icon(
                  _icon(),
                  size: 24.w,
                  color: _color(),
                ),
            ),

        ],
      ),
    );
  }
}
