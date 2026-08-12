import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/utils/scan/scan_cubit.dart';
import 'package:Privio/logic/utils/scan/scan_state.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
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
    final l10n = AppLocalizations.of(context);
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;
    final hasScanned = scanState.lastScanTime != null;
    final neutralColor = isDark ? Colors.white70 : Colors.blueGrey;

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
          if (hasScanned)
            SvgPicture.asset(
              status.svgAsset,
              width: screenWidth * 0.24,
              height: screenHeight * 0.11,
            )
          else
            Semantics(
              button: true,
              label: l10n.runScan,
              child: InkWell(

                customBorder: const CircleBorder(),
                child: Container(
                  width: screenWidth * 0.24,
                  height: screenHeight * 0.11,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: neutralColor.withAlpha(24),
                    border: Border.all(color: neutralColor.withAlpha(110)),
                  ),
                  alignment: Alignment.center,
                  child:  const CustomDotsLoader(
                          svgPath1: 'assets/utils/Property 1=1 (1).svg',
                          svgPath2: 'assets/utils/Property 1=2 (1).svg',
                          svgPath3: 'assets/utils/Property 1=3 (1).svg',
                          svgPath4: 'assets/utils/Property 1=4 (1).svg',
                        )
                      // : Icon(
                      //     Icons.document_scanner_outlined,
                      //     size: 48.sp,
                      //     color: neutralColor,
                      //   ),
                ),
              ),
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
              color: (hasScanned ? status.color : neutralColor).withAlpha(26),
              border: Border.all(
                width: 1.w,
                color: hasScanned ? status.color : neutralColor,
              ),
              borderRadius: BorderRadius.circular(
                (screenWidth + screenHeight) * 0.04,
              ),
            ),
            child: Text(
              hasScanned ? status.subtitle : l10n.notScannedYet,
              style: AppTextStyle.system(context).copyWith(
                color: hasScanned ? status.color : neutralColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: AppSize.height * 0.02,
          ),
          Text(
                 status.title,

                    // : l10n.scanToStart,
            style: AppTextStyle.titleSecure(context).copyWith(
              color: isDark ? AppColor.white : AppColor.black,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: screenHeight * 0.01,
          ),
          Text(
            hasScanned
                ? '${l10n.lastScann}: ${getTimeAgo(scanState.lastScanTime!, l10n)}'
                : l10n.runScan,
            style: AppTextStyle.lastScan(context).copyWith(
              color: hasScanned ? null : AppColor.blue1,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
