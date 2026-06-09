import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/core/models/app_permission_ui.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:Privio/logic/app_permission/app_permission_state.dart';
import 'package:Privio/presentation/apps_permission/widgets/app_item_widget.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/empty_page_widget.dart';
import 'package:Privio/routs/rout_name.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: _title(l10n),
            ontap: () => context.pop(),
          ),
          SizedBox(height: AppSize.height * 0.015),

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
                  return  EmptyPageWidget(text: l10n.noAppsFound);
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

  String _title(AppLocalizations l10n) {
    switch (riskLevel) {
      case RiskLevel.noRisk:
        return l10n.noRiskApps;
      case RiskLevel.lowRisk:
        return l10n.lowRiskApps;
      case RiskLevel.mediumRisk:
        return l10n.mediumRiskApps;
      case RiskLevel.highRisk:
        return l10n.highRiskApps;
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