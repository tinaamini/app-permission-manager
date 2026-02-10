import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/specialPermissionType.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/special_permissions/screen/usage_access_detail.dart';

import 'buttry_optimization_detail.dart';
import 'display_over_apps_detail.dart';
import 'do_not_disturb_detail.dart';
import 'notification_access_detail.dart';

class SpecialPermissionDetailScreen extends StatelessWidget {
  final SpecialPermissionType type;

  const SpecialPermissionDetailScreen({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            AppBarWidget(
              text: _title(),
              ontap: () => context.pop(),
              width: 60,
            ),

            Expanded(
              child: _buildContent(context),
            ),
          ],

    );
  }

  String _title() {
    switch (type) {
      case SpecialPermissionType.usageAccess:
        return 'Usage Data Access';
      case SpecialPermissionType.notificationAccess:
        return 'Notification Access';
      case SpecialPermissionType.displayOverApps:
        return 'Display over other apps';
      case SpecialPermissionType.batteryOptimization:
        return 'Battery Optimization';
      case SpecialPermissionType.doNotDisturb:
        return 'Do Not Disturb';
    }
  }

  Widget _buildContent(BuildContext context) {
    switch (type) {
      case SpecialPermissionType.usageAccess:
        return const UsageAccessDetail();
      case SpecialPermissionType.notificationAccess:
        return const NotificationAccessDetail();
      case SpecialPermissionType.displayOverApps:
        return const DisplayOverAppsDetail();
      case SpecialPermissionType.batteryOptimization:
        return const BatteryOptimizationDetail();
      case SpecialPermissionType.doNotDisturb:
        return const DoNotDisturbDetail();
    }
  }
}
