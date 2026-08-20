import 'package:Privio/logic/utils/scan/scan_cubit.dart';
import 'package:Privio/logic/utils/scan/scan_state.dart';
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/presentation/home/widgets/about_button.dart';
import 'package:Privio/presentation/home/widgets/scanInitialOverlay.dart';
import 'package:Privio/presentation/home/widgets/scan_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:Privio/core/servises/installed_apps_service.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:Privio/logic/app_permission/app_permission_state.dart';

import 'package:Privio/logic/risk/device_risk_resolver.dart';
import 'package:Privio/presentation/home/widgets/btn_home_widget.dart';
import 'package:Privio/presentation/home/widgets/device_status_card.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/btn_language_util.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/routs/rout_name.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final InstalledAppsService _appsService = InstalledAppsService();
  final DeviceRiskResolver _riskResolver = const DeviceRiskResolver();

  late final Future<int> _appsCountFuture =
      _appsService.fetchInstalledAppsCount();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scanState = context.watch<ScanCubit>().state;
    final hasScanned = scanState.lastScanTime != null;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BaseScreen(

      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),

            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              
              
              child: IntrinsicHeight(
                child: BlocBuilder<ScanCubit, ScanState>(
                    builder: (context, state) {
                      if (state.status == ScanStatus.loading) {
                        return const ScanLoadingOverlay();
                      }
                      if (state.status == ScanStatus.initial) {
                        return const ScanInitialOverlay();
                      }
                    return
                      Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: AppSize.height * 0.03,
                          ),
                          child: Row(
                            children: [
                              BtnLanguageUtil(),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  context.read<ThemeCubit>().toggle();
                                },
                                child: isDark
                                    ? SvgPicture.asset("assets/utils/sun.svg")
                                    : SvgPicture.asset("assets/utils/moon.svg"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSize.height * 0.05),
                        BlocBuilder<AppPermissionCubit, AppPermissionState>(
                          builder: (context, state) {
                            if (state is! AppPermissionLoaded) {
                              return Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                child: const Center(
                                  child: CustomDotsLoader(
                                    svgPath1: 'assets/utils/Property 1=1 (1).svg',
                                    svgPath2: 'assets/utils/Property 1=2 (1).svg',
                                    svgPath3: 'assets/utils/Property 1=3 (1).svg',
                                    svgPath4: 'assets/utils/Property 1=4 (1).svg',
                                  ),
                                ),
                              );
                            }
                              
                            final status = _riskResolver.resolve(
                              context,
                              high: state.highRisk.length,
                              medium: state.mediumRisk.length,
                              low: state.lowRisk.length,
                            );
                              
                            return DeviceStatusCard(status: status);
                          },
                        ),
                        SizedBox(height: AppSize.height * 0.02),
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FutureBuilder<int>(
                              future: _appsCountFuture,
                              builder: (context, snapshot) {
                                final countText =
                                    snapshot.hasData ? '${snapshot.data}' : '...';
                              
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: BtnHomeWidget(
                                            image: 'assets/main/grid.svg',
                                            text: l10n.appPermission,
                                            textCount: '$countText ${l10n.appsChecked}',
                                            ontap: () =>
                                                context.pushNamed(RouteName.appsPermission),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.04),
                                        Expanded(
                                          child: BtnHomeWidget(
                                            image: 'assets/main/layer.svg',
                                            text: l10n.groupPermission,
                                            textCount: '10 ${l10n.categories}',
                                            ontap: () => context
                                                .pushNamed(RouteName.groupPermission),
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
                                            text: l10n.specialPermission,
                                            textCount: '5 ${l10n.sensitiveAccess}',
                                            ontap: () => context
                                                .pushNamed(RouteName.specialPermission),
                                          ),
                                        ),
                                        SizedBox(width: screenWidth * 0.04),
                                        Expanded(
                                          child: BtnHomeWidget(
                                            image: 'assets/main/chart.svg',
                                            text: l10n.dashboard,
                                            textCount: l10n.viewStates,
                                            ontap: () => context
                                                .pushNamed(RouteName.dashboardPermission),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.025),
                                    const AboutButton(),
                                    SizedBox(height: screenHeight * 0.025),

                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                              
                  }
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}


