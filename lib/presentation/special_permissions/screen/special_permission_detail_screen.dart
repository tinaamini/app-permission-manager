import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/specialPermissionType.dart';
import 'package:permissions_app/generated/app_localizations.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/special_permissions/screen/usage_access_detail.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';

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
    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: _title(context),
            ontap: () => context.pop(),
          ),

          Expanded(
            child: _buildContent(context),
          ),
        ],
      ),
    );
  }

  String _title(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    switch (type) {
      case SpecialPermissionType.usageAccess:
        return l10n.usageAccessTitle;
      case SpecialPermissionType.notificationAccess:
        return l10n.notificationAccessTitle;
      case SpecialPermissionType.displayOverApps:
        return l10n.displayOverApps;
      case SpecialPermissionType.batteryOptimization:
        return l10n.batteryOptimization;
      case SpecialPermissionType.doNotDisturb:
        return l10n.doNotDisturb;
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