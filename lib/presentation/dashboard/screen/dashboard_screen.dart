import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:permissions_app/core/models/app_permission_item.dart';
import 'package:permissions_app/core/models/scan_model.dart';
import 'package:permissions_app/core/servises/dashboard.dart';
import 'package:permissions_app/core/servises/dashboard_permission_service.dart';
import 'package:permissions_app/core/servises/scan_service.dart';
import 'package:permissions_app/core/servises/scan_storage_hive.dart';
import 'package:permissions_app/core/utils/scan_diff.dart';
import 'package:permissions_app/generated/app_localizations.dart';

import 'package:permissions_app/presentation/dashboard/widget/alert_section_widget.dart';
import 'package:permissions_app/presentation/dashboard/widget/since_last_scan_widget.dart';
import 'package:permissions_app/presentation/dashboard/widget/system_privacy_dashboard_card.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/utils/app_size.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';

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
    if (!mounted) return;

    setState(() {
      _lastScanTime = last == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(last.timestampMs);
      _scanDiff = null;
    });
  }

  Future<void> _runScan() async {
    if (_scanning) return;
    setState(() => _scanning = true);

    try {
      final prev = await ScanStorageHive.loadLastSnapshot();
      final curr = await ScanService.takeSnapshot();

      await ScanStorageHive.saveLastSnapshot(curr);

      if (!mounted) return;

      setState(() {
        _lastScanTime = DateTime.fromMillisecondsSinceEpoch(curr.timestampMs);
        _scanDiff = (prev == null) ? null : diffSnapshots(prev, curr);
        _scanning = false;
      });
    } catch (_) {
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
          ),

          SizedBox(height: AppSize.height * 0.025),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width * 0.05,
            ),
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.width * 0.05,
              ),
              child: Column(
                children: [
                  SystemPrivacyDashboardCard(),

                  SizedBox(height: AppSize.height * 0.02),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _loadingAlerts
                              ? const Center(
                            child: CustomDotsLoader(
                              svgPath1:
                              'assets/utils/Property 1=1 (1).svg',
                              svgPath2:
                              'assets/utils/Property 1=2 (1).svg',
                              svgPath3:
                              'assets/utils/Property 1=3 (1).svg',
                              svgPath4:
                              'assets/utils/Property 1=4 (1).svg',
                            ),
                          )
                              : SafeAlertSectionWidget(
                            accessibilityOn: _accessibilityOn,
                            apps: _appsForAlerts,
                          ),

                          SizedBox(height: AppSize.height * 0.022),

                          SinceLastScanWidget(
                            diff: _scanDiff,
                            lastScanTime: _lastScanTime,
                            scanning: _scanning,
                            onRunScan: _runScan,
                            selectedTab: _scanTab,
                            onTabChange: (t) =>
                                setState(() => _scanTab = t),
                          ),

                          SizedBox(height: AppSize.height * 0.03),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
