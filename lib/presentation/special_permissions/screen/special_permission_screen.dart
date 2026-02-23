import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/constant/specialPermissionType.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/logic/special_permission/pecial_permission_state.dart';
import 'package:permissions_app/logic/special_permission/special_permission_cubit.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/special_permissions/widget/btn_special_permission.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/presentation/utils/risk_color.dart';
import 'package:permissions_app/routs/rout_name.dart';

class SpecialPermissionScreen extends StatefulWidget {
  const SpecialPermissionScreen({super.key});

  @override
  State<SpecialPermissionScreen> createState() => _SpecialPermissionScreenState();
}

class _SpecialPermissionScreenState extends State<SpecialPermissionScreen>with WidgetsBindingObserver  {

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
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return  BaseScreen(
      child: BlocBuilder<SpecialPermissionCubit, SpecialPermissionState>(
              builder: (context, state) {
                if (state.loading) {
                  return const SizedBox.shrink();
                }

                final percent = state.riskPercent;
                final riskLevel =
                riskLevelFromPercent(state.riskPercent);
                return Column(
                  children: [
                    AppBarWidget(
                      text: "SPECIAL PERMISSIONS",
                      ontap: () => context.pop(),
                    ),

                    SizedBox(height: 23.h),

                    Container(

                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            Text(
                                "High-level system permissions that can affect your privacy.",
                                style: AppTextStyle.summaryValue,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,),
                            SizedBox(
                              height: 20.h,
                            ),
                            FutureBuilder<bool>(
                              future: AppSpecialPermissionPlatform().checkUsageAccess(),
                              builder: (context, snapshot) {
                                // final enabled = snapshot.data ?? false;

                                return BtnSpecialPermission(
                                  image: 'assets/special_permission/usage.png',
                                  title: "Usage Data Access",
                                  text: "View app usage statistics",
                                  riskLevel: riskLevel,
                                  enabled: state.usageAccess,
                                  ontap: () {
                                    context.pushNamed(
                                      RouteName.specialPermissionDetail,
                                      extra: SpecialPermissionType.usageAccess,
                                    );
                                  },
                                );
                              },
                            ),

                            SizedBox(
                              height: 20.h,
                            ),

                            FutureBuilder<bool>(
                              future: AppSpecialPermissionPlatform().checkNotificationAccess(),
                              builder: (context, snapshot) {
                                final enabled = snapshot.data ?? false;

                                return BtnSpecialPermission(
                                  image: 'assets/special_permission/notification.png',
                                  title: "Notification Access",
                                  text: "Read and monitor notifications",
                                  riskLevel: riskLevel,
                                  enabled: enabled,
                                  ontap: () {
                                    context.pushNamed(
                                      RouteName.specialPermissionDetail,
                                      extra: SpecialPermissionType.notificationAccess,
                                    );
                                  },
                                );
                              },
                            ),

                            SizedBox(
                              height: 20.h,
                            ),

                            /// Display over other apps
                            FutureBuilder<bool>(
                              future: AppSpecialPermissionPlatform().checkOverlayPermission(),
                              builder: (context, snapshot) {
                                final enabled = snapshot.data ?? false;

                                return BtnSpecialPermission(
                                  image: 'assets/special_permission/display.png',
                                  title: "Display over other apps",
                                  text: "Appear on top of other apps",
                                  riskLevel: riskLevel,
                                  enabled: enabled,
                                  ontap: () {
                                    context.pushNamed(
                                      RouteName.specialPermissionDetail,
                                      extra: SpecialPermissionType.displayOverApps,
                                    );
                                  },
                                );
                              },
                            ),

                            SizedBox(
                              height: 20.h,
                            ),

                            /// Battery Optimization
                            FutureBuilder<bool>(
                              future: AppSpecialPermissionPlatform().isIgnoringBatteryOptimizations(),
                              builder: (context, snapshot) {
                                final enabled = snapshot.data ?? false;

                                return BtnSpecialPermission(
                                  image: 'assets/special_permission/Battery.png',
                                  title: "Battery Optimization",
                                  text: "Ignore battery optimizations",
                                  riskLevel: riskLevel,
                                  enabled: enabled,
                                  ontap: () {
                                    context.pushNamed(
                                      RouteName.specialPermissionDetail,
                                      extra: SpecialPermissionType.batteryOptimization,
                                    );
                                  },
                                );
                              },
                            ),

                            SizedBox(
                              height: 20.h,
                            ),

                            /// Do Not Disturb
                            FutureBuilder<bool>(
                              future: AppSpecialPermissionPlatform().isDoNotDisturbEnabled(),
                              builder: (context, snapshot) {
                                final enabled = snapshot.data ?? false;

                                return BtnSpecialPermission(
                                  image: 'assets/special_permission/Disturb.png',
                                  title: "Do Not Disturb",
                                  text: "Control notification interruptions",
                                  riskLevel: riskLevel,
                                  enabled: enabled,
                                  ontap: () {
                                    context.pushNamed(
                                      RouteName.specialPermissionDetail,
                                      extra: SpecialPermissionType.doNotDisturb,
                                    );
                                  },
                                );
                              },
                            ),


                            SizedBox(
                              height: 20.h,
                            ),
                            Container(
                              height: 90.h,
                              width: 400.w,
                              decoration: BoxDecoration(
                                color: AppColor.warning,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8.w),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                          width: 1.w, color: AppColor.warningborder)),
                                  child: Stack(
                                    children: [
                                      Positioned(left:7.w,top: 10.h,
                                          child: Container(width: 50.w,height: 50.h,
                                              child: SvgPicture.asset('assets/main/danger.svg'))),
                                      Positioned(left:50,top: 10,
                                        child:
                                        Text("This permission allows deep access to system data.",style: AppTextStyle.warning,),

                                      )  ,
                                      Positioned(left:80,top: 30,
                                          child:
                                          Text("Only enable if you trust the app.",style: AppTextStyle.SpecialPermissiontitle,)

                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

      ),
    );
  }
}
