import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import 'package:Privio/constant/permission_group_type.dart';
import 'package:Privio/core/servises/app_permission_service.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:Privio/logic/app_permission/app_permission_state.dart';
import 'package:Privio/presentation/apps_permission/widgets/question_dialog.dart';
import 'package:Privio/presentation/group_permission/widget/permission_item.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/presentation/utils/empty_page_widget.dart';

class PermissionDetailScreen extends StatefulWidget {
  final PermissionGroupType groupType;

  const PermissionDetailScreen({
    super.key,
    required this.groupType,
  });

  @override
  State<PermissionDetailScreen> createState() => _PermissionDetailScreenState();
}

class _PermissionDetailScreenState extends State<PermissionDetailScreen>
    with WidgetsBindingObserver {

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
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: _title(),
            ontap: () => context.pop(),
            showBack: true,
            showHome: true,
          ),

          Expanded(
            child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
              builder: (context, state) {
                if (state is! AppPermissionLoaded) {
                  return const Center(
                    child: CustomDotsLoader(
                      svgPath1: 'assets/utils/Property 1=1 (1).svg',
                      svgPath2: 'assets/utils/Property 1=2 (1).svg',
                      svgPath3: 'assets/utils/Property 1=3 (1).svg',
                      svgPath4: 'assets/utils/Property 1=4 (1).svg',
                    ),
                  );
                }

                final apps = _filterApps(state);

                if (apps.isEmpty) {
                  return EmptyPageWidget(text: l10n.noAppsUseThisPermission);
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width * 0.04,
                    vertical: AppSize.height * 0.015,
                  ),
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSize.height * 0.012),
                      child: PermissionItem(
                        icon: Image.memory(
                          base64Decode(app.iconBase64),
                          width: AppSize.width * 0.1,
                          height: AppSize.width * 0.1,
                        ),
                        appName: app.appName,
                        packageName: app.packageName,
                        permissions: app.permissions,
                        enabled: true,
                        isDangerous: true,
                        onTap: () {
                          final hideDialog = Hive.box('app_preferences').get(
                            _hidePermissionDialogKey,
                            defaultValue: false,
                          ) as bool;
                          if (hideDialog) {
                            AppPermissionPlatform()
                                .openAppSettings(app.packageName);
                            return;
                          }
                          showDialog(
                            context: context,
                            builder: (dialogContext) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppSize.width * 0.05),
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
                                onDontShowAgainChanged: (checked) {
                                  Hive.box('app_preferences').put(
                                    _hidePermissionDialogKey,
                                    checked,
                                  );
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
      ),
    );
  }

  static const _hidePermissionDialogKey = 'hide_permission_dialog_globally';

  String _title() {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.groupType) {
      case PermissionGroupType.location:
        return l10n.locationPermission;
      case PermissionGroupType.camera:
        return l10n.cameraPermission;
      case PermissionGroupType.microphone:
        return  l10n.microphonePermission;
      case PermissionGroupType.contacts:
        return l10n.contactsPermission;
      case PermissionGroupType.sms:
        return  l10n.smsPermission;
      case PermissionGroupType.call:
        return l10n.callPermission;
      case PermissionGroupType.storage:
        return l10n.storagePermission;
      case PermissionGroupType.calendar:
        return  l10n.calendarPermission;
      case PermissionGroupType.notification:
        return l10n.notificationPermission;
      case PermissionGroupType.activity:
        return l10n.activityPermission;
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
      return app.permissions.any((p) => groupPermissions.contains(p));
    }).toList();
  }
}
