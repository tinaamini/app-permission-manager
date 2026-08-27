import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:Privio/constant/permission_group_type.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:Privio/logic/app_permission/app_permission_state.dart';
import 'package:Privio/presentation/group_permission/widget/btn_group_widget.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/routs/rout_name.dart';

class GroupPermissionsScreen extends StatefulWidget {
  const GroupPermissionsScreen({super.key});

  @override
  State<GroupPermissionsScreen> createState() => _GroupPermissionsScreenState();
}

class _GroupPermissionsScreenState extends State<GroupPermissionsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<AppPermissionCubit>();
      if (cubit.state is! AppPermissionLoaded) {
        cubit.loadApps();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final items = <_GroupItem>[
      _GroupItem('assets/group_permission/location.svg',
          l10n.locationPermission, PermissionGroupType.location),
      _GroupItem('assets/group_permission/camera.svg', l10n.cameraPermission,
          PermissionGroupType.camera),
      _GroupItem('assets/group_permission/microphone.svg',
          l10n.microphonePermission, PermissionGroupType.microphone),
      _GroupItem('assets/group_permission/contacts.svg',
          l10n.contactsPermission, PermissionGroupType.contacts),
      _GroupItem('assets/group_permission/sms.svg', l10n.smsPermission,
          PermissionGroupType.sms),
      _GroupItem('assets/group_permission/call.svg', l10n.callPermission,
          PermissionGroupType.call),
      _GroupItem('assets/group_permission/files.svg', l10n.storagePermission,
          PermissionGroupType.storage),
      _GroupItem('assets/group_permission/calendar.svg',
          l10n.calendarPermission, PermissionGroupType.calendar),
      _GroupItem('assets/group_permission/notification.svg',
          l10n.notificationPermission, PermissionGroupType.notification),
      _GroupItem('assets/group_permission/activity.svg',
          l10n.activityPermission, PermissionGroupType.activity),
    ];
    final w = AppSize.width;
    final crossAxisCount = w >= 900 ? 4 : (w >= 600 ? 3 : 2);

    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: l10n.groupPermission,
            ontap: () => context.pop(),
            showBack: true,
            showHome: false,
          ),
          SizedBox(height: AppSize.height * 0.015),
          Expanded(
            child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
              builder: (context, state) {
                final allApps = _extractAllApps(state);

                if (allApps == null) {
                  return const Center(
                    child: CustomDotsLoader(
                      svgPath1: 'assets/utils/Property 1=1 (1).svg',
                      svgPath2: 'assets/utils/Property 1=2 (1).svg',
                      svgPath3: 'assets/utils/Property 1=3 (1).svg',
                      svgPath4: 'assets/utils/Property 1=4 (1).svg',
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.fromLTRB(
                    AppSize.width * 0.04,
                    AppSize.height * 0.025,
                    AppSize.width * 0.04,
                    AppSize.height * 0.02,
                  ),
                  itemCount: items.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSize.width * 0.04,
                    mainAxisSpacing: AppSize.height * 0.02,
                    mainAxisExtent: AppSize.height * 0.14,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];

                    final count = _countAppsForGroup(
                      allApps: allApps,
                      groupType: item.type,
                    );

                    return BtnGroupWidget(
                      image: item.image,
                      text: item.title,
                      count: count,
                      ontap: () {
                        context.pushNamed(
                          RouteName.permissionDetail,
                          extra: item.type,
                        );
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

  List<dynamic>? _extractAllApps(AppPermissionState state) {
    if (state is! AppPermissionLoaded) return null;

    return [
      ...state.noRisk,
      ...state.lowRisk,
      ...state.mediumRisk,
      ...state.highRisk,
    ];
  }

  int _countAppsForGroup({
    required List<dynamic> allApps,
    required PermissionGroupType groupType,
  }) {
    final groupPermissions = _permissionsByGroup(groupType).toSet();

    return allApps.where((app) {
      final List perms = app.permissions;
      return perms.any((p) => groupPermissions.contains(p));
    }).length;
  }

  List<String> _permissionsByGroup(PermissionGroupType type) {
    switch (type) {
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
}

class _GroupItem {
  final String image;
  final String title;
  final PermissionGroupType type;

  const _GroupItem(this.image, this.title, this.type);
}
