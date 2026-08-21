  import 'package:Privio/core/extensions/context_extension.dart';
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
import 'package:Privio/presentation/apps_permission/widgets/app_search_bar.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/presentation/utils/empty_page_widget.dart';

class KeepAppsScreen extends StatefulWidget {
  const KeepAppsScreen({super.key});

  @override
  State<KeepAppsScreen> createState() => _KeepAppsScreenState();
}

class _KeepAppsScreenState extends State<KeepAppsScreen> {
  String _query = '';

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
            showBack: true,
            showHome: true,
          ),
          AppSearchBar(onChanged: (value) => setState(() => _query = value)),
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
                ].where((app) =>
                    cubit.isAppKept(app.packageName) &&
                    _matches(app.appName, app.packageName)).toList();

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
                        SvgPicture.asset(
                          context.isDark
                              ? "assets/app_permission/tick-square.svg"
                              : "assets/app_permission/tick-square2.svg",
                          width: 30.w,
                          height: 30.h,
                        ),
                        SizedBox(width: screenWidth * 0.02),
                        Text(l10n.reviewedList,
                            style: AppTextStyle.greenFont(context)),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.007),
                    Text(l10n.markedAsSafe,
                        style: AppTextStyle.trustTitle(context)),
                    SizedBox(height: screenHeight * 0.007),
                    Text(
                      l10n.reviewedListDesc,
                      style: AppTextStyle.trustDescription(context).copyWith(
                        color:
                            context.isDark ? AppColor.green2 : AppColor.green4,
                      ),
                    ),
                    SizedBox(height: screenHeight * (16 / 812)),
                    ...keptApps.map(
                      (app) => appTile(
                        context,
                        app,
                        actionText: l10n.remove,
                        onTap: () =>
                            _confirmUnKeep(context, app.packageName, l10n),
                      ),
                    ),
                    SizedBox(height: screenHeight * (12 / 812)),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _matches(String name, String packageName) {
    final query = _query.trim().toLowerCase();
    return query.isEmpty ||
        name.toLowerCase().contains(query) ||
        packageName.toLowerCase().contains(query);
  }

  void _confirmUnKeep(
      BuildContext context, String packageName, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:
            context.isDark ? AppColor.CartDarkBorder : AppColor.white,
        title:
            Text(l10n.removeFromKeep, style: AppTextStyle.greenFont(context)),
        content: Text(
          l10n.removeFromKeepDesc,
          style: AppTextStyle.trustDescription(context).copyWith(
              color: context.isDark ? AppColor.green2 : AppColor.green4),
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
