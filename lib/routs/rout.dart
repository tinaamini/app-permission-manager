import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Privio/constant/permission_group_type.dart';

import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/constant/specialPermissionType.dart';
import 'package:Privio/core/models/app_permission_ui.dart';
import 'package:Privio/logic/onboarding/show_onboarding/show_onboarding_cubit.dart';
import 'package:Privio/presentation/apps_permission/recently_apps/screen/recent_apps.dart';
import 'package:Privio/presentation/apps_permission/screens/app_detail_screen.dart';
import 'package:Privio/presentation/apps_permission/screens/app_permission_screen.dart';
import 'package:Privio/presentation/apps_permission/screens/keep_app_screen.dart';
import 'package:Privio/presentation/apps_permission/screens/risk_app_list_screen.dart';
import 'package:Privio/presentation/apps_permission/screens/trusted_app_acreen.dart';
import 'package:Privio/presentation/dashboard/screen/dashboard_screen.dart';
import 'package:Privio/presentation/group_permission/screen/group_permissions_screen.dart';
import 'package:Privio/presentation/group_permission/screen/permmision_detail_screen.dart';
import 'package:Privio/presentation/home/screens/home_screen.dart';
import 'package:Privio/presentation/about/screen/about_screen.dart';
import 'package:Privio/presentation/onboarding/screen/onboarding_screen.dart';
import 'package:Privio/presentation/special_permissions/screen/special_permission_detail_screen.dart';
import 'package:Privio/presentation/special_permissions/screen/special_permission_screen.dart';
import 'package:Privio/presentation/utils/main_screen.dart';
import 'package:Privio/routs/refreshListenable.dart';
import 'package:Privio/routs/rout_name.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();


GoRouter createRouter(OnboardingShowCubit onboardingShowCubit) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: GoRouterRefreshStream(onboardingShowCubit.stream),
    redirect: (context, state) {
      final status = onboardingShowCubit.state;

      final goingToOnboarding = state.matchedLocation == '/onboarding';

      if (status == OnboardingStatus.unknown) return null;

      if (status == OnboardingStatus.show) {
        return goingToOnboarding ? null : '/onboarding';
      }

      if (status == OnboardingStatus.done) {
        return goingToOnboarding ? '/home' : null;
      }

      return null;
    },
  routes: [
    GoRoute(
      name: RouteName.onboarding,
      path: '/onboarding',
      pageBuilder: (context, state) => const CupertinoPage(
        child: OnboardingScreen(),
      ),
    ),
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
          name: RouteName.about,
          path: '/about',
          pageBuilder: (context, state) => CupertinoPage(
            key: state.pageKey,
            child: const AboutScreen(),
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
            debugPrint(
              '[SHORTCUT_TRACE] router:build riskApps '
              'extra=${state.extra} uri=${state.uri}',
            );
            // Launcher/deep-link restoration may rebuild this route without
            // preserving GoRouter's in-memory `extra`. The shortcut always
            // means high-risk apps, so use that as the safe default.
            final riskLevel = state.extra is RiskLevel
                ? state.extra as RiskLevel
                : RiskLevel.highRisk;
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
        GoRoute(
          name: RouteName.keepApps,
          path: '/keepApps',
          pageBuilder: (context, state) {

            return CupertinoPage(
              key: state.pageKey,
              child: KeepAppsScreen(),
            );
          },
        ),
        GoRoute(
          name: RouteName.trustedApps,
          path: '/trustedApps',
          pageBuilder: (context, state) {

            return CupertinoPage(
              key: state.pageKey,
              child: TrustedAppsScreen(),
            );
          },
        ),
        GoRoute(
          name: RouteName.groupPermission,
          path: '/groupPermission',
          pageBuilder: (context, state) {

            return CupertinoPage(
              key: state.pageKey,
              child: GroupPermissionsScreen(),
            );
          },
        ),

        GoRoute(
          name: RouteName.recentApps,
          path: '/recentApps',
          pageBuilder: (context, state) {

            return CupertinoPage(
              key: state.pageKey,
              child: RecentAppsScreen(),
            );
          },
        ),
        GoRoute(
          name: RouteName.permissionDetail,
          path: '/permissionDetail',
          pageBuilder: (context, state) {
            final permissionGroup = state.extra as PermissionGroupType;

            return CupertinoPage(
              key: state.pageKey,
              child: PermissionDetailScreen(
                groupType: permissionGroup,

              ),
            );
          },
        ),
        GoRoute(
          name: RouteName.specialPermission,
          path: '/specialPermission',
          pageBuilder: (context, state) {

            return CupertinoPage(
              key: state.pageKey,
              child: SpecialPermissionScreen(),
            );
          },
        ),
        GoRoute(
          name: RouteName.specialPermissionDetail,
          path: '/specialPermissionDetail',
          pageBuilder: (context, state) {
            final type = state.extra as SpecialPermissionType;

            return CupertinoPage(
              key: state.pageKey,

              child: SpecialPermissionDetailScreen(
                type:type
              ),
            );
          },
        ),
        GoRoute(
          name: RouteName.dashboardPermission,
          path: '/dashboardPermission',
          pageBuilder: (context, state) {

            return CupertinoPage(
              key: state.pageKey,

              child: DashboardPermissionScreen(),
            );
          },
        ),

      ],
    ),
  ],
);}

