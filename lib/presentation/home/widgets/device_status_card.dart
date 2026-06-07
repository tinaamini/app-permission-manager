import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/logic/risk/device_risk_status.dart';

class DeviceStatusCard extends StatelessWidget {
  final DeviceRiskStatus status;
  const DeviceStatusCard({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: screenWidth * 0.45,
        maxWidth: screenWidth * 0.60,
        minHeight: screenHeight * 0.25,
        maxHeight: screenHeight * 0.32,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              status.svgAsset,
              width: screenWidth * 0.24,
              height: screenHeight * 0.11,
            ),
            SizedBox(  height: screenHeight * (16 / 812),
            ),

            Container(
              padding: EdgeInsets.symmetric(  horizontal: screenWidth * 0.035,
                vertical: screenHeight * 0.012,),
              decoration: BoxDecoration(
                color: status.color.withAlpha(26),
                border: Border.all(width: 1.w, color: status.color),
                borderRadius: BorderRadius.circular(
                  (screenWidth + screenHeight) * 0.04,
                ),              ),
              child: Text(
                status.subtitle,
                style: AppTextStyle.system(context).copyWith(color: status.color),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(
              height: screenHeight * 0.02,
            ),
            Text(
              status.title,
              style: AppTextStyle.titleSecure(context),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}