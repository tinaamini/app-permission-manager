import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:permissions_app/core/models/app_permission_item.dart';
import 'package:permissions_app/core/models/scan_model.dart';
import 'package:permissions_app/core/servises/dashboard_permission_service.dart';
import 'package:permissions_app/core/servises/dashboard.dart'; // SafeDashboardPlatform
import 'package:permissions_app/core/servises/scan_storage_hive.dart';
import 'package:permissions_app/core/utils/scan_diff.dart';
import 'package:permissions_app/presentation/dashboard/widget/alert_section_widget.dart';
import 'package:permissions_app/presentation/dashboard/widget/disclaimer.dart';
import 'package:permissions_app/presentation/dashboard/widget/header_section_widget.dart';
import 'package:permissions_app/presentation/dashboard/widget/since_last_scan_widget.dart';
import 'package:permissions_app/presentation/dashboard/widget/system_privacy_dashboard_card.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';

enum AppRiskFilter { all, safe, review, sensitive }
enum AppRisk { safe, review, sensitive }

AppRisk computeRisk(AppPermissionItem a) {
  // 🔴 Sensitive
  if (a.locationState == 'always') return AppRisk.sensitive;

  // 🟡 Needs review (هر نوع location active)
  if (a.locationState == 'while_in_use') return AppRisk.review;

  // 🟢 Safe (denied/unknown)
  return AppRisk.safe;
}

class DashboardPermissionScreen extends StatefulWidget {
  const DashboardPermissionScreen({super.key});

  @override
  State<DashboardPermissionScreen> createState() =>
      _DashboardPermissionScreenState();
}

class _DashboardPermissionScreenState extends State<DashboardPermissionScreen>
    with WidgetsBindingObserver {
  ScanDiff? _scanDiff;
  DateTime? _lastScanTime;
  bool _scanning = false;
  ScanTab _scanTab = ScanTab.newApps;
  bool _loading = true;
  bool _accessibilityOn = false;
  List<AppPermissionItem> _apps = const [];

  AppRiskFilter _filter = AppRiskFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadAll();
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
      _loadAll(showLoader: false);
    }
  }
  Future<void> _loadLastScan() async {
    final last = await ScanStorageHive.loadLastSnapshot();
    if (!mounted) return;

    setState(() {
      _lastScanTime = last == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(last.timestampMs);
      _scanDiff = null; // هنوز مقایسه نشده
    });
  }

  Future<void> _runScan() async {
    if (_scanning) return;
    setState(() => _scanning = true);

    try {
      final prev = await ScanStorageHive.loadLastSnapshot();
      final curr = await DashboardPermissionService.takeSnapshot();

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

  Future<void> _loadAll({bool showLoader = true}) async {
    if (showLoader) setState(() => _loading = true);

    try {
      final access = await SafeDashboardPlatform.isAccessibilityEnabled();
      final apps = await DashboardPermissionService.loadAppsWithLocation();

      if (!mounted) return;
      setState(() {
        _accessibilityOn = access;
        _apps = apps;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  List<AppPermissionItem> get _filteredApps {
    if (_filter == AppRiskFilter.all) return _apps;

    return _apps.where((a) {
      final risk = computeRisk(a);
      switch (_filter) {
        case AppRiskFilter.safe:
          return risk == AppRisk.safe;
        case AppRiskFilter.review:
          return risk == AppRisk.review;
        case AppRiskFilter.sensitive:
          return risk == AppRisk.sensitive;
        case AppRiskFilter.all:
          return true;
      }
    }).toList();
  }

  ({int safe, int review, int sensitive}) get _counts {
    int safe = 0, review = 0, sensitive = 0;

    for (final a in _apps) {
      final r = computeRisk(a);
      if (r == AppRisk.safe) safe++;
      if (r == AppRisk.review) review++;
      if (r == AppRisk.sensitive) sensitive++;
    }

    return (safe: safe, review: review, sensitive: sensitive);
  }

  @override
  Widget build(BuildContext context) {
    final counts = _counts;

    return Scaffold(
      backgroundColor: const Color(0xFF0E0E0E),
      body: SafeArea(
        child: Column(
          children: [
            AppBarWidget(
              text: "DASHBOARD PERMISSION",
              ontap: () => context.pop(),
              width: 40,
            ),

            SizedBox(height: 20.h),
            SystemPrivacyDashboardCard(),
            SizedBox(height: 16.h),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderSection(),
                      SizedBox(height: 20.h),

                      SafeAlertSectionWidget(
                        accessibilityOn: _accessibilityOn,
                        apps: _apps,
                      ),

                      SizedBox(height: 18.h),

                      SinceLastScanWidget(
                        diff: _scanDiff,
                        lastScanTime: _lastScanTime,
                        scanning: _scanning,
                        onRunScan: _runScan,
                        selectedTab: _scanTab,
                        onTabChange: (t) => setState(() => _scanTab = t),
                      ),

                      SizedBox(height: 16.h),

                      // ✅ Apps list filtered

                      SizedBox(height: 24.h),
                      Disclaimer(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RiskFilterBar extends StatelessWidget {
  final AppRiskFilter selected;
  final void Function(AppRiskFilter) onSelect;

  final int allCount;
  final int safeCount;
  final int reviewCount;
  final int sensitiveCount;

  const RiskFilterBar({
    super.key,
    required this.selected,
    required this.onSelect,
    required this.allCount,
    required this.safeCount,
    required this.reviewCount,
    required this.sensitiveCount,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        _chip('All', allCount, AppRiskFilter.all),
        _chip('Safe', safeCount, AppRiskFilter.safe),
        _chip('Needs review', reviewCount, AppRiskFilter.review),
        _chip('Sensitive', sensitiveCount, AppRiskFilter.sensitive),
      ],
    );
  }

  Widget _chip(String label, int count, AppRiskFilter value) {
    final isSelected = selected == value;

    return InkWell(
      borderRadius: BorderRadius.circular(999.r),
      onTap: () => onSelect(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.12)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: isSelected
                ? Colors.white.withOpacity(0.25)
                : Colors.transparent,
          ),
        ),
        child: Text(
          '$label ($count)',
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w700,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
