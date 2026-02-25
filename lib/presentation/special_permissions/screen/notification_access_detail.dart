import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/constant/specialPermissionType.dart';
import 'package:permissions_app/core/servises/app_permission_service.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/core/utils/special_permission_risk_resolver.dart';
import 'package:permissions_app/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';
import 'package:permissions_app/presentation/utils/empty_page_widget.dart';

class NotificationAccessDetail extends StatelessWidget {
  const NotificationAccessDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
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
              sectionTitle('What is Notification Access?'),
              paragraph(
                'Allows apps to read notifications, including messages and alerts. '
                    'This may expose sensitive information.',
              ),
              SizedBox(height: 16.h),

              riskBadge(level: level),

              SizedBox(height: 24.h),
              actionButton(
                text: 'Open Notification Access Settings',
                onTap: () {
                  AppSpecialPermissionPlatform()
                      .openNotificationAccessSettings();
                },
              ),

              SizedBox(height: 32.h),
              sectionTitle('Apps with Notification Access'),
              SizedBox(height: 12.h),

              Expanded(
                child: apps.isEmpty
                    ? Center(
                  child: EmptyPageWidget(
                    text: 'No apps with notification access found',
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
                        Icons.notifications,
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