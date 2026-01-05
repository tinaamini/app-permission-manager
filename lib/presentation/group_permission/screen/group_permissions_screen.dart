import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/permission_group_type.dart';
import 'package:permissions_app/presentation/group_permission/widget/btn_group_widget.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/routs/rout_name.dart';

class GroupPermissionsScreen extends StatelessWidget {
  const GroupPermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColor.BcGround,
      body: SafeArea(
        child: Column(
        children: [
          AppBarWidget(text: "GROUP PERMISSION", ontap: (){
            context.pop();
          }, width: 60),
          Padding(
            padding:  EdgeInsets.only(top: 20.w),
            child: Container(width: 400.w,height: 800.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16.h,
                  crossAxisSpacing:16.w,
                  childAspectRatio: 0.7,
                  children: [
                    BtnGroupWidget(
                      image: 'assets/group_permission/location.png',
                      text: 'Location',
                      ontap: () {
                        context.pushNamed(
                          RouteName.permissionDetail,
                          extra: PermissionGroupType.location,
                        );                      },
                    ),
                    BtnGroupWidget(
                      image: 'assets/group_permission/camera.png',
                      text: 'Camera',
                      ontap: () {
                        context.pushNamed(
                          RouteName.permissionDetail,
                          extra: PermissionGroupType.camera,
                        );
                      },
                    ),
                    BtnGroupWidget(
                      image: 'assets/group_permission/microphone.png',
                      text: 'Microphone',
                      ontap: () {
                        context.pushNamed(
                          RouteName.permissionDetail,
                          extra: PermissionGroupType.microphone,
                        );
                      },
                    ),
                    BtnGroupWidget(
                      image: 'assets/group_permission/contacts.png',
                      text: 'Contacts',
                      ontap: () {
                        context.pushNamed(
                          RouteName.permissionDetail,
                          extra: PermissionGroupType.contacts,
                        );
                      },
                    ),
                    BtnGroupWidget(
                      image: 'assets/group_permission/sms.png',
                      text: 'SMS',
                      ontap: () {
                        context.pushNamed(
                          RouteName.permissionDetail,
                          extra: PermissionGroupType.sms,
                        );
                      },
                    ),
                    BtnGroupWidget(
                      image: 'assets/group_permission/call.png',
                      text: 'call',
                      ontap: () {
                        context.pushNamed(
                          RouteName.permissionDetail,
                          extra: PermissionGroupType.call,
                        );
                      },
                    ),
                    BtnGroupWidget(
                      image: 'assets/group_permission/files.png',
                      text: 'Storage',
                      ontap: () {
                        context.pushNamed(
                          RouteName.permissionDetail,
                          extra: PermissionGroupType.storage,
                        );
                      },
                    ),
                    BtnGroupWidget(
                      image: 'assets/group_permission/calendar.png',
                      text: 'Calendar',
                      ontap: () {
                        context.pushNamed(
                          RouteName.permissionDetail,
                          extra: PermissionGroupType.calendar,
                        );
                      },
                    ),
                    BtnGroupWidget(
                      image: 'assets/group_permission/notification.png',
                      text: 'Notifications',
                      ontap: () {
                        context.pushNamed(
                          RouteName.permissionDetail,
                          extra: PermissionGroupType.notification,
                        );
                      },
                    ),
                    BtnGroupWidget(
                      image: 'assets/group_permission/activity.png',
                      text: 'Activity',
                      ontap: () {  context.pushNamed(
                        RouteName.permissionDetail,
                        extra: PermissionGroupType.activity,
                      );},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}