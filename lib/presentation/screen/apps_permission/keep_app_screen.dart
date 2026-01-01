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

class KeepAppsScreen extends StatelessWidget {
  const KeepAppsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BcGround,
      body: Column(
        children: [
          AppBarWidget(
            text: 'KEEP APPS',
            ontap: () => context.pop(),
            width: 80,
          ),
          BlocBuilder<AppPermissionCubit, AppPermissionState>(
            builder: (context, state) {
              if (state is! AppPermissionLoaded) {
                return const Center(child: CupertinoActivityIndicator());
              }

              final keptApps = [
                ...state.noRisk,
                ...state.lowRisk,
                ...state.mediumRisk,
                ...state.highRisk,
              ].where((app) =>
                  context.read<AppPermissionCubit>().isAppKept(app.packageName))
                  .toList();

              if (keptApps.isEmpty) {
                return empty('No kept apps');
              }

              return Container(width: 350.w,height: 800.h,
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    description(
                      'Apps you reviewed and marked as safe.\n'
                          'They will no longer appear in risk warnings.',
                    ),
                    SizedBox(height: 16.h),
                    ...keptApps.map((app) => appTile(
                      context,
                      app,
                      actionText: 'Remove',
                      onTap: () {
                        context
                            .read<AppPermissionCubit>()
                            .unkeepApp(app.packageName);
                      },
                    )),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
