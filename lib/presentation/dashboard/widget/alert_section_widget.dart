import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/core/models/app_permission_item.dart';
import 'package:permissions_app/core/servises/dashboard_permission_service.dart';

enum AlertSeverity { info, warning, critical }

class SafeAlert {
  final AlertSeverity severity;
  final String title;
  final String description;
  final String ctaText;
  final VoidCallback onTap;

  const SafeAlert({
    required this.severity,
    required this.title,
    required this.description,
    required this.ctaText,
    required this.onTap,
  });
}

class SafeAlertSectionWidget extends StatelessWidget {
  final bool accessibilityOn;
  final List<AppPermissionItem> apps;

  const SafeAlertSectionWidget({
    super.key,
    required this.accessibilityOn,
    required this.apps,
  });

  @override
  Widget build(BuildContext context) {
    final alerts = <SafeAlert>[];

    // ✅ Accessibility alert
    if (accessibilityOn) {
      alerts.add(
        SafeAlert(
          severity: AlertSeverity.critical,
          title: 'Accessibility enabled',
          description:
          'This permission allows an app to read screen content and control interactions.',
          ctaText: 'Review in Settings',
          onTap: () => SafeDashboardPlatform.openAccessibilitySettings(),
        ),
      );
    }

    final alwaysApps = apps.where((a) => a.locationState == 'always').toList();
    if (alwaysApps.isNotEmpty) {
      final top = alwaysApps.first;
      alerts.add(
        SafeAlert(
          severity: AlertSeverity.warning,
          title: 'Location set to “Always”',
          description:
          '${top.name} can access your location even when you’re not using it.',
          ctaText: 'Review in Settings',
          onTap: () => SafeDashboardPlatform.openAppLocationSettings(top.packageName),
        ),
      );
    }

    if (alerts.isEmpty) return _EmptyAlertsState();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alerts',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12.h),
        ...alerts.map((a) => _AlertCard(alert: a)),
      ],
    );
  }
}


class _AlertCard extends StatelessWidget {
  final SafeAlert alert;

  const _AlertCard({required this.alert});

  Color get _accent {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return Colors.redAccent;
      case AlertSeverity.warning:
        return Colors.orangeAccent;
      case AlertSeverity.info:
        return Colors.blueAccent;
    }
  }

  String get _badgeText {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return 'CRITICAL';
      case AlertSeverity.warning:
        return 'WARNING';
      case AlertSeverity.info:
        return 'INFO';
    }
  }

  IconData get _icon {
    switch (alert.severity) {
      case AlertSeverity.critical:
        return Icons.error_outline;
      case AlertSeverity.warning:
        return Icons.warning_amber_rounded;
      case AlertSeverity.info:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: _accent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _accent.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon, color: _accent, size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  alert.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  _badgeText,
                  style: TextStyle(
                    color: _accent,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            alert.description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.sp,
              height: 1.35,
            ),
          ),
          SizedBox(height: 12.h),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: alert.onTap,
              style: TextButton.styleFrom(
                foregroundColor: _accent,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
              child: Text(
                alert.ctaText,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyAlertsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.verified_outlined, color: Colors.greenAccent, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'No sensitive configurations detected.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
