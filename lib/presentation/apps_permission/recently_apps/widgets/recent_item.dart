import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:Privio/presentation/apps_permission/widgets/app_item_widget.dart';
import 'package:Privio/presentation/apps_permission/widgets/kept_badge.dart';
import 'package:Privio/presentation/apps_permission/widgets/risk_circle_widget.dart';
import 'package:Privio/presentation/apps_permission/widgets/trusted_badge.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/permission_ui_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentItem extends StatelessWidget {
  final String appName;
  final String packageName;
  final Widget icon;
  final List<String> permissions;
  final RiskLevel riskLevel;
  final String formData;
  final String formatDuration;

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
    final l10n = AppLocalizations.of(context)!;

    final isTrusted = context.select<AppPermissionCubit, bool>(
          (c) => c.isAppTrusted(packageName),
    );

    final isKept = context.select<AppPermissionCubit, bool>(
          (c) => c.isAppKept(packageName),
    );

    return Container(
      padding: EdgeInsets.all(AppSize.width * 0.03),
      decoration: BoxDecoration(
        color: context.isDark?AppColor.CartDark:AppColor.btnLight,
        borderRadius: BorderRadius.circular(AppSize.width * 0.03),
        border: Border.all(width: context.isDark ?0:1, color: AppColor.borderLight)

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: AppSize.width * 0.11,
                height: AppSize.width * 0.11,
                child: icon,
              ),
              SizedBox(width: AppSize.width * 0.03),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        appName,
                        style:AppTextStyle.appName(context),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isTrusted)
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20.w),
                        child: const TrustedBadge(),
                      )
                    else if (isKept)
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 20.w),
                        child: const KeptBadge(),
                      ),
                  ],
                ),
              ),
              RiskCircle(
                percent: riskPercent,
                riskLevel: riskLevel,
                hasDangerousPermissions: dangerousPermissions.isNotEmpty,
              ),
            ],
          ),

          SizedBox(width: AppSize.width * 0.02),

          Text(
            l10n.lastUsed(formData, formatDuration),
            style:AppTextStyle.summaryRow(context)
          ),

          SizedBox(height: AppSize.height * 0.01),

          _permissionAvailability(context, l10n),
        ],
      ),
    );
  }

  Widget _permissionAvailability(BuildContext context, AppLocalizations l10n) {
    final available = <(String, bool)>[
      (
        l10n.permLocation,
        permissions.contains('android.permission.ACCESS_FINE_LOCATION') ||
            permissions.contains('android.permission.ACCESS_COARSE_LOCATION')
      ),
      (
        l10n.permBackgroundLocation,
        permissions.contains('android.permission.ACCESS_BACKGROUND_LOCATION')
      ),
      (l10n.permCamera, permissions.contains('android.permission.CAMERA')),
      (
        l10n.permMicrophone,
        permissions.contains('android.permission.RECORD_AUDIO')
      ),
      (
        l10n.permContacts,
        permissions.contains('android.permission.READ_CONTACTS') ||
            permissions.contains('android.permission.WRITE_CONTACTS')
      ),
      (
        l10n.permSms,
        permissions.contains('android.permission.READ_SMS') ||
            permissions.contains('android.permission.SEND_SMS') ||
            permissions.contains('android.permission.RECEIVE_SMS')
      ),
      (
        l10n.permCallLogs,
        permissions.contains('android.permission.READ_CALL_LOG')
      ),
      (
        l10n.permPhone,
        permissions.contains('android.permission.READ_PHONE_STATE') ||
            permissions.contains('android.permission.CALL_PHONE')
      ),
      (
        l10n.permStorage,
        permissions.contains('android.permission.READ_EXTERNAL_STORAGE') ||
            permissions.contains('android.permission.WRITE_EXTERNAL_STORAGE') ||
            permissions.contains('android.permission.READ_MEDIA_IMAGES') ||
            permissions.contains('android.permission.READ_MEDIA_VIDEO')
      ),
      (
        l10n.permCalendar,
        permissions.contains('android.permission.READ_CALENDAR') ||
            permissions.contains('android.permission.WRITE_CALENDAR')
      ),
      (
        l10n.permBluetooth,
        permissions.contains('android.permission.BLUETOOTH') ||
            permissions.contains('android.permission.BLUETOOTH_CONNECT') ||
            permissions.contains('android.permission.BLUETOOTH_SCAN')
      ),
      (
        l10n.permNotifications,
        permissions.contains('android.permission.POST_NOTIFICATIONS')
      ),
      (
        l10n.permSensors,
        permissions.contains('android.permission.BODY_SENSORS')
      ),
    ].where((entry) => entry.$2).toList();

    if (available.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children:
          available.map((entry) => _permChip(context, entry.$1)).toList(),
    );
  }

  Widget _permChip(BuildContext context, String label) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width * 0.025,
        vertical: AppSize.height * 0.005,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSize.width * 0.05),
      ),
      child: Text(
        l10n.permEnabled(label),
        style: TextStyle(
          color: Colors.orangeAccent,
          fontSize: AppSize.width * 0.025,
        ),
      ),
    );
  }
}
