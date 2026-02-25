import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/apps_permission/widgets/app_tile.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';
import 'package:permissions_app/presentation/utils/empty_page_widget.dart';

class TrustedAppsScreen extends StatelessWidget {
  const TrustedAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: 'TRUSTED APPS',
            ontap: () => context.pop(),
          ),

          Expanded(
            child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
              builder: (context, state) {
                if (state is! AppPermissionLoaded) {
                  return  const  Center(
                      child: CustomDotsLoader(
                          svgPath1:
                          'assets/utils/Property 1=1 (1).svg',
                          svgPath2: 'assets/utils/Property 1=2 (1).svg',
                          svgPath3: 'assets/utils/Property 1=3 (1).svg',
                          svgPath4:
                          'assets/utils/Property 1=4 (1).svg'));
                }

                final cubit = context.read<AppPermissionCubit>();

                final trustedApps = [
                  ...state.noRisk,
                  ...state.lowRisk,
                  ...state.mediumRisk,
                  ...state.highRisk,
                ].where((app) => cubit.isAppTrusted(app.packageName)).toList();

                if (trustedApps.isEmpty) {
                  return const Center(
                    child: EmptyPageWidget(text: "NO TRUSTED APP"),
                  );
                }

                return ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/app_permission/shield-tick.svg"),
                        SizedBox(width: 8.w),
                        Text("WHITE LIST", style: AppTextStyle.blueFont),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text("Apps you fully trust", style: AppTextStyle.trustTitle),
                    SizedBox(height: 6.h),
                    Text(
                      "These applications are excluded from all risk\n"
                          "alerts and security scans. Only trust apps you are\n"
                          "certain are safe",
                      style: AppTextStyle.trustDescription,
                    ),
                    SizedBox(height: 16.h),

                    ...trustedApps.map(
                          (app) => appTile(
                        context,
                        app,
                        actionText: 'Untrust',
                        onTap: () => _confirmUntrust(context, app.packageName),
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

  void _confirmUntrust(BuildContext context, String packageName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.CartDarkBorder,
        title: Text('Remove Trust', style: AppTextStyle.blueFont),
        content: Text(
          'This app will be analyzed again and may show risk warnings.',
          style: AppTextStyle.trustDescription,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text('Cancel', style: AppTextStyle.blueFont),
          ),
          TextButton(
            onPressed: () {
              context.read<AppPermissionCubit>().untrustApp(packageName);
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Untrust', style: AppTextStyle.blueFont),
          ),
        ],
      ),
    );
  }
}