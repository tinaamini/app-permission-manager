import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/keep_btn.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/permission_tile.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/trust_btn.dart';
import 'package:permissions_app/presentation/utils/permission_ui_helper.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/permissionConst.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/models/app_permission_ui.dart';
import 'package:permissions_app/core/servises/app_permission_service.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/info_widget.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/question_dialog.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/risk_badge.dart';
import 'package:permissions_app/presentation//home/widgets/app_bar.dart';

class AppDetailScreen extends StatefulWidget {
  final AppPermissionUi app;

  const AppDetailScreen({
    super.key,
    required this.app,
  });

  @override
  State<AppDetailScreen> createState() => _AppDetailScreenState();
}

class _AppDetailScreenState extends State<AppDetailScreen>
    with WidgetsBindingObserver {
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
      context.read<AppPermissionCubit>().refreshApp(widget.app.packageName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppPermissionCubit, AppPermissionState>(
            listenWhen: (_, current) =>
                current is AppTrustedSuccess ||
                current is AppUntrustedSuccess ||
                current is AppKeptSuccess ||
                current is AppUnkeptSuccess,
            listener: (context, state) {
              if (state is AppTrustedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('App marked as Trusted'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }

              if (state is AppUntrustedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('App untrusted'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
              if (state is AppKeptSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('App added to Keep list'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
              if (state is AppUnkeptSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('App removed from Keep list'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            buildWhen: (previous, current) =>
                current is AppPermissionLoaded || current is AppTrusting,
            builder: (context, state) {
              if (state is! AppPermissionLoaded) {
                return const SizedBox.shrink();
              }

              final app = [
                ...state.noRisk,
                ...state.lowRisk,
                ...state.mediumRisk,
                ...state.highRisk,
              ].firstWhere(
                (a) => a.packageName == widget.app.packageName,
                orElse: () => widget.app,
              );

              final percent = calculateRiskPercent(app.permissions);

              final isKept = context.select<AppPermissionCubit, bool>(
                (c) => c.isAppKept(widget.app.packageName),
              );
              final isTrust = context.select<AppPermissionCubit, bool>(
                (c) => c.isAppTrusted(widget.app.packageName),
              );


              final bool isTrusting;

              if (state is AppTrusting) {
               isTrusting= (state as AppTrusting).packageName == app.packageName;
              } else {
                isTrusting = false;
              }
              return Column(
                children: [
                  AppBarWidget(
                    text: 'APP DETAILS',
                    ontap: () => context.pop(),
                    width: 100,
                  ),

                  SizedBox(
                    height: 15.w,
                  ),
                  Image.memory(
                    base64Decode(app.iconBase64),
                    width: 80.w,
                    height: 80.w,
                  ),

                  SizedBox(height: 12.h),

                  Text(
                    app.appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6.h),
                  isTrust
                      ? Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 14.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "Trusted apps are excluded from risk warnings",
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ))
                      : RiskBadge(riskLevel: app.riskLevel),

                  SizedBox(height: 30.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TrustBtn(
                          isTrusting: isTrusting,
                          isTrusted: isTrust,
                          onTap: () {
                            isTrust
                                ? context
                                    .read<AppPermissionCubit>()
                                    .untrustApp(app.packageName)
                                : context
                                    .read<AppPermissionCubit>()
                                    .trustApp(app.packageName);
                          },
                        ),
                        SizedBox(
                          height: 10.w,
                        ),
                        KeepAppButton(
                          isKept: isKept,
                          onTap: () {
                            isTrust
                                ? null
                                : isKept
                                    ? context
                                        .read<AppPermissionCubit>()
                                        .unkeepApp(app.packageName)
                                    : context
                                        .read<AppPermissionCubit>()
                                        .keepApp(widget.app.packageName);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(percent * 100).round()}% RISK',
                          style: TextStyle(
                            color: isTrust
                                ? Colors.blue
                                : _riskColor(app.riskLevel),
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: InfoWidget(),
                              ),
                            );
                          },
                          child: Container(
                            width: 30.w,
                            height: 30.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.w),
                              color: AppColor.CartDark,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.info_outline,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  /// Permission list
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      children: PermissionConst.displayPermissions.entries
                          .map((entry) {
                        final permissionKey = entry.key;
                        final permissionName = entry.value;

                        final enabled = app.permissions.contains(permissionKey);

                        final isDangerous = PermissionConst.dangerousPermissions
                            .contains(permissionKey);

                        return PermissionSwitchTile(
                          title: permissionName,
                          enabled: enabled,
                          isDangerous: isDangerous,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: QuestionDialog(
                                  //
                                  ontapManual: () async {
                                    // Navigator.pop(context);
                                    if (dialogContext.canPop()) {
                                      Navigator.pop(dialogContext);
                                    }
                                    await Future.delayed(
                                        const Duration(milliseconds: 50));

                                    await AppPermissionPlatform()
                                        .openAppSettings(
                                            widget.app.packageName);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ],
              );
            });
  }

  Color _riskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.highRisk:
        return Colors.red;
      case RiskLevel.mediumRisk:
        return Colors.orange;
      case RiskLevel.lowRisk:
        return Colors.green;
      case RiskLevel.noRisk:
        return Colors.blue;
    }
  }
}
