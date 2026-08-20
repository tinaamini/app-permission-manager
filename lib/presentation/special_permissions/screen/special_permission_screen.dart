import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/constant/specialPermissionType.dart';
import 'package:Privio/core/utils/special_permission_risk_resolver.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/special_permission/pecial_permission_state.dart';
import 'package:Privio/logic/special_permission/special_permission_cubit.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/special_permissions/widget/btn_special_permission.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/routs/rout_name.dart';

class SpecialPermissionScreen extends StatefulWidget {
  const SpecialPermissionScreen({super.key});

  @override
  State<SpecialPermissionScreen> createState() =>
      _SpecialPermissionScreenState();
}

class _SpecialPermissionScreenState extends State<SpecialPermissionScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // اگر هنوز لود نشده، یک‌بار بکش
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<SpecialPermissionCubit>();
      if (cubit.state.loading) {
        cubit.loadStatus();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<SpecialPermissionCubit>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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

          return Column(
            children: [
              AppBarWidget(
                text: l10n.specialPermission,
                ontap: () => context.pop(),
                showBack: true,
                showHome: false,
              ),
              SizedBox(height: AppSize.height * 0.028),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: AppSize.width * 0.04),
                    child: Column(
                      children: [
                        Text(
                          l10n.descSpecialPermission,
                          style: AppTextStyle.summaryValue(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppSize.height * 0.025),
                        BtnSpecialPermission(
                          image: 'assets/special_permission/usage.png',
                          title: l10n.usageAccessTitle,
                          text: l10n.usageStatsPermission,
                          riskLevel: SpecialPermissionRiskResolver.fromCount(
                            type: SpecialPermissionType.usageAccess,
                            count: state.usageCount,
                          ),
                          enabled: state.usageCount > 0,
                          ontap: () => context.pushNamed(
                            RouteName.specialPermissionDetail,
                            extra: SpecialPermissionType.usageAccess,
                          ),
                        ),
                        SizedBox(height: AppSize.height * 0.025),
                        BtnSpecialPermission(
                          image: 'assets/special_permission/notification.png',
                          title: l10n.notificationAccessTitle,
                          text: l10n.notificationAccessPermission,
                          riskLevel: SpecialPermissionRiskResolver.fromCount(
                            type: SpecialPermissionType.notificationAccess,
                            count: state.notificationCount,
                          ),
                          enabled: state.notificationCount > 0,
                          ontap: () => context.pushNamed(
                            RouteName.specialPermissionDetail,
                            extra: SpecialPermissionType.notificationAccess,
                          ),
                        ),
                        SizedBox(height: AppSize.height * 0.025),
                        BtnSpecialPermission(
                          image: 'assets/special_permission/display.png',
                          title: l10n.displayOverApps,
                          text: l10n.overlayPermission,
                          riskLevel: SpecialPermissionRiskResolver.fromCount(
                            type: SpecialPermissionType.displayOverApps,
                            count: state.overlayCount,
                          ),
                          enabled: state.overlayCount > 0,
                          ontap: () => context.pushNamed(
                            RouteName.specialPermissionDetail,
                            extra: SpecialPermissionType.displayOverApps,
                          ),
                        ),
                        SizedBox(height: AppSize.height * 0.025),
                        BtnSpecialPermission(
                          image: 'assets/special_permission/Battery.png',
                          title: l10n.unrestrictedBatteryTitle,
                          text: l10n.unrestrictedBatteryDesc,
                          riskLevel: SpecialPermissionRiskResolver.fromCount(
                            type: SpecialPermissionType.batteryOptimization,
                            count: state.batteryCount,
                          ),
                          enabled: state.batteryCount > 0,
                          ontap: () => context.pushNamed(
                            RouteName.specialPermissionDetail,
                            extra: SpecialPermissionType.batteryOptimization,
                          ),
                        ),
                        SizedBox(height: AppSize.height * 0.025),
                        BtnSpecialPermission(
                          image: 'assets/special_permission/Disturb.png',
                          title: l10n.doNotDisturb,
                          text: l10n.doNotDisturbPermission,
                          riskLevel: SpecialPermissionRiskResolver.fromCount(
                            type: SpecialPermissionType.doNotDisturb,
                            count: state.dndCount,
                          ),
                          enabled: state.dndCount > 0,
                          ontap: () => context.pushNamed(
                            RouteName.specialPermissionDetail,
                            extra: SpecialPermissionType.doNotDisturb,
                          ),
                        ),
                        SizedBox(height: AppSize.height * 0.025),
                        Container(
                          height: AppSize.height * 0.11,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColor.warning,
                            borderRadius:
                                BorderRadius.circular(AppSize.width * 0.02),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(AppSize.width * 0.02),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppSize.width * 0.02),
                                border: Border.all(
                                  width: 1,
                                  color: AppColor.warningBorder,
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
                                      child: SvgPicture.asset(
                                          'assets/main/danger.svg'),
                                    ),
                                  ),
                                  Positioned(
                                    left: AppSize.width * 0.125,
                                    top: AppSize.height * 0.012,
                                    child: Text(
                                      l10n.specialPermissionWarning,
                                      style: AppTextStyle.warning(context),
                                    ),
                                  ),
                                  Positioned(
                                    left: AppSize.width * 0.2,
                                    top: AppSize.height * 0.037,
                                    child: Text(
                                      l10n.specialPermissionWarningDesc,
                                      style:
                                          AppTextStyle.specialPermissiontitle(
                                              context),
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
}
