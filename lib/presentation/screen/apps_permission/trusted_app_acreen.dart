import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/screen/apps_permission/widgets/app_tile.dart';
import 'package:permissions_app/presentation/screen/apps_permission/widgets/description.dart';
import 'package:permissions_app/presentation/screen/apps_permission/widgets/emty_state.dart';
import 'package:permissions_app/presentation/widget/app_bar.dart';

class TrustedAppsScreen extends StatelessWidget {
  const TrustedAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BcGround,
      body: BlocBuilder<AppPermissionCubit, AppPermissionState>(
        builder: (context, state) {
          if (state is! AppPermissionLoaded) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final trustedApps = [
            ...state.noRisk,
            ...state.lowRisk,
            ...state.mediumRisk,
            ...state.highRisk,
          ].where((app) =>
              context.read<AppPermissionCubit>().isAppTrusted(app.packageName))
              .toList();

          if (trustedApps.isEmpty) {
            return empty('No trusted apps');
          }

          return Column(
            children: [
              AppBarWidget(
                text: 'TRUSTED APPS',
                ontap: () => context.pop(),
                width: 80,
              ),
              Container(width: 350.w,height: 800.h,
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    description(
                      'Apps you fully trust.\n'
                          'They are excluded from all risk alerts.',
                    ),
                    SizedBox(height: 16.h),
                    ...trustedApps.map((app) => appTile(
                      context,
                      app,
                      actionText: 'Untrust',
                      onTap: () {
                        _confirmUntrust(context, app.packageName);
                      },
                    )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
  void _confirmUntrust(BuildContext context, String packageName) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove Trust'),
        content: const Text(
          'This app will be analyzed again and may show risk warnings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<AppPermissionCubit>().untrustApp(packageName);
              Navigator.pop(context);
            },
            child: const Text('Untrust'),
          ),
        ],
      ),
    );
  }

}
