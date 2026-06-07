import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/generated/app_localizations.dart';

import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/app_tile.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';
import 'package:permissions_app/presentation/utils/empty_page_widget.dart';

class KeepAppsScreen extends StatelessWidget {
  const KeepAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: l10n.keepApps,
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

                final keptApps = [
                  ...state.noRisk,
                  ...state.lowRisk,
                  ...state.mediumRisk,
                  ...state.highRisk,
                ].where((app) => cubit.isAppKept(app.packageName)).toList();

                if (keptApps.isEmpty) {
                  return Center(
                    child: EmptyPageWidget(text: l10n.noKeepApps),
                  );
                }

                return ListView(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/app_permission/tick-square.svg"),
                        SizedBox(width: screenWidth * 0.02),
                        Text(l10n.reviewedList, style: AppTextStyle.greenFont(context)),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.007),
                    Text(l10n.markedAsSafe, style: AppTextStyle.trustTitle(context)),
                    SizedBox(height: screenHeight * 0.007),
                    Text(
                      l10n.reviewedListDesc,
                      style: AppTextStyle.trustDescription(context).copyWith(
                        color: AppColor.green2,
                      ),
                    ),

                    SizedBox(height: screenHeight * (16 / 812)),
                    ...keptApps.map(
                          (app) => appTile(
                        context,
                        app,
                        actionText: l10n.remove,
                        onTap: () => _confirmUnKeep(context, app.packageName, l10n),
                      ),
                    ),

                    SizedBox(height: screenHeight * (12 / 812)),
                    Container(
                      margin: EdgeInsets.only(bottom: screenHeight * (12 / 812)),
                      padding: EdgeInsets.all(screenWidth * (12 / 812)),
                      decoration: BoxDecoration(
                        color: AppColor.green1.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(screenWidth * (24 / 812)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/app_permission/danger.svg"),
                          SizedBox(width: screenWidth * (12 / 812)),
                          Expanded(
                            child: Text(
                              l10n.keepAppsWarning,
                              style: AppTextStyle.greenWarning(context),
                            ),
                          ),
                        ],
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

  void _confirmUnKeep(BuildContext context, String packageName, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.CartDarkBorder,
        title: Text(l10n.removeFromKeep, style: AppTextStyle.greenFont(context)),
        content: Text(
          l10n.removeFromKeepDesc,
          style: AppTextStyle.trustDescription(context).copyWith(color: AppColor.green2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text(l10n.cancel, style: AppTextStyle.greenFont(context)),
          ),
          TextButton(
            onPressed: () {
              context.read<AppPermissionCubit>().unkeepApp(packageName);
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text(l10n.remove, style: AppTextStyle.greenFont(context)),
          ),
        ],
      ),
    );
  }
}