import 'package:Privio/core/servises/scan_storage_hive.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/utils/scan/scan_cubit.dart';
import 'package:Privio/logic/utils/scan/scan_state.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/logic/risk/device_risk_status.dart';
import 'package:Privio/presentation/utils/app_size.dart';

class DeviceStatusCard extends StatelessWidget {
  final DeviceRiskStatus status;

  const DeviceStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scanState = context.watch<ScanCubit>().state;
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: screenWidth * 0.45,
        maxWidth: screenWidth * 0.60,
        minHeight: screenHeight * 0.30,
        maxHeight: screenHeight * 0.37,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            status.svgAsset,
            width: screenWidth * 0.24,
            height: screenHeight * 0.11,
          ),
          SizedBox(
            height: screenHeight * (16 / 812),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.035,
              vertical: screenHeight * 0.012,
            ),
            decoration: BoxDecoration(
              color: status.color.withAlpha(26),
              border: Border.all(width: 1.w, color: status.color),
              borderRadius: BorderRadius.circular(
                (screenWidth + screenHeight) * 0.04,
              ),
            ),
            child: Text(
              status.subtitle,
              style:
                  AppTextStyle.system(context).copyWith(color: status.color),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: AppSize.height * 0.02,
          ),
          Container(
            child: Text(
              status.title,
              style: AppTextStyle.titleSecure(context)
                  .copyWith(color: isDark ? AppColor.white : AppColor.black,),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
        Text(
          scanState.lastScanTime != null
              ? '${l10n.lastScann}: ${getTimeAgo(scanState.lastScanTime!, l10n)}'
              : l10n.notScannedYet,

            style: AppTextStyle.lastScan(context),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
