import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/servises/usage_access_service.dart';
import 'package:permissions_app/generated/app_localizations.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/apps_permission/recently_apps/widgets/usage_access_screen.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/btn_card.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';
import 'package:permissions_app/routs/rout_name.dart';
import '../widgets/btn_permission_widget.dart';

class AppPermissionScreen extends StatelessWidget {
  const AppPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;


    return BlocBuilder<AppPermissionCubit, AppPermissionState>(
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

        return BaseScreen(
          child: Column(
            children: [
              AppBarWidget(
                text: l10n.appPermission,
                ontap: () => context.pop(),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(  horizontal: screenWidth * 0.0375,
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
                                    extra: RiskLevel.noRisk,
                                  );
                                },
                                image: 'assets/app_permission/noRisk.svg',
                                text: l10n.noRisk,
                                integer: state.noRisk.length.toString(),
                                color: Colors.blue,
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
                                    extra: RiskLevel.lowRisk,
                                  );
                                },
                                image: 'assets/app_permission/lowRisk.svg',
                                text: l10n.lowRisk,
                                integer: state.lowRisk.length.toString(),
                                color: Colors.green,
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
                                    extra: RiskLevel.mediumRisk,
                                  );
                                },
                                image: 'assets/app_permission/mediumRisk.svg',
                                text: l10n.mediumRisk,
                                integer: state.mediumRisk.length.toString(),
                                color: Colors.orange,
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
                                    extra: RiskLevel.highRisk,
                                  );
                                },
                                image: 'assets/app_permission/highRisk.svg',
                                text: l10n.highRisk,
                                integer: state.highRisk.length.toString(),
                                color: Colors.red,
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
                          ontap: () => context.pushNamed(RouteName.keepApps),
                        ),

                        SizedBox(
                          height: screenHeight * (14 / 812),
                        ),
                        BtnCard(
                          image: 'assets/app_permission/trust.svg',
                          text: l10n.trustApp,
                          ontap: () => context.pushNamed(RouteName.trustedApps),
                        ),

                        SizedBox(
                          height: screenHeight * (14 / 812),
                        ),
                        BtnCard(
                          image: 'assets/app_permission/recent.svg',
                          text: l10n.recentApps,
                          ontap: () async {
                            final granted =
                            await UsageAccessService.isUsageAccessGranted();
                            await UsageAccessService.isUsageAccessGranted();

                            if (granted) {
                              context.pushNamed(RouteName.recentApps);
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
                                context.pushNamed(RouteName.recentApps);
                              }
                            }
                          },
                        ),

                        SizedBox(
                          height: screenHeight * 0.03,
                        ),                      ],
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