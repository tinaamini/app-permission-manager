import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/constant/specialPermissionType.dart';
import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
import 'package:permissions_app/logic/special_permission/pecial_permission_state.dart';
import 'package:permissions_app/logic/special_permission/special_permission_cubit.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/special_permissions/widget/btn_special_permission.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';
import 'package:permissions_app/presentation/utils/risk_color.dart';
import 'package:permissions_app/routs/rout_name.dart';
import 'package:permissions_app/core/utils/special_permission_risk_resolver.dart';

class SpecialPermissionScreen extends StatefulWidget {
  const SpecialPermissionScreen({super.key});

  @override
  State<SpecialPermissionScreen> createState() => _SpecialPermissionScreenState();
}

class _SpecialPermissionScreenState extends State<SpecialPermissionScreen>
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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: BlocBuilder<SpecialPermissionCubit, SpecialPermissionState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CustomDotsLoader(
                svgPath1: 'assets/utils/Property 1=1 (1).svg',
                svgPath2: 'assets/utils/Property 1=2 (1).svg',
                svgPath3: 'assets/utils/Property 1=3 (1).svg',
                svgPath4: 'assets/utils/Property 1=4 (1).svg',
              ),
            );
          }

          final riskLevel = riskLevelFromPercent(state.riskPercent);

          return Column(
            children: [
              AppBarWidget(
                text: "SPECIAL PERMISSIONS",
                ontap: () => context.pop(),
              ),

              SizedBox(height: AppSize.height * 0.028),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.width * 0.04),
                    child: Column(
                      children: [
                        Text(
                          "High-level system permissions that can affect your privacy.",
                          style: AppTextStyle.summaryValue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSize.height * 0.025),

                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: AppSpecialPermissionPlatform().getUsageAccessApps(),
                          builder: (context, snapshot) {
                            final apps = snapshot.data ?? [];
                            final level = SpecialPermissionRiskResolver.fromCount(
                              type: SpecialPermissionType.usageAccess,
                              count: apps.length,
                            );
                            return BtnSpecialPermission(
                              image: 'assets/special_permission/usage.png',
                              title: "Usage Data Access",
                              text: "View app usage statistics",
                              riskLevel: level,
                              enabled: apps.isNotEmpty,
                              ontap: () => context.pushNamed(
                                RouteName.specialPermissionDetail,
                                extra: SpecialPermissionType.usageAccess,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: AppSize.height * 0.025),

                        FutureBuilder<List<Map<String, dynamic>>>(
                          future: AppSpecialPermissionPlatform().getNotificationAccessApps(),
                          builder: (context, snapshot) {
                            final apps = snapshot.data ?? [];
                            final level = SpecialPermissionRiskResolver.fromCount(
                              type: SpecialPermissionType.notificationAccess,
                              count: apps.length,
                            );
                            return BtnSpecialPermission(
                              image: 'assets/special_permission/notification.png',
                              title: "Notification Access",
                              text: "Read and monitor notifications",
                              riskLevel: level,
                              enabled: apps.isNotEmpty,
                              ontap: () => context.pushNamed(
                                RouteName.specialPermissionDetail,
                                extra: SpecialPermissionType.notificationAccess,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: AppSize.height * 0.025),

                        FutureBuilder<bool>(
                          future: AppSpecialPermissionPlatform().checkOverlayPermission(),
                          builder: (context, snapshot) {
                            final enabled = snapshot.data ?? false;
                            return BtnSpecialPermission(
                              image: 'assets/special_permission/display.png',
                              title: "Display over other apps",
                              text: "Appear on top of other apps",
                              riskLevel: SpecialPermissionRiskResolver.fromEnabled(
                                type: SpecialPermissionType.displayOverApps,
                                enabled: enabled,
                              ),
                              enabled: enabled,
                              ontap: () => context.pushNamed(
                                RouteName.specialPermissionDetail,
                                extra: SpecialPermissionType.displayOverApps,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: AppSize.height * 0.025),

                        FutureBuilder<bool>(
                          future: AppSpecialPermissionPlatform().isIgnoringBatteryOptimizations(),
                          builder: (context, snapshot) {
                            final enabled = snapshot.data ?? false;
                            return BtnSpecialPermission(
                              image: 'assets/special_permission/Battery.png',
                              title: "Unrestricted Battery",
                              text: "Allowed Apps To Run In Background",
                              riskLevel: SpecialPermissionRiskResolver.fromEnabled(
                                type: SpecialPermissionType.batteryOptimization,
                                enabled: enabled,
                              ),
                              enabled: enabled,
                              ontap: () => context.pushNamed(
                                RouteName.specialPermissionDetail,
                                extra: SpecialPermissionType.batteryOptimization,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: AppSize.height * 0.025),

                        FutureBuilder<bool>(
                          future: AppSpecialPermissionPlatform().isDoNotDisturbEnabled(),
                          builder: (context, snapshot) {
                            final enabled = snapshot.data ?? false;
                            return BtnSpecialPermission(
                              image: 'assets/special_permission/Disturb.png',
                              title: "Do Not Disturb",
                              text: "Control notification interruptions",
                              riskLevel: SpecialPermissionRiskResolver.fromEnabled(
                                type: SpecialPermissionType.doNotDisturb,
                                enabled: enabled,
                              ),
                              enabled: enabled,
                              ontap: () => context.pushNamed(
                                RouteName.specialPermissionDetail,
                                extra: SpecialPermissionType.doNotDisturb,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: AppSize.height * 0.025),

                        Container(
                          height: AppSize.height * 0.11,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColor.warning,
                            borderRadius: BorderRadius.circular(AppSize.width * 0.02),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppSize.width * 0.02),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(AppSize.width * 0.02),
                                border: Border.all(
                                  width: 1,
                                  color: AppColor.warningborder,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: AppSize.width * 0.018,
                                    top: AppSize.height * 0.012,
                                    child: SizedBox(
                                      width: AppSize.width * 0.125,
                                      height: AppSize.width * 0.125,
                                      child: SvgPicture.asset('assets/main/danger.svg'),
                                    ),
                                  ),
                                  Positioned(
                                    left: AppSize.width * 0.125,
                                    top: AppSize.height * 0.012,
                                    child: Text(
                                      "This permission allows deep access to system data.",
                                      style: AppTextStyle.warning,
                                    ),
                                  ),
                                  Positioned(
                                    left: AppSize.width * 0.2,
                                    top: AppSize.height * 0.037,
                                    child: Text(
                                      "Only enable if you trust the app.",
                                      style: AppTextStyle.specialPermissiontitle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: AppSize.height * 0.025),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  RiskLevel _levelFromSpecialPermission({
    required SpecialPermissionType type,
    required bool enabled,
  }) {
    if (!enabled) return RiskLevel.noRisk;

    switch (type) {
      case SpecialPermissionType.notificationAccess:
      case SpecialPermissionType.usageAccess:
        return RiskLevel.highRisk;
      case SpecialPermissionType.displayOverApps:
      case SpecialPermissionType.batteryOptimization:
        return RiskLevel.mediumRisk;
      case SpecialPermissionType.doNotDisturb:
        return RiskLevel.lowRisk;
    }
  }
}