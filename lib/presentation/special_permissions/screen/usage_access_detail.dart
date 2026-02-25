import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/servises/app_permission_service.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';

class UsageAccessDetail extends StatelessWidget {
  const UsageAccessDetail({super.key});

  RiskLevel _levelFromCount(int count) {
    if (count == 0) return RiskLevel.noRisk;
    if (count <= 2) return RiskLevel.mediumRisk; // REVIEW
    return RiskLevel.highRisk; // ACTION NEEDED
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('What is Usage Data Access?'),
          paragraph(
            'Allows apps to view how often and how long other apps are used. '
                'This access can reveal sensitive behavior patterns.',
          ),
          SizedBox(height: 16.h),

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
                    riskBadge(level: level),
                    SizedBox(height: 24.h),

                    sectionTitle('Apps with Usage Access'),
                    SizedBox(height: 12.h),

                    Expanded(
                      child: apps.isEmpty
                          ? Center(
                        child: Text(
                          'No apps with usage access found',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                          : ListView.separated(
                        itemCount: apps.length,
                        separatorBuilder: (_, __) =>
                            Divider(color: Colors.white12),
                        itemBuilder: (context, index) {
                          final app = apps[index];
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: app['icon'] != null
                                ? Image.memory(
                              base64Decode(app['icon']),
                              width: 40,
                              height: 40,
                            )
                                : const Icon(
                              Icons.apps,
                              color: Colors.white54,
                            ),
                            title: Text(
                              app['name'] ?? '',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                            subtitle: Text(
                              app['package'] ?? '',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12.sp,
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