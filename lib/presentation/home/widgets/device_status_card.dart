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
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 180.w,
        maxWidth: 240.w,
        minHeight: 200.h,
        maxHeight: 260.h,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              status.svgAsset,
              width: 100.w,
              height: 100.h,
            ),
            SizedBox(height: 16.h),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: status.color.withOpacity(0.1),
                border: Border.all(width: 1.w, color: status.color),
                borderRadius: BorderRadius.circular(61.r),
              ),
              child: Text(
                status.subtitle,
                style: AppTextStyle.System.copyWith(color: status.color),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            SizedBox(height: 16.h),

            Text(
              status.title,
              style: AppTextStyle.titleSecure,
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