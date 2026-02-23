import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/presentation/special_permissions/widget/helper_widgets.dart';

class DisplayOverAppsDetail extends StatelessWidget {
  const DisplayOverAppsDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('Display over other apps'),
          paragraph(
            'Apps with this permission can appear on top of other apps. '
                'This can be abused for phishing or misleading overlays.',
          ),

          SizedBox(height: 16.h),

          riskBadge(high: true),

          SizedBox(height: 24.h),

          GestureDetector(
            child:
            Container(
              width:double.infinity,height: 48.h,
                decoration: BoxDecoration(
                  color: AppColor.CartDark,
                  border: Border.all(width: 1.w,color: AppColor.green1),
                  borderRadius: BorderRadius.circular(16.r)
                ),
                child: Center(child: Text( 'Open Display Over Apps Settings',   maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.greenFont,
                  textAlign: TextAlign.center,))),
            onTap: () {
              AppSpecialPermissionPlatform().openOverlaySettings();
            },
          ),

          SizedBox(height: 32.h),

          Expanded(
            child: Text(
              'Android does not allow apps to list overlay permissions directly. '
                  'To manage apps with this access, use the system settings.',style: AppTextStyle.trustDescription.copyWith(color: AppColor.green2),
            ),
          ),
        ],
      ),
    );
  }
}
