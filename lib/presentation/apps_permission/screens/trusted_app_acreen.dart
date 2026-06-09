import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:Privio/generated/app_localizations.dart';

import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:Privio/logic/app_permission/app_permission_state.dart';
import 'package:Privio/presentation/apps_permission/widgets/app_tile.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/presentation/utils/empty_page_widget.dart';

class TrustedAppsScreen extends StatelessWidget {
  const TrustedAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: l10n.trustedApps,
            ontap: () => context.pop(),
          ),

          Expanded(
            child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
              builder: (context, state) {
                if (state is! AppPermissionLoaded) {
                  return const Center(
                    child: CustomDotsLoader(
                      svgPath1: 'assets/utils/Property 1=1 (1).svg',
                      svgPath2: 'assets/utils/Property 1=2 (1).svg',
                      svgPath3: 'assets/utils/Property 1=3 (1).svg',
                      svgPath4: 'assets/utils/Property 1=4 (1).svg',
                    ),
                  );
                }

                final cubit = context.read<AppPermissionCubit>();

                final trustedApps = [
                  ...state.noRisk,
                  ...state.lowRisk,
                  ...state.mediumRisk,
                  ...state.highRisk,
                ].where((app) => cubit.isAppTrusted(app.packageName)).toList();

                if (trustedApps.isEmpty) {
                  return Center(
                    child: EmptyPageWidget(text: l10n.noTrustedApps),
                  );
                }

                return ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/app_permission/shield-tick.svg"),
                        SizedBox(width: screenWidth * 0.02),
                        Text(l10n.whiteList, style: AppTextStyle.blueFont(context)),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.007),
                    Text(l10n.appsYouFullyTrust, style: AppTextStyle.trustTitle(context)),
                    SizedBox(height: screenHeight * 0.007),
                    Text(
                      l10n.trustedListDesc,
                      style: AppTextStyle.trustDescription(context),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ...trustedApps.map(
                          (app) => appTile(
                        context,
                        app,
                        actionText: l10n.untrust,
                        onTap: () => _confirmUntrust(context, app.packageName, l10n),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _confirmUntrust(BuildContext context, String packageName, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.CartDarkBorder,
        title: Text(l10n.removeTrust, style: AppTextStyle.blueFont(context)),
        content: Text(
          l10n.removeTrustDesc,
          style: AppTextStyle.trustDescription(context),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text(l10n.cancel, style: AppTextStyle.blueFont(context)),
          ),
          TextButton(
            onPressed: () {
              context.read<AppPermissionCubit>().untrustApp(packageName);
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(l10n.untrust, style: AppTextStyle.blueFont(context)),
          ),
        ],
      ),
    );
  }
}