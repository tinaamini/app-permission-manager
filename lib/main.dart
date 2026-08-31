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
import 'package:Privio/constant/risk_level.dart';
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

  // Do not keep the native splash visible while parsing all SVG assets.
  // Cache them only after the first Flutter frame has been rendered.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _precacheSvgs();
  });
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
            initialIndex: LocaleCubit.initialLanguageIndex(appSettingsBox),
          ),
        ),
        BlocProvider<SpecialPermissionCubit>(
          create: (_) => SpecialPermissionCubit(AppSpecialPermissionPlatform()),
        ),
        BlocProvider<ScanCubit>(
          create: (_) => ScanCubit()..loadLastScan(),
        ),
        BlocProvider<AppPermissionCubit>(
          create: (context) => AppPermissionCubit(context.read<ScanCubit>()),
        ),
        BlocProvider<LocaleCubit>(
          create: (_) => LocaleCubit(appSettingsBox),
        ),
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(themeBox),
        ),
      ],
      child: _AppBootstrap(router: router),
    );
  }
}
Future<void> _precacheSvgs() async {
  const paths = [
    'assets/utils/pageLight1.svg',
    'assets/utils/pageDark1.svg',
    'assets/utils/emoji-sad.svg',
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

class _AppBootstrapState extends State<_AppBootstrap>
    with WidgetsBindingObserver {
  static const _navigationChannel = MethodChannel('notification_navigation');
  bool _started = false;
  bool _handlingPendingNavigation = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _navigationChannel.setMethodCallHandler(_handleNativeNavigation);
  }

  Future<dynamic> _handleNativeNavigation(MethodCall call) async {
    if (call.method != 'shortcutRoute') return null;
    final route = call.arguments as String?;
    if (route != null) await _openShortcutRoute(route);
    return null;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    if (!mounted) return;
    if (locales != null && locales.isNotEmpty) {
      context.read<LocaleCubit>().syncWithSystemLocale(locales.first);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppSize.init(context);

    if (_started) return;
    _started = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handlePendingNavigation();
      context.read<SpecialPermissionCubit>().loadStatus();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _handlePendingNavigation();
    }
  }

  @override
  void dispose() {
    _navigationChannel.setMethodCallHandler(null);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _handlePendingNavigation() async {
    if (_handlingPendingNavigation) return;
    if (context.read<OnboardingShowCubit>().state != OnboardingStatus.done) {
      return;
    }
    _handlingPendingNavigation = true;

    try {
      // Open launcher shortcuts immediately. Their destination screens show a
      // loader while app data is populated in the background.
      final openedShortcut = await _checkPendingShortcut();
      if (openedShortcut) {
        return;
      }

      await _loadAndOpenPendingApp();
    } finally {
      _handlingPendingNavigation = false;
    }
  }


  Future<void> _loadAndOpenPendingApp() async {
    final packageName = await const MethodChannel('notification_navigation')
        .invokeMethod<String>('getPendingPackage');
    debugPrint('🔔 packageName from native: $packageName');

    final cubit = context.read<AppPermissionCubit>();

    if (packageName != null) {
      await cubit.refreshAll();
    } else {
      await cubit.loadApps();
    }

    if (!mounted || cubit.state is! AppPermissionLoaded) return;
    if (packageName == null) return;

    final apps = (cubit.state as AppPermissionLoaded).allApps;
    final matching = apps.where((item) => item.packageName == packageName);
    debugPrint('🔔 matching count: ${matching.length}');
    if (matching.isNotEmpty) {
      widget.router.pushNamed(RouteName.appDetail, extra: matching.first);
    }
  }

  Future<bool> _checkPendingShortcut() async {
    final route = await _navigationChannel.invokeMethod<String>(
      'getPendingShortcutRoute',
    );
    debugPrint('🔗 shortcut route from native: $route');
    if (route == null || !mounted) return false;

    await _openShortcutRoute(route);
    return true;
  }

  Future<void> _openShortcutRoute(String route) async {
    if (!mounted ||
        context.read<OnboardingShowCubit>().state != OnboardingStatus.done) {
      return;
    }

    // Hydrate the shared state from Hive before opening the shortcut page.
    // When cache exists, loadApps returns immediately after emitting it and
    // continues refreshing native data in the background.
    await context.read<AppPermissionCubit>().loadApps();
    if (!mounted) return;

    if (route == RouteName.riskApps) {
      widget.router.pushNamed(route, extra: RiskLevel.highRisk);
    } else {
      widget.router.pushNamed(route);
    }
  }

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
