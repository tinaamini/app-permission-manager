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
import 'package:permissions_app/presentation/utils/empty_page_widget.dart';

class KeepAppsScreen extends StatelessWidget {
  const KeepAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: 'KEEP APPS',
            ontap: () => context.pop(),
          ),

          Expanded(
            child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
              builder: (context, state) {
                if (state is! AppPermissionLoaded) {
                  return const Center(child: CupertinoActivityIndicator());
                }

                final cubit = context.read<AppPermissionCubit>();

                final keptApps = [
                  ...state.noRisk,
                  ...state.lowRisk,
                  ...state.mediumRisk,
                  ...state.highRisk,
                ].where((app) => cubit.isAppKept(app.packageName)).toList();

                if (keptApps.isEmpty) {
                  return const Center(
                    child: EmptyPageWidget(text: "NO KEEP APP"),
                  );
                }

                return ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset("assets/app_permission/tick-square.svg"),
                        SizedBox(width: 8.w),
                        Text(
                          "REVIEWED LIST",
                          style: AppTextStyle.greenFont,
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text("Marked as Safe", style: AppTextStyle.trustTitle),
                    SizedBox(height: 6.h),

                    Text(
                      "These are apps you have manually reviewed.\n"
                          "They will no longer trigger risk warnings unless\n"
                          "their behavior changes significantly.",
                      style: AppTextStyle.trustDescription.copyWith(
                        color: AppColor.green2,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    ...keptApps.map(
                          (app) => appTile(
                        context,
                        app,
                        actionText: 'Remove',
                        onTap: () => _confirmUnKeep(context, app.packageName),
                      ),
                    ),

                    SizedBox(height: 12.h),

                    Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: AppColor.green1.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset("assets/app_permission/danger.svg"),
                          SizedBox(width: 12.w),

                          Expanded(
                            child: Text(
                              'Removing an app from this list will return it to the '
                                  '"Risk Apps" scan result if it requests sensitive '
                                  'permissions in the future.',
                              style: AppTextStyle.greenWarning,
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

  void _confirmUnKeep(BuildContext context, String packageName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColor.CartDarkBorder,
        title: Text('Remove from Keep', style: AppTextStyle.greenFont),
        content: Text(
          'This app will no longer be trusted and will be analyzed again for potential risks.',
          style: AppTextStyle.trustDescription.copyWith(color: AppColor.green2),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: Text('Cancel', style: AppTextStyle.greenFont),
          ),
          TextButton(
            onPressed: () {
              context.read<AppPermissionCubit>().unkeepApp(packageName);
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text('Remove', style: AppTextStyle.greenFont),
          ),
        ],
      ),
    );
  }
}