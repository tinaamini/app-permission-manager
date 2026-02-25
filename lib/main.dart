// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hive_flutter/hive_flutter.dart';
//
// import 'package:permissions_app/routs/rout.dart';
// import 'package:permissions_app/core/servises/app_special_permiision_service.dart';
// import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
// import 'package:permissions_app/logic/special_permission/special_permission_cubit.dart';
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await Hive.initFlutter();
//   await Hive.openBox('app_preferences');
//
//   runApp(const MainApp());
// }
//
// class MainApp extends StatelessWidget {
//   const MainApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AppPermissionCubit>(
//           create: (_) => AppPermissionCubit(),
//         ),
//         BlocProvider<SpecialPermissionCubit>(
//           create: (_) => SpecialPermissionCubit(
//             AppSpecialPermissionPlatform(),
//           ),
//         ),
//       ],
//       child: const _AppBootstrap(),
//     );
//   }
// }
//
// class _AppBootstrap extends StatefulWidget {
//   const _AppBootstrap();
//
//   @override
//   State<_AppBootstrap> createState() => _AppBootstrapState();
// }
//
// class _AppBootstrapState extends State<_AppBootstrap> {
//   bool _started = false;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     if (_started) return;
//     _started = true;
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<AppPermissionCubit>().loadApps();
//       context.read<SpecialPermissionCubit>().loadStatus();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return ScreenUtilInit(
//       designSize: const Size(412, 917),
//       minTextAdapt: true,
//       builder: (context, child) {
//         return MaterialApp.router(
//           debugShowCheckedModeBanner: false,
//           routerConfig: router,
//         );
//       },
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permissions_app/routs/rout.dart';

import 'core/servises/app_special_permiision_service.dart';
import 'core/utils/onboarding_storage.dart';
import 'logic/app_permission/app_permission_cubit.dart';
import 'logic/onboarding/show_onboarding/show_onboarding_cubit.dart';
import 'logic/special_permission/special_permission_cubit.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('app_preferences');
  await Hive.openBox('app_settings');
  final storage = OnboardingStorage();
  final onboardingShowCubit = OnboardingShowCubit(storage);
  await onboardingShowCubit.load();

  final router = createRouter(onboardingShowCubit);

  runApp( MainApp(
    router: router,
    storage: storage,
    onboardingShowCubit: onboardingShowCubit,));
}
class MainApp extends StatelessWidget {
  final GoRouter router;
  final OnboardingStorage storage;
  final OnboardingShowCubit onboardingShowCubit;

  const MainApp({
    super.key,
    required this.router,
    required this.storage,
    required this.onboardingShowCubit,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: onboardingShowCubit),

        BlocProvider<AppPermissionCubit>(
          create: (_) => AppPermissionCubit(),
        ),
        BlocProvider<SpecialPermissionCubit>(
          create: (_) => SpecialPermissionCubit(AppSpecialPermissionPlatform()),
        ),
      ],
      child: _AppBootstrap(router: router),
    );
  }
}

class _AppBootstrap extends StatefulWidget {
  final GoRouter router;
  const _AppBootstrap({required this.router});

  @override
  State<_AppBootstrap> createState() => _AppBootstrapState();
}

class _AppBootstrapState extends State<_AppBootstrap> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppPermissionCubit>().loadApps();
      context.read<SpecialPermissionCubit>().loadStatus();
    });
  }
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,

        builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: widget.router,
        );
      },
    );
  }
}