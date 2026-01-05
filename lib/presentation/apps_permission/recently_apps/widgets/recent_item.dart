import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/app_item_widget.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/kept_badge.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/risk_circle_widget.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/trusted_badge.dart';
import 'package:permissions_app/presentation/utils/permission_ui_helper.dart';


class RecentItem extends StatelessWidget {
  final String appName;
  final String packageName;
  final Widget icon;
  final List<String> permissions;
  final RiskLevel riskLevel;
  final String formData;        // last used time (formatted)
  final String formatDuration;  // used today duration (formatted)

  const RecentItem({
    super.key,
    required this.appName,
    required this.packageName,
    required this.icon,
    required this.permissions,
    required this.riskLevel,
    required this.formData,
    required this.formatDuration,
  });

  @override
  Widget build(BuildContext context) {
    final dangerousPermissions = getDangerousPermissions(permissions);
    final riskPercent = calculateRiskPercent(permissions);

    final isTrusted = context.select<AppPermissionCubit, bool>(
          (c) => c.isAppTrusted(packageName),
    );

    final isKept = context.select<AppPermissionCubit, bool>(
          (c) => c.isAppKept(packageName),
    );

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.CartDark,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Top Row =====
          Row(
            children: [
              SizedBox(width: 44.w, height: 44.w, child: icon),
              SizedBox(width: 12.w),

              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        appName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isTrusted)
                      const TrustedBadge()
                    else if (isKept)
                      const KeptBadge(),
                  ],
                ),
              ),

              RiskCircle(
                percent: riskPercent,
                riskLevel: riskLevel,
                hasDangerousPermissions:
                dangerousPermissions.isNotEmpty,
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // ===== Usage Info =====
          Text(
            'Last used at $formData · Used today $formatDuration',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12.sp,
            ),
          ),

          SizedBox(height: 8.h),

          // ===== Permission Availability =====
          _permissionAvailability(),
        ],
      ),
    );
  }

  // ================= Permission Availability =================
  Widget _permissionAvailability() {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        // ===== Location =====
        _permChip(
          'Location',
          permissions.contains('android.permission.ACCESS_FINE_LOCATION') ||
              permissions.contains('android.permission.ACCESS_COARSE_LOCATION'),
        ),

        // ===== Background Location =====
        _permChip(
          'Background location',
          permissions.contains('android.permission.ACCESS_BACKGROUND_LOCATION'),
        ),

        // ===== Camera =====
        _permChip(
          'Camera',
          permissions.contains('android.permission.CAMERA'),
        ),

        // ===== Microphone =====
        _permChip(
          'Microphone',
          permissions.contains('android.permission.RECORD_AUDIO'),
        ),

        // ===== Contacts =====
        _permChip(
          'Contacts',
          permissions.contains('android.permission.READ_CONTACTS') ||
              permissions.contains('android.permission.WRITE_CONTACTS'),
        ),

        // ===== SMS =====
        _permChip(
          'SMS',
          permissions.contains('android.permission.READ_SMS') ||
              permissions.contains('android.permission.SEND_SMS') ||
              permissions.contains('android.permission.RECEIVE_SMS'),
        ),

        // ===== Call logs =====
        _permChip(
          'Call logs',
          permissions.contains('android.permission.READ_CALL_LOG'),
        ),

        // ===== Phone =====
        _permChip(
          'Phone',
          permissions.contains('android.permission.READ_PHONE_STATE') ||
              permissions.contains('android.permission.CALL_PHONE'),
        ),

        // ===== Storage / Media =====
        _permChip(
          'Storage',
          permissions.contains('android.permission.READ_EXTERNAL_STORAGE') ||
              permissions.contains('android.permission.WRITE_EXTERNAL_STORAGE') ||
              permissions.contains('android.permission.READ_MEDIA_IMAGES') ||
              permissions.contains('android.permission.READ_MEDIA_VIDEO'),
        ),

        // ===== Calendar =====
        _permChip(
          'Calendar',
          permissions.contains('android.permission.READ_CALENDAR') ||
              permissions.contains('android.permission.WRITE_CALENDAR'),
        ),

        // ===== Bluetooth =====
        _permChip(
          'Bluetooth',
          permissions.contains('android.permission.BLUETOOTH') ||
              permissions.contains('android.permission.BLUETOOTH_CONNECT') ||
              permissions.contains('android.permission.BLUETOOTH_SCAN'),
        ),

        // ===== Notifications =====
        _permChip(
          'Notifications',
          permissions.contains('android.permission.POST_NOTIFICATIONS'),
        ),

        // ===== Sensors =====
        _permChip(
          'Sensors',
          permissions.contains('android.permission.BODY_SENSORS'),
        ),
      ],
    );
  }


  Widget _permChip(String label, bool enabled) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: enabled
            ? Colors.orange.withOpacity(0.15)
            : Colors.white12,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        enabled ? '$label enabled' : '$label disabled',
        style: TextStyle(
          color: enabled
              ? Colors.orangeAccent
              : Colors.white38,
          fontSize: 10.sp,
        ),
      ),
    );
  }
}
