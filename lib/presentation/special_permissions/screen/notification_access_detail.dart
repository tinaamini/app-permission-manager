import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/core/servises/app_permission_service.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/presentation/special_permissions/widget/helper_widgets.dart';

class NotificationAccessDetail extends StatelessWidget {
  const NotificationAccessDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sectionTitle('What is Notification Access?'),
          paragraph(
            'Allows apps to read notifications, including messages and alerts. '
                'This may expose sensitive information.',
          ),

          SizedBox(height: 16.h),

          riskBadge(high: true),

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
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: AppSpecialPermissionPlatform()
                  .getNotificationAccessApps(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }

                final apps = snapshot.data ?? [];

                if (apps.isEmpty) {
                  return Center(
                    child: Text(
                      'No apps with notification access found',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14.sp,
                      ),
                    ),
                  );
                }

                return ListView.separated(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
