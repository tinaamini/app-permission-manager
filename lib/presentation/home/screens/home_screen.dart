import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_color.dart';

import 'package:permissions_app/core/servises/installed_apps_service.dart';
import 'package:permissions_app/logic/risk/device_risk_resolver.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/home/widgets/device_status_card.dart';
import 'package:permissions_app/presentation/home/widgets/btn_home_widget.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';
import 'package:permissions_app/routs/rout_name.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final InstalledAppsService _appsService = InstalledAppsService();
  final DeviceRiskResolver _riskResolver = const DeviceRiskResolver();

  late final Future<int> _appsCountFuture = _appsService.fetchInstalledAppsCount();

  @override
  @override
  Widget build(BuildContext context) {

    final h = MediaQuery.of(context).size.height;

    final topSpace = (156.h).clamp(24.0, h * 0.18);
    final midSpace = (110.h).clamp(12.0, h * 0.14);

    return BaseScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        child: Column(
          children: [
            SizedBox(height: topSpace),


            BlocBuilder<AppPermissionCubit, AppPermissionState>(
              builder: (context, state) {
                if (state is! AppPermissionLoaded) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),

                    child: const  Center(
                  child: CustomDotsLoader(
                      svgPath1:
                      'assets/utils/Property 1=1 (1).svg',
                      svgPath2: 'assets/utils/Property 1=2 (1).svg',
                      svgPath3: 'assets/utils/Property 1=3 (1).svg',
                      svgPath4:
                      'assets/utils/Property 1=4 (1).svg'))
                  );
                }

                final status = _riskResolver.resolve(
                  high: state.highRisk.length,
                  medium: state.mediumRisk.length,
                  low: state.lowRisk.length,
                );

                return DeviceStatusCard(status: status);
              },
            ),
            SizedBox(height: midSpace),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FutureBuilder<int>(
                  future: _appsCountFuture,
                  builder: (context, snapshot) {
                    final countText = snapshot.hasData ? '${snapshot.data}' : '...';

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: BtnHomeWidget(
                                image: 'assets/main/grid.svg',
                                text: 'App Permissions',
                                textCount: '$countText Apps Checked',
                                ontap: () => context.pushNamed(RouteName.appsPermission),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: BtnHomeWidget(
                                image: 'assets/main/layer.svg',
                                text: 'Group Permissions',
                                textCount: '10 Categories',
                                ontap: () => context.pushNamed(RouteName.groupPermission),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            Expanded(
                              child: BtnHomeWidget(
                                image: 'assets/main/varning.svg',
                                text: 'Special',
                                textCount: '5 Sensitive Access',
                                ontap: () => context.pushNamed(RouteName.specialPermission),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: BtnHomeWidget(
                                image: 'assets/main/chart.svg',
                                text: 'Dashboard',
                                textCount: 'View States',
                                ontap: () => context.pushNamed(RouteName.dashboardPermission),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );  }}
