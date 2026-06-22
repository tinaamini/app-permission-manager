import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return Container(

      width:  screenWidth * 0.09,
      height: screenHeight * 0.07,
      decoration: BoxDecoration(

        boxShadow: [
          BoxShadow(
            color:   hasDangerousPermissions? _color().withValues(alpha: 0.18):Colors.transparent,
            blurRadius: (screenWidth + screenHeight) * 0.03,
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
          if (hasDangerousPermissions)
            Icon(
              Icons.warning_amber_rounded,
              size: screenWidth * 0.045,
              color: _color(),
            ),
        ],
      ),
    );
  }
}
