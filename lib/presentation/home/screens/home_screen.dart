import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/routs/rout.dart';
import 'package:permissions_app/routs/rout_name.dart';

import '../widgets/btn_home_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAppBar(context),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 310.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BtnHomeWidget(
                    image: 'assets/main/grid.png',
                    text: 'App Permissions',
                    ontap: () {
                      context.pushNamed(RouteName.appsPermission);
                    },
                  ),
                  BtnHomeWidget(
                    image: 'assets/main/layer.png',
                    text: 'Group Permissions',
                    ontap: () {
                      context.pushNamed(RouteName.groupPermission);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BtnHomeWidget(
                    image: 'assets/main/varning.png',
                    text: 'Special ',
                    ontap: () {
                      context.pushNamed(RouteName.specialPermission);
                    },
                  ),
                  BtnHomeWidget(
                    image: 'assets/main/chart.png',
                    text: ' Dashboard',
                    ontap: () {
                      context.pushNamed(RouteName.dashboardPermission);

                    },
                  ),
                ],
              ),
              SizedBox(
                height: 20.w,
              ),

            ],
          ),
        ),
      ],
    );
  }

  PreferredSize _buildAppBar(context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(170.h),
      child: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        backgroundColor: Color.fromRGBO(38, 38, 38, 1),
        centerTitle: true,
        leading: Container(
            width: 48.w,
            height: 40.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.w))),
            child: GestureDetector(
              // onTap:  (){_scaffoldKey.currentState?.openDrawer();},
              child: Image.asset(
                "assets/main/taj.png",
                width: 16.w,
                height: 16.w,
              ),
            )),
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 1.w),
            child: GestureDetector(
              child: Text(
                "Permission Inspector",
                style: AppTextStyle.nameApp,
              ),
            ),
          ),
        ),
        actions: [
          Image.asset(
            "assets/main/setting.png",
            width: 74.w,
            height: 74.w,
          ),
        ],
      ),
    );
  }
}
