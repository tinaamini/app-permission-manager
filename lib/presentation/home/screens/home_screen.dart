import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final topSpace =(screenHeight * 0.20).clamp(24.0, screenHeight * 0.18);
    final midSpace = (screenHeight * 0.12).clamp(12.0, screenHeight * 0.14);

    return BaseScreen(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            SizedBox(height: topSpace),


            BlocBuilder<AppPermissionCubit, AppPermissionState>(
              builder: (context, state) {
                if (state is! AppPermissionLoaded) {
                  return Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),

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
                            SizedBox(width: screenWidth *0.04),
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
                        SizedBox(height: screenHeight * 0.025),
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
                            SizedBox(width: screenWidth * 0.04),
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
