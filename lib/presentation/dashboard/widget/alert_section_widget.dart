import 'package:flutter/material.dart';
import 'package:permissions_app/core/models/app_permission_item.dart';
import 'package:permissions_app/core/servises/dashboard_permission_service.dart';
import 'package:permissions_app/generated/app_localizations.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final alerts = <SafeAlert>[];

    if (accessibilityOn) {
      alerts.add(
        SafeAlert(
          severity: AlertSeverity.critical,
          title: l10n.accessibilityEnabled,
          description: l10n.accessibilityEnabledDesc,
          ctaText: l10n.reviewInSettings,
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
          title: l10n.locationAlways,
          description: l10n.locationAlwaysDesc(top.name),
          ctaText: l10n.reviewInSettings,
          onTap: () =>
              SafeDashboardPlatform.openAppLocationSettings(top.packageName),
        ),
      );
    }

    if (alerts.isEmpty) return _EmptyAlertsState();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.alerts,
          style: TextStyle(
            fontSize: AppSize.width * 0.04,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: AppSize.height * 0.015),
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      margin: EdgeInsets.only(bottom: AppSize.height * 0.015),
      padding: EdgeInsets.all(AppSize.width * 0.035),
      decoration: BoxDecoration(
        color: _accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppSize.width * 0.03),
        border: Border.all(color: _accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_icon, color: _accent, size: AppSize.width * 0.045),
              SizedBox(width: AppSize.width * 0.02),
              Expanded(
                child: Text(
                  alert.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: AppSize.width * 0.035,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width * 0.02,
                  vertical: AppSize.height * 0.005,
                ),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSize.width * 0.2),
                ),
                child: Text(
                  _badgeText,
                  style: TextStyle(
                    color: _accent,
                    fontSize: AppSize.width * 0.025,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.height * 0.012),
          Text(
            alert.description,
            style: TextStyle(
              color: Colors.white70,
              fontSize: AppSize.width * 0.03,
              height: 1.35,
            ),
          ),
          SizedBox(height: AppSize.height * 0.015),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: alert.onTap,
              style: TextButton.styleFrom(
                foregroundColor: _accent,
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width * 0.03,
                  vertical: AppSize.height * 0.01,
                ),
              ),
              child: Text(
                alert.ctaText,
                style: TextStyle(
                  fontSize: AppSize.width * 0.03,
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(AppSize.width * 0.035),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSize.width * 0.03),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_outlined,
            color: Colors.greenAccent,
            size: AppSize.width * 0.045,
          ),
          SizedBox(width: AppSize.width * 0.025),
          Expanded(
            child: Text(
              l10n.noSensitiveConfigurationsDetected,
              style: TextStyle(
                color: Colors.white70,
                fontSize: AppSize.width * 0.03,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}