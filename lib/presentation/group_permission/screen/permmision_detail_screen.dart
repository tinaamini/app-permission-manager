import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/permission_group_type.dart';
import 'package:permissions_app/core/servises/app_permission_service.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/question_dialog.dart';
import 'package:permissions_app/presentation/group_permission/widget/permission_item.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';

class PermissionDetailScreen extends StatefulWidget {

  final PermissionGroupType groupType;

  const PermissionDetailScreen({
    super.key,
    required this.groupType,

  });

  @override
  State<PermissionDetailScreen> createState() => _PermissionDetailScreenState();
}

class _PermissionDetailScreenState extends State<PermissionDetailScreen>   with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<AppPermissionCubit>().refreshAll();
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Column(
          children: [
            AppBarWidget(
              text: _title(),
              ontap: () => context.pop(),
              width: 60,
            ),

            Container(width: 400.w,height: 800.h,
              child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
                builder: (context, state) {
                  if (state is! AppPermissionLoaded) {
                    return const Center(
                      child: CupertinoActivityIndicator(
                        color: AppColor.white,
                      ),
                    );
                  }

                  final apps = _filterApps(state);

                  if (apps.isEmpty) {
                    return _emptyState();
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    itemCount: apps.length,

                    itemBuilder: (context, index) {
                      final app = apps[index];

                      return Padding(
                        padding:  EdgeInsets.symmetric(vertical: 10.w),
                        child: PermissionItem(
                          icon: Image.memory(
                            base64Decode(app.iconBase64),
                            width: 40,
                            height: 40,
                          ),
                          appName: app.appName,
                          packageName: app.packageName,
                          permissions: app.permissions,
                          enabled: true,
                          isDangerous: true,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: QuestionDialog(
                                  ontapManual: () async {
                                    if (dialogContext.canPop()) {
                                      Navigator.pop(dialogContext);
                                    }
                                    await Future.delayed(
                                      const Duration(milliseconds: 50),
                                    );
                                    await AppPermissionPlatform()
                                        .openAppSettings(app.packageName);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],

    );

  }

  // ================= Helpers =================
  String _title() {
    switch (widget.groupType) {
      case PermissionGroupType.location:
        return 'Location Permission';
      case PermissionGroupType.camera:
        return 'Camera Permission';
      case PermissionGroupType.microphone:
        return 'Microphone Permission';
      case PermissionGroupType.contacts:
        return 'Contacts Permission';
      case PermissionGroupType.sms:
        return 'SMS Permission';
      case PermissionGroupType.call:
        return 'Phone Permission';
      case PermissionGroupType.storage:
        return 'Storage Permission';
      case PermissionGroupType.calendar:
        return 'Calendar Permission';
      case PermissionGroupType.notification:
        return 'Notification Permission';
      case PermissionGroupType.activity:
        return 'Activity Permission';
    }
  }

  List<String> _permissionsByGroup() {
    switch (widget.groupType) {
      case PermissionGroupType.location:
        return [
          'android.permission.ACCESS_FINE_LOCATION',
          'android.permission.ACCESS_COARSE_LOCATION',
          'android.permission.ACCESS_BACKGROUND_LOCATION',
        ];
      case PermissionGroupType.camera:
        return ['android.permission.CAMERA'];
      case PermissionGroupType.microphone:
        return ['android.permission.RECORD_AUDIO'];
      case PermissionGroupType.contacts:
        return [
          'android.permission.READ_CONTACTS',
          'android.permission.WRITE_CONTACTS',
        ];
      case PermissionGroupType.sms:
        return [
          'android.permission.READ_SMS',
          'android.permission.SEND_SMS',
          'android.permission.RECEIVE_SMS',
        ];
      case PermissionGroupType.call:
        return [
          'android.permission.READ_PHONE_STATE',
          'android.permission.CALL_PHONE',
          'android.permission.READ_CALL_LOG',
        ];
      case PermissionGroupType.storage:
        return [
          'android.permission.READ_EXTERNAL_STORAGE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_MEDIA_IMAGES',
          'android.permission.READ_MEDIA_VIDEO',
        ];
      case PermissionGroupType.calendar:
        return [
          'android.permission.READ_CALENDAR',
          'android.permission.WRITE_CALENDAR',
        ];
      case PermissionGroupType.notification:
        return ['android.permission.POST_NOTIFICATIONS'];
      case PermissionGroupType.activity:
        return [
          'android.permission.ACTIVITY_RECOGNITION',
          'android.permission.BODY_SENSORS',
        ];
    }
  }

  List _filterApps(AppPermissionLoaded state) {
    final groupPermissions = _permissionsByGroup();

    return state.allApps.where((app) {
      return app.permissions.any(
            (p) => groupPermissions.contains(p),
      );
    }).toList();
  }

  Widget _emptyState() {
    return Center(
      child: Text(
        'No apps use this permission',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}
