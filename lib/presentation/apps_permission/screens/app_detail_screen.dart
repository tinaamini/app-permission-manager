import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/keep_btn.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/permission_tile.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/trust_btn.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/permissionConst.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/models/app_permission_ui.dart';
import 'package:permissions_app/core/servises/app_permission_service.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/info_widget.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/question_dialog.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/risk_badge.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';
import 'package:permissions_app/presentation/utils/permission_ui_helper.dart';

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

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;


    return BaseScreen(
      child: BlocConsumer<AppPermissionCubit, AppPermissionState>(
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
              const SnackBar(
                content: Text('App added to Keep list'),
                duration: Duration(seconds: 3),
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
          if (state is! AppPermissionLoaded && state is! AppTrusting) {
            return const  Center(
                child: CustomDotsLoader(
                    svgPath1:
                    'assets/utils/Property 1=1 (1).svg',
                    svgPath2: 'assets/utils/Property 1=2 (1).svg',
                    svgPath3: 'assets/utils/Property 1=3 (1).svg',
                    svgPath4:
                    'assets/utils/Property 1=4 (1).svg'));
          }

          final AppPermissionLoaded loaded =
          state is AppPermissionLoaded ? state : (state as AppTrusting).previous;

          final app = [
            ...loaded.noRisk,
            ...loaded.lowRisk,
            ...loaded.mediumRisk,
            ...loaded.highRisk,
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

          final bool isTrusting = state is AppTrusting
              ? (state as AppTrusting).packageName == app.packageName
              : false;

          return Column(
            children: [
              AppBarWidget(
                text: 'APP DETAILS',
                ontap: () => context.pop(),
              ),

              SizedBox(
                height: screenHeight * 0.015,
              ),
              // Icon
              Image.memory(
                base64Decode(app.iconBase64),
                width: screenWidth * 0.2,
                height: screenHeight * 0.1,
              ),

              SizedBox(
                height: screenHeight * 0.015,
              ),
              // App name
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                ),
                child: Text(
                  app.appName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (AppSize.width * 0.045).clamp(14.0, 20.0),                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(
                height: screenHeight * 0.01,
              ),
              // Badge / Info
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                ),
                child: isTrust
                    ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.035,
                    vertical: screenHeight * 0.012,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(38),
                    borderRadius: BorderRadius.circular(screenWidth * 0.05),                  ),
                  child: Text(
                    "Trusted apps are excluded from risk warnings",
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: AppSize.width * 0.03,                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                )
                    : RiskBadge(riskLevel: app.riskLevel),
              ),

              SizedBox(
                height: screenHeight * 0.022,
              ),
              // Buttons row (anti overflow)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TrustBtn(
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
                    ),
                    SizedBox(
                      height: screenWidth * 0.015,
                    ),
                    Expanded(
                      child: KeepAppButton(
                        isKept: isKept,
                        onTap: () {
                          if (isTrust) return;
                          isKept
                              ? context
                              .read<AppPermissionCubit>()
                              .unkeepApp(app.packageName)
                              : context
                              .read<AppPermissionCubit>()
                              .keepApp(widget.app.packageName);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: screenHeight * 0.022,
              ),
              // Risk row
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${(percent * 100).round()}% RISK',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isTrust ? Colors.blue : _riskColor(app.riskLevel),
                          fontSize: AppSize.width * 0.05,                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.05),
                            ),
                            child: InfoWidget(),
                          ),
                        );
                      },
                      child: Container(
                        width: screenWidth * 0.075,
                        height: screenWidth * 0.075,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(screenWidth * 0.0625),
                          color: AppColor.CartDark,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: screenWidth * 0.015,
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

              SizedBox(
                height: screenHeight * 0.015,
              ),
              // Permission list
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                  ),
                  children: PermissionConst.displayPermissions.entries.map((entry) {
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
                              ontapManual: () async {
                                if (dialogContext.canPop()) {
                                  Navigator.pop(dialogContext);
                                }
                                await Future.delayed(
                                  const Duration(milliseconds: 50),
                                );
                                await AppPermissionPlatform()
                                    .openAppSettings(widget.app.packageName);
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
        },
      ),
    );
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