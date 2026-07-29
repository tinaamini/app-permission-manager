
import 'package:Privio/logic/utils/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/routs/rout.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'core/servises/app_special_permiision_service.dart';
import 'core/utils/onboarding_storage.dart';
import 'logic/app_permission/app_permission_cubit.dart';
import 'logic/app_permission/app_permission_state.dart';
import 'logic/locale/locale_cubit.dart';
import 'logic/onboarding/onboarding_cubit.dart';
import 'logic/onboarding/show_onboarding/show_onboarding_cubit.dart';
import 'logic/special_permission/special_permission_cubit.dart';
import 'logic/utils/scan/scan_cubit.dart';
import 'routs/rout_name.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await _precacheSvgs();

  await Hive.initFlutter();
  await Hive.openBox('app_preferences');
  final appSettingsBox = await Hive.openBox('app_settings');
  final themeBox = await Hive.openBox('theme');

  final storage = OnboardingStorage();

  final onboardingShowCubit = OnboardingShowCubit(storage);
  await onboardingShowCubit.load();

  final router = createRouter(onboardingShowCubit);

  runApp(
    MainApp(
      router: router,
      storage: storage,
      onboardingShowCubit: onboardingShowCubit,
      themeBox: themeBox,
      appSettingsBox: appSettingsBox,
    ),
  );
}

class MainApp extends StatelessWidget {
  final GoRouter router;
  final OnboardingStorage storage;
  final OnboardingShowCubit onboardingShowCubit;
  final Box themeBox;
  final Box appSettingsBox;

  const MainApp({
    super.key,
    required this.router,
    required this.storage,
    required this.onboardingShowCubit,
    required this.themeBox,
    required this.appSettingsBox,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: onboardingShowCubit),
        BlocProvider<BtnLanguageCubit>(
          create: (_) => BtnLanguageCubit(
            initialIndex:
                appSettingsBox.get(LocaleCubit.storageKey, defaultValue: 'fa') ==
                        'en'
                    ? 0
                    : 1,
          ),
        ),
        BlocProvider<AppPermissionCubit>(
          create: (_) => AppPermissionCubit(),
        ),
        BlocProvider<SpecialPermissionCubit>(
          create: (_) => SpecialPermissionCubit(AppSpecialPermissionPlatform()),
        ),
        BlocProvider<LocaleCubit>(
          create: (_) => LocaleCubit(appSettingsBox),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(themeBox),
        ),
        BlocProvider(
          create: (_) => ScanCubit()..loadLastScan(),
        )
      ],
      child: _AppBootstrap(router: router),
    );
  }
}
Future<void> _precacheSvgs() async {
  const paths = [
    'assets/utils/eye.svg',
    'assets/utils/shield-search.svg',
    'assets/utils/lock.svg',
    'assets/utils/emoji-sad.svg',
    'assets/utils/global.svg',
    'assets/utils/Property 1=1 (1).svg',
    'assets/utils/Property 1=2 (1).svg',
    'assets/utils/Property 1=3 (1).svg',
    'assets/utils/Property 1=4 (1).svg',
    'assets/main/danger.svg',
    'assets/main/danger_alert.svg',
    'assets/main/low.svg',
    'assets/main/safe_alert.svg',
    'assets/main/grid.svg',
    'assets/main/warning_alert.svg',
    'assets/main/layer.svg',
    'assets/main/varning.svg',
    'assets/main/chart.svg',
    "assets/main/back_icon.svg",
    "assets/dashboard/clock.svg",
    "assets/dashboard/shield-tick.svg",
    'assets/app_permission/noRisk.svg',
    'assets/app_permission/lowRisk.svg',
    'assets/app_permission/mediumRisk.svg',
    'assets/app_permission/highRisk.svg',
    'assets/app_permission/keep.svg',
    'assets/app_permission/trust.svg',
    'assets/app_permission/recent.svg',
    "assets/app_permission/tick-square.svg",
    "assets/app_permission/danger.svg",
    "assets/app_permission/shield-tick.svg",

  ];

  for (final path in paths) {
    try {
      final loader = SvgAssetLoader(path);
      await svg.cache.putIfAbsent(
        loader.cacheKey(null),
            () => loader.loadBytes(null),
      );
    } catch (e) {
      debugPrint('SVG cache failed: $path → $e');
    }
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
     AppSize.init(context);

    if (_started) return;
    _started = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAndOpenPendingApp();
      context.read<SpecialPermissionCubit>().loadStatus();
    });
  }

  Future<void> _loadAndOpenPendingApp() async {
    final cubit = context.read<AppPermissionCubit>();
    await cubit.loadApps();
    if (!mounted || cubit.state is! AppPermissionLoaded) return;
    final packageName = await const MethodChannel('notification_navigation')
        .invokeMethod<String>('getPendingPackage');
    if (!mounted || packageName == null) return;
    final apps = (cubit.state as AppPermissionLoaded).allApps;
    final matching = apps.where((item) => item.packageName == packageName);
    if (matching.isNotEmpty) {
      widget.router.pushNamed(RouteName.appDetail, extra: matching.first);
    }
  }
  @override
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 917),
      minTextAdapt: true,
      builder: (context, child) {
        return BlocBuilder<LocaleCubit, Locale>(
          builder: (context, locale) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: widget.router,
              locale: locale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('fa'),
              ],
            );
          },
        );
      },
    );
  }

}
