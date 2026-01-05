import 'package:flutter/cupertino.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/app_item_widget.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/routs/rout_name.dart';

class RiskAppListScreen extends StatelessWidget {
  final RiskLevel riskLevel;

  const RiskAppListScreen({
    super.key,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BcGround,
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              text: _title(),
              ontap: () => context.pop(),
              width: 80,
            ),
            SizedBox(height: 12.h),

            Expanded(
              child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
                builder: (context, state) {
                  if (state is! AppPermissionLoaded) {
                    return const Center(
                      child: CupertinoActivityIndicator(color: AppColor.white,),
                    );
                  }

                  final apps = _getAppsByRisk(state);

                  if (apps.isEmpty) {
                    return _emptyState();
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: apps.length,
                    separatorBuilder: (_, __) =>
                        Divider(color: Colors.white12, height: 16.h),
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      return GestureDetector(
                        onTap: () {
                          context.pushNamed(
                            RouteName.appDetail,
                            extra: app,
                          );
                        },

                        child: AppItem(
                            packageName:app.packageName
                          ,
                         icon:Image.memory(
                            base64Decode(app.iconBase64),
                            width: 40,
                            height: 40,
                          ),


                          appName: app.appName,
                          // packageName: app.packageName,
                          permissions: app.permissions,
                          riskLevel: app.riskLevel,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Helpers ----------

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

  List _getAppsByRisk(AppPermissionLoaded state) {
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

  Widget _emptyState() {
    return Center(
      child: Text(
        'No applications found',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}

