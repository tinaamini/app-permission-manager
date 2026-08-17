import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:Privio/core/models/app_permission_item.dart';
import 'package:Privio/core/models/scan_model.dart';
import 'package:Privio/core/servises/dashboard.dart';
import 'package:Privio/core/servises/dashboard_permission_service.dart';
import 'package:Privio/core/servises/scan_service.dart';
import 'package:Privio/core/servises/scan_storage_hive.dart';
import 'package:Privio/core/utils/scan_diff.dart';
import 'package:Privio/generated/app_localizations.dart';

import 'package:Privio/presentation/dashboard/widget/alert_section_widget.dart';
import 'package:Privio/presentation/dashboard/widget/since_last_scan_widget.dart';
import 'package:Privio/presentation/dashboard/widget/system_privacy_dashboard_card.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Privio/logic/utils/scan/scan_cubit.dart';

class DashboardPermissionScreen extends StatefulWidget {
  const DashboardPermissionScreen({super.key});

  @override
  State<DashboardPermissionScreen> createState() =>
      _DashboardPermissionScreenState();
}

class _DashboardPermissionScreenState extends State<DashboardPermissionScreen>
    with WidgetsBindingObserver {
  bool _loadingAlerts = true;
  bool _accessibilityOn = false;
  List<AppPermissionItem> _appsForAlerts = const [];

  ScanDiff? _scanDiff;
  DateTime? _lastScanTime;
  bool _scanning = false;
  ScanTab _scanTab = ScanTab.newApps;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAlerts();
    _loadLastScan();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      DashboardPermissionService.clearCache();
      _loadAlerts(showLoader: false);
      _loadLastScan();
    }
  }

  Future<void> _loadAlerts({bool showLoader = true}) async {
    if (showLoader) setState(() => _loadingAlerts = true);

    try {
      final access = await SafeDashboardPlatform.isAccessibilityEnabled();
      final apps = await DashboardPermissionService.loadAppsWithLocation();

      if (!mounted) return;
      setState(() {
        _accessibilityOn = access;
        _appsForAlerts = apps;
        _loadingAlerts = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingAlerts = false);
    }
  }

  Future<void> _loadLastScan() async {
    final last = await ScanStorageHive.loadLastSnapshot();
    final diff = await ScanStorageHive.loadLastDiff();
    if (!mounted) return;

    setState(() {
      _lastScanTime = last == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(last.timestampMs);
      _scanDiff = diff;
    });
  }

  Future<void> _runScan() async {
    if (_scanning) return;
    setState(() => _scanning = true);

    try {
      final prev = await ScanStorageHive.loadLastSnapshot();
      final curr = await ScanService.takeSnapshot();
      final diff = (prev == null) ? null : diffSnapshots(prev, curr);
      if (diff != null) await ScanStorageHive.saveLastDiff(diff);

      await ScanStorageHive.saveLastSnapshot(curr);

      if (!mounted) return;

      setState(() {
        _lastScanTime = DateTime.fromMillisecondsSinceEpoch(curr.timestampMs);
        _scanDiff = diff;
        _scanning = false;
      });

      if (mounted) {
        context.read<ScanCubit>().loadLastScan();
        await context.read<AppPermissionCubit>().refreshAll();
      }    } catch (_) {
      if (!mounted) return;
      setState(() => _scanning = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      child: Column(
        children: [
          AppBarWidget(
            text: l10n.dashboardPermission,
            ontap: () => context.pop(),
            showBack: true,
            showHome: false,
          ),
          SizedBox(height: AppSize.height * 0.02),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SystemPrivacyDashboardCard(),
                    SizedBox(height: 16),
                    _loadingAlerts
                        ? const Center(
                            child: CustomDotsLoader(
                              svgPath1: 'assets/utils/Property 1=1 (1).svg',
                              svgPath2: 'assets/utils/Property 1=2 (1).svg',
                              svgPath3: 'assets/utils/Property 1=3 (1).svg',
                              svgPath4: 'assets/utils/Property 1=4 (1).svg',
                            ),
                          )
                        : SafeAlertSectionWidget(
                            accessibilityOn: _accessibilityOn,
                            apps: _appsForAlerts,
                          ),
                    SizedBox(height: 20),
                    SinceLastScanWidget(
                      diff: _scanDiff,
                      lastScanTime: _lastScanTime,
                      scanning: _scanning,
                      onRunScan: _runScan,
                      selectedTab: _scanTab,
                      onTabChange: (t) => setState(() => _scanTab = t),
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
