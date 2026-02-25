import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:permissions_app/constant/permission_group_type.dart';
import 'package:permissions_app/presentation/group_permission/widget/btn_group_widget.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/routs/rout_name.dart';

class GroupPermissionsScreen extends StatelessWidget {
  const GroupPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = <_GroupItem>[
      _GroupItem('assets/group_permission/location.png', 'Location', PermissionGroupType.location),
      _GroupItem('assets/group_permission/camera.png', 'Camera', PermissionGroupType.camera),
      _GroupItem('assets/group_permission/microphone.png', 'Microphone', PermissionGroupType.microphone),
      _GroupItem('assets/group_permission/contacts.png', 'Contacts', PermissionGroupType.contacts),
      _GroupItem('assets/group_permission/sms.png', 'SMS', PermissionGroupType.sms),
      _GroupItem('assets/group_permission/call.png', 'Call', PermissionGroupType.call),
      _GroupItem('assets/group_permission/files.png', 'Storage', PermissionGroupType.storage),
      _GroupItem('assets/group_permission/calendar.png', 'Calendar', PermissionGroupType.calendar),
      _GroupItem('assets/group_permission/notification.png', 'Notifications', PermissionGroupType.notification),
      _GroupItem('assets/group_permission/activity.png', 'Activity', PermissionGroupType.activity),
    ];

    final w = MediaQuery.of(context).size.width;

    final crossAxisCount = w >= 900 ? 4 : (w >= 600 ? 3 : 2);

    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: "GROUP PERMISSION",
            ontap: () => context.pop(),
          ),

          SizedBox(height: 12.h),

          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
              itemCount: items.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                mainAxisExtent: 115.h,
                childAspectRatio: 1.75,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                return BtnGroupWidget(
                  image: item.image,
                  text: item.title,
                  ontap: () {
                    context.pushNamed(
                      RouteName.permissionDetail,
                      extra: item.type,
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

class _GroupItem {
  final String image;
  final String title;
  final PermissionGroupType type;

  const _GroupItem(this.image, this.title, this.type);
}