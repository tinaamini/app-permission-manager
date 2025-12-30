import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/screen/home/btn_home_widget.dart';
import 'package:permissions_app/presentation/widget/app_bar.dart';
import 'package:permissions_app/routs/rout_name.dart';

import 'widgets/btn_permission_widget.dart';

class AppPermissionScreen extends StatelessWidget {
  const AppPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BcGround,
      body: SafeArea(child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
          builder: (context, state) {
        if (state is! AppPermissionLoaded) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        return Column(children: [
          AppBarWidget(
            text: "APP PERMISSION",
            ontap: () {
              context.pop();
            },
            width: 80,
          ),
          SizedBox(
            height: 15.w,
          ),

          /// NO RISK

          BtnPermissionWidget(
            ontap: () {
              context.pushNamed(
                RouteName.riskApps,
                extra: RiskLevel.noRisk,
              );
            },
            image: 'assets/app_permission/noRisk.png',
            text: 'No Risk Apps',
            integer: state.noRisk.length.toString(),
            color: Colors.blue,
          ),
          SizedBox(
            height: 15.w,
          ),

          /// LOW RISK

          BtnPermissionWidget(
            ontap: () {
              context.pushNamed(
                RouteName.riskApps,
                extra: RiskLevel.lowRisk,
              );
            },
            image: 'assets/app_permission/lowRisk.png',
            text: 'Low Risk Apps',
            integer: state.lowRisk.length.toString(),
            color: Colors.green,
          ),
          SizedBox(
            height: 15.w,
          ),

          /// MEDIUM RISK

          BtnPermissionWidget(
            ontap: () {
              context.pushNamed(
                RouteName.riskApps,
                extra: RiskLevel.mediumRisk,
              );
            },
            image: 'assets/app_permission/mediumRisk.png',
            text: 'Medium Risk Apps',
            integer: state.mediumRisk.length.toString(),
            color: Colors.orange,
          ),
          SizedBox(
            height: 15.w,
          ),

          /// HIGH RISK

          BtnPermissionWidget(
            ontap: () {

              context.pushNamed(
                RouteName.riskApps,
                extra: RiskLevel.highRisk,
              );
            },
            image: 'assets/app_permission/highRisk.png',
            text: 'High Risk Apps',
            integer: state.highRisk.length.toString(),
            color: Colors.red,
          ),
          SizedBox(
            height: 35.w,
          ),

          Padding(
            padding:  EdgeInsets.only(left: 20.w),
            child: Row(
              children: [
                BtnHomeWidget(image: 'assets/app_permission/keep.png', text: 'Keep Apps', ontap: () {  },),
                SizedBox(width: 20.w,),
                BtnHomeWidget(image: 'assets/app_permission/recent.png', text: 'Recent Apps', ontap: () {  },)
              ],
            ),
          )
        ]);
      })),
    );
  }
}
