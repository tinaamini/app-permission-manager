import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/constant/specialPermissionType.dart';
import 'package:permissions_app/core/servises/app_permission_service.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/core/utils/special_permission_risk_resolver.dart';
import 'package:permissions_app/generated/app_localizations.dart';
import 'package:permissions_app/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';
import 'package:permissions_app/presentation/utils/empty_page_widget.dart';

class NotificationAccessDetail extends StatelessWidget {
  const NotificationAccessDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.all(AppSize.width * 0.04),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: AppSpecialPermissionPlatform().getNotificationAccessApps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CustomDotsLoader(
                svgPath1: 'assets/utils/Property 1=1 (1).svg',
                svgPath2: 'assets/utils/Property 1=2 (1).svg',
                svgPath3: 'assets/utils/Property 1=3 (1).svg',
                svgPath4: 'assets/utils/Property 1=4 (1).svg',
              ),
            );
          }

          final apps = snapshot.data ?? [];

          final RiskLevel level = SpecialPermissionRiskResolver.fromCount(
            type: SpecialPermissionType.notificationAccess,
            count: apps.length,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle(l10n.whatIsNotificationAccess,context),
              paragraph(l10n.notificationAccessDesc,context),
              SizedBox(height: AppSize.height * 0.02),

              riskBadge(level: level,context),

              SizedBox(height: AppSize.height * 0.03),
              actionButton(
                text: l10n.openNotificationAccessSettings,
                onTap: () {
                  AppSpecialPermissionPlatform().openNotificationAccessSettings();
                },
              ),

              SizedBox(height: AppSize.height * 0.04),
              sectionTitle(l10n.appsWithNotificationAccess,context),
              SizedBox(height: AppSize.height * 0.015),

              Expanded(
                child: apps.isEmpty
                    ? Center(
                  child: EmptyPageWidget(
                    text: l10n.noAppsWithNotificationAccess,
                  ),
                )
                    : ListView.separated(
                  itemCount: apps.length,
                  separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white12),
                  itemBuilder: (context, index) {
                    final app = apps[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: app['icon'] != null
                          ? Image.memory(
                        base64Decode(app['icon']),
                        width: AppSize.width * 0.1,
                        height: AppSize.width * 0.1,
                      )
                          : const Icon(
                        Icons.notifications,
                        color: Colors.white54,
                      ),
                      title: Text(
                        app['name'] ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: AppSize.width * 0.035,
                        ),
                      ),
                      subtitle: Text(
                        app['package'] ?? '',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: AppSize.width * 0.03,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.open_in_new,
                        color: Colors.white54,
                        size: 20,
                      ),
                      onTap: () {
                        AppPermissionPlatform()
                            .openAppSettings(app['package']);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}