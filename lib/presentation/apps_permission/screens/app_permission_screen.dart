import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/core/servises/usage_access_service.dart';
import 'package:Privio/core/servises/recent_apps_service.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:Privio/logic/app_permission/app_permission_state.dart';
import 'package:Privio/presentation/apps_permission/recently_apps/widgets/usage_access_screen.dart';
import 'package:Privio/presentation/apps_permission/widgets/btn_card.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/utils/app_permission_load_failure.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/routs/rout_name.dart';
import '../widgets/btn_permission_widget.dart';

class AppPermissionScreen extends StatefulWidget {
  const AppPermissionScreen({super.key});

  @override
  State<AppPermissionScreen> createState() => _AppPermissionScreenState();
}

class _AppPermissionScreenState extends State<AppPermissionScreen> {
  late Future<List<dynamic>> _recentApps;

  @override
  void initState() {
    super.initState();
    _recentApps = RecentAppsService.getTodayRecentApps();
  }

  void _refreshRecentApps() {
    if (!mounted) return;
    setState(() {
      _recentApps = RecentAppsService.getTodayRecentApps();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return BlocBuilder<AppPermissionCubit, AppPermissionState>(
      builder: (context, state) {
        if (state is AppPermissionError) {
          return AppPermissionLoadFailure(
            onRetry: () => context.read<AppPermissionCubit>().loadApps(),
          );
        }
        if (state is! AppPermissionLoaded) {
          return const Center(
              child: CustomDotsLoader(
                  svgPath1: 'assets/utils/Property 1=1 (1).svg',
                  svgPath2: 'assets/utils/Property 1=2 (1).svg',
                  svgPath3: 'assets/utils/Property 1=3 (1).svg',
                  svgPath4: 'assets/utils/Property 1=4 (1).svg'));
        }

        final cubit = context.read<AppPermissionCubit>();
        final keptCount =
            state.allApps.where((app) => cubit.isAppKept(app.packageName)).length;
        final trustedCount = state.allApps
            .where((app) => cubit.isAppTrusted(app.packageName))
            .length;

        return BaseScreen(
          child: Column(
            children: [
              AppBarWidget(
                text: l10n.appPermission,
                ontap: () => context.pop(),
                showBack: true,
                showHome: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.0375,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                        // ---- 2x2 permission buttons ----
                        Row(
                          children: [
                            Expanded(
                              child: BtnPermissionWidget(
                                ontap: () {
                                  context.pushNamed(
                                    RouteName.riskApps,
                                    extra: RiskLevel.highRisk,
                                  );
                                },
                                image: isDark
                                    ? 'assets/app_permission/highRisk.svg'
                                    : "assets/app_permission/Frame 8 (3).svg",
                                text: l10n.highRisk,
                                integer: state.highRisk.length.toString(),
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.03,
                            ),
                            Expanded(
                              child: BtnPermissionWidget(
                                ontap: () {
                                  context.pushNamed(
                                    RouteName.riskApps,
                                    extra: RiskLevel.mediumRisk,
                                  );
                                },
                                image: isDark
                                    ? 'assets/app_permission/mediumRisk.svg'
                                    : "assets/app_permission/Frame 8 (2).svg",
                                text: l10n.mediumRisk,
                                integer: state.mediumRisk.length.toString(),
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: BtnPermissionWidget(
                                ontap: () {
                                  context.pushNamed(
                                    RouteName.riskApps,
                                    extra: RiskLevel.lowRisk,
                                  );
                                },
                                image: isDark
                                    ? 'assets/app_permission/lowRisk.svg'
                                    : "assets/app_permission/Frame 8 (1).svg",
                                text: l10n.lowRisk,
                                integer: state.lowRisk.length.toString(),
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.03,
                            ),
                            Expanded(
                              child: BtnPermissionWidget(
                                ontap: () {
                                  context.pushNamed(
                                    RouteName.riskApps,
                                    extra: RiskLevel.noRisk,
                                  );
                                },
                                image: isDark
                                    ? 'assets/app_permission/noRisk.svg'
                                    : "assets/app_permission/Frame 8.svg",
                                text: l10n.noRisk,
                                integer: state.noRisk.length.toString(),
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: screenHeight * (24 / 812),
                        ),
                        // ---- Cards ----
                        BtnCard(
                          image: 'assets/app_permission/keep.svg',
                          text: l10n.keepApp,
                          count: keptCount.toString(),
                          ontap: () => context.pushNamed(RouteName.keepApps),
                        ),

                        SizedBox(
                          height: screenHeight * (14 / 812),
                        ),
                        BtnCard(
                          image: 'assets/app_permission/trust.svg',
                          text: l10n.trustApp,
                          count: trustedCount.toString(),
                          ontap: () => context.pushNamed(RouteName.trustedApps),
                        ),

                        SizedBox(
                          height: screenHeight * (14 / 812),
                        ),
                        FutureBuilder<List<dynamic>>(
                          future: _recentApps,
                          builder: (context, snapshot) {
                            final installedPackages = state.allApps
                                .map((app) => app.packageName)
                                .toSet();
                            final recentCount = (snapshot.data ?? [])
                                .map((item) => item['package'] as String?)
                                .whereType<String>()
                                .where(installedPackages.contains)
                                .toSet()
                                .length;

                            return BtnCard(
                              image: 'assets/app_permission/recent.svg',
                              text: l10n.recentApps,
                              count: recentCount.toString(),
                              ontap: () async {
                                final granted = await UsageAccessService
                                    .isUsageAccessGranted();

                                if (granted) {
                                  await context.pushNamed(RouteName.recentApps);
                                  _refreshRecentApps();
                                } else {
                                  final result = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: UsageAccessScreen(),
                                    ),
                                  );
                                  if (result == true) {
                                    await context.pushNamed(RouteName.recentApps);
                                    _refreshRecentApps();
                                  }
                                }
                              },
                            );
                          },
                        ),

                        SizedBox(
                          height: screenHeight * 0.03,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
