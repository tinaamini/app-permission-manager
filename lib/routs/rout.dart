import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/models/app_permission_ui.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/presentation/main_screen.dart';
import 'package:permissions_app/presentation/screen/apps_permission/app_detail_screen.dart';
import 'package:permissions_app/presentation/screen/apps_permission/app_permission_screen.dart';
import 'package:permissions_app/presentation/screen/apps_permission/risk_app_list_screen.dart';
import 'package:permissions_app/presentation/screen/home/home_screen.dart';
import 'package:permissions_app/routs/rout_name.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();



final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  routes: [

    /// ----------- SHELL -----------
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return MainScreen(child: child);
      },
      routes: [
        GoRoute(
          name: RouteName.home,
          path: '/home',
          pageBuilder: (context, state) => CupertinoPage(
            key: state.pageKey,
            child: HomeScreen(),
          ),
        ),

        GoRoute(
          name: RouteName.appsPermission,
          path: '/appsPermission',
          pageBuilder: (context, state) => CupertinoPage(
            key: state.pageKey,
            child: AppPermissionScreen(),
          ),
        ),

        GoRoute(
          name: RouteName.riskApps,
          path: '/riskApps',
          pageBuilder: (context, state) {
            final riskLevel = state.extra as RiskLevel;
            return CupertinoPage(
              key: state.pageKey,
              child: RiskAppListScreen(riskLevel: riskLevel),
            );
          },
        ),

        GoRoute(
          name: RouteName.appDetail,
          path: '/appDetail',
          pageBuilder: (context, state) {
            final app = state.extra as AppPermissionUi;

            return CupertinoPage(
              key: state.pageKey,
              child: AppDetailScreen(app: app),
            );
          },
        ),

      ],
    ),
  ],
);

