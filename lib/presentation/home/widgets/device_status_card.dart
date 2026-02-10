import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/logic/risk/device_risk_status.dart';

class DeviceStatusCard  extends StatelessWidget {
  final DeviceRiskStatus status;
  const DeviceStatusCard ({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(width: 210.w,height: 226.h,
      child: Column(
        children: [
          SvgPicture.asset(
            status.svgAsset,
            width: 100.w,
            height: 100.h,
          ),
          SizedBox(height: 24.h,),
          Container(width: 108.w,height:35.h ,
            decoration: BoxDecoration(
                color: status.color.withOpacity(0.1),
              border: Border.all(
                width: 1.w,color: status.color
              ),
              borderRadius: BorderRadius.circular(61.r)
            ),
            child: Center(child: Text(status.subtitle,style: AppTextStyle.System.copyWith(color: status.color),textAlign: TextAlign.center,)),
          ),
          SizedBox(height: 24.h,),

          Text(status.title,style: AppTextStyle.titleSecure,textAlign: TextAlign.center,),
        ],
      ),
    );
  }
}
