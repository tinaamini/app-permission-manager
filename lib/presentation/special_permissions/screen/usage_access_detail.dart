import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/servises/app_permission_service.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/generated/app_localizations.dart';
import 'package:permissions_app/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';

class UsageAccessDetail extends StatelessWidget {
  const UsageAccessDetail({super.key});

  RiskLevel _levelFromCount(int count) {
    if (count == 0) return RiskLevel.noRisk;
    if (count <= 2) return RiskLevel.mediumRisk;
    return RiskLevel.highRisk;
  }

  @override
  Widget build(BuildContext context) {
    final l10n=AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.all(AppSize.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle(l10n.usageAccessTitle2,context),
          paragraph(
         l10n.usageAccessDesc,context
          ),
          SizedBox(height: AppSize.height * 0.02),

          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: AppSpecialPermissionPlatform().getUsageAccessApps(),
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
                final level = _levelFromCount(apps.length);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    riskBadge(level: level,context),
                    SizedBox(height: AppSize.height * 0.03),

                    sectionTitle(l10n.appsWithUsageAccessTitle,context),
                    SizedBox(height: AppSize.height * 0.015),

                    Expanded(
                      child: apps.isEmpty
                          ? Center(
                        child: Text(
                         l10n.noUsageAccessApps,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: AppSize.width * 0.035,
                          ),
                          textAlign: TextAlign.center,
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
                              Icons.apps,
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
                              Icons.settings_outlined,
                              color: AppColor.summary,
                              size: 30,
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
          ),
        ],
      ),
    );
  }
}