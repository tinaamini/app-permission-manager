import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/models/app_permission_ui.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/app_item_widget.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/presentation/utils/empty_page_widget.dart';
import 'package:permissions_app/routs/rout_name.dart';

import '../../utils/custome_dotsloader.dart';

class RiskAppListScreen extends StatelessWidget {
  final RiskLevel riskLevel;

  const RiskAppListScreen({
    super.key,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: _title(),
            ontap: () => context.pop(),
          ),
          SizedBox(height: 12.h),

          Expanded(
            child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
              builder: (context, state) {
                if (state is! AppPermissionLoaded) {
                  return const  Center(
                      child: CustomDotsLoader(
                          svgPath1:
                          'assets/utils/Property 1=1 (1).svg',
                          svgPath2: 'assets/utils/Property 1=2 (1).svg',
                          svgPath3: 'assets/utils/Property 1=3 (1).svg',
                          svgPath4:
                          'assets/utils/Property 1=4 (1).svg'));
                }

                final apps = _getAppsByRisk(state);

                if (apps.isEmpty) {
                  return const EmptyPageWidget(text: 'No applications found');
                }

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * (16 / 812),),
                  itemCount: apps.length,
                  itemBuilder: (context, index) {
                    final app = apps[index];

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * (10/812)),
                      child: GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            RouteName.appDetail,
                            extra: app,
                          );
                        },
                        child: AppItem(
                          packageName: app.packageName,
                          icon: Image.memory(
                            base64Decode(app.iconBase64),
                            width: screenWidth * 0.1,
                            height: screenHeight * 0.05,
                          ),
                          appName: app.appName,
                          permissions: app.permissions,
                          riskLevel: app.riskLevel,
                        ),
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

  String _title() {
    switch (riskLevel) {
      case RiskLevel.noRisk:
        return 'NO RISK APPS';
      case RiskLevel.lowRisk:
        return 'LOW RISK APPS';
      case RiskLevel.mediumRisk:
        return 'MEDIUM RISK APPS';
      case RiskLevel.highRisk:
        return 'HIGH RISK APPS';
    }
  }

  List<AppPermissionUi> _getAppsByRisk(AppPermissionLoaded state) {
    switch (riskLevel) {
      case RiskLevel.noRisk:
        return state.noRisk;
      case RiskLevel.lowRisk:
        return state.lowRisk;
      case RiskLevel.mediumRisk:
        return state.mediumRisk;
      case RiskLevel.highRisk:
        return state.highRisk;
    }
  }
}