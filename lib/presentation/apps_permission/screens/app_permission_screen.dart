import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/servises/usage_access_service.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/apps_permission/recently_apps/widgets/usage_access_screen.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/btn_card.dart';
import 'package:permissions_app/presentation/home/widgets/btn_home_widget.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/routs/rout_name.dart';
import '../widgets/btn_permission_widget.dart';

class AppPermissionScreen extends StatelessWidget {
  const AppPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppPermissionCubit, AppPermissionState>(
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
            width: 100,
          ),
          SizedBox(
            height: 30.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BtnPermissionWidget(
                  ontap: () {
                    context.pushNamed(
                      RouteName.riskApps,
                      extra: RiskLevel.noRisk,
                    );
                  },
                  image: 'assets/app_permission/noRisk.svg',
                  text: 'No Risk Apps',
                  integer: state.noRisk.length.toString(),
                  color: Colors.blue,
                ),
                BtnPermissionWidget(
                  ontap: () {
                    context.pushNamed(
                      RouteName.riskApps,
                      extra: RiskLevel.lowRisk,
                    );
                  },
                  image: 'assets/app_permission/lowRisk.svg',
                  text: 'Low Risk Apps',
                  integer: state.lowRisk.length.toString(),
                  color: Colors.green,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.w,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BtnPermissionWidget(
                  ontap: () {
                    context.pushNamed(
                      RouteName.riskApps,
                      extra: RiskLevel.mediumRisk,
                    );
                  },
                  image: 'assets/app_permission/mediumRisk.svg',
                  text: 'Medium Risk Apps',
                  integer: state.mediumRisk.length.toString(),
                  color: Colors.orange,
                ),
                BtnPermissionWidget(
                  ontap: () {
                    context.pushNamed(
                      RouteName.riskApps,
                      extra: RiskLevel.highRisk,
                    );
                  },
                  image: 'assets/app_permission/highRisk.svg',
                  text: 'High Risk Apps',
                  integer: state.highRisk.length.toString(),
                  color: Colors.red,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 35.h,
          ),
          BtnCard(
            image: 'assets/app_permission/keep.svg',
            text: 'Keep Apps',
            ontap: () {
              context.pushNamed(RouteName.keepApps);
            },
          ),
          SizedBox(
            height: 25.h,
          ),
          BtnCard(
            image: 'assets/app_permission/trust.svg',
            text: 'Trust Apps',
            ontap: () {
              context.pushNamed(RouteName.trustedApps);
            },
          ),
          SizedBox(
            height: 25.h,
          ),
          BtnCard(
            image: 'assets/app_permission/recent.svg',
            text: 'Recent Apps',
            ontap: () async {
              final granted = await UsageAccessService.isUsageAccessGranted();
              if (granted) {
                context.pushNamed(
                  RouteName.recentApps,
                );
              } else {
                showDialog(
                  context: context,
                  builder: (_) => Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: UsageAccessScreen(),
                  ),
                );
                // Navigator.pop(context);

                // context.pushNamed(RouteName.usageAccess);
              }
            },
          )
        ]);
      },
    );
  }
}
