import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/core/servises/recent_apps_service.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:Privio/logic/app_permission/app_permission_state.dart';
import 'package:Privio/presentation/apps_permission/recently_apps/widgets/recent_item.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/presentation/utils/empty_page_widget.dart';

class RecentAppsScreen extends StatefulWidget {
  const RecentAppsScreen({super.key});

  @override
  State<RecentAppsScreen> createState() => _RecentAppsScreenState();
}

class _RecentAppsScreenState extends State<RecentAppsScreen> {
  late final Future<List<dynamic>> _future = RecentAppsService.getTodayRecentApps();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
        builder: (context, state) {
          if (state is! AppPermissionLoaded) {
            return const Center(
              child: CustomDotsLoader(
                svgPath1: 'assets/utils/Property 1=1 (1).svg',
                svgPath2: 'assets/utils/Property 1=2 (1).svg',
                svgPath3: 'assets/utils/Property 1=3 (1).svg',
                svgPath4: 'assets/utils/Property 1=4 (1).svg',
              ),
            );
          }

          return FutureBuilder<List<dynamic>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CustomDotsLoader(
                    svgPath1: 'assets/utils/Property 1=1 (1).svg',
                    svgPath2: 'assets/utils/Property 1=2 (1).svg',
                    svgPath3: 'assets/utils/Property 1=3 (1).svg',
                    svgPath4: 'assets/utils/Property 1=4 (1).svg',
                  ),
                );
              }

              if (snapshot.hasError) {
                return _errorState(snapshot.error, l10n);
              }

              final recentRaw = snapshot.data ?? [];

              final items = recentRaw.map((recent) {
                final pkg = recent['package'] as String?;
                if (pkg == null) return null;

                final app = state.allApps.firstWhereOrNull(
                      (a) => a.packageName == pkg,
                );
                if (app == null) return null;

                return _RecentItem(
                  app: app,
                  lastUsed: recent['lastTimeUsed'] ?? 0,
                  foregroundTime: recent['foregroundTime'] ?? 0,
                );
              }).whereType<_RecentItem>().toList();

              if (items.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppBarWidget(
                      text: l10n.recentApps,
                      ontap: () => context.pop(),
                    ),
                    Flexible(
                      child: EmptyPageWidget(text: l10n.noAppsUsedToday),
                    ),
                  ],
                );
              }

              items.sort((a, b) => b.lastUsed.compareTo(a.lastUsed));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppBarWidget(
                    text: l10n.usageTime,
                    ontap: () => context.pop(),
                  ),
                  SizedBox(height: AppSize.height * 0.015),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSize.width * 0.04),
                    child: _summaryCard(items, l10n),
                  ),
                  SizedBox(height: AppSize.height * 0.03),
                  Padding(
                    padding: EdgeInsets.only(left: AppSize.width * 0.04),
                    child: Text(
                      l10n.recentApps,
                      style: AppTextStyle.summary(context),
                    ),
                  ),
                  SizedBox(height: AppSize.height * 0.03),
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSize.width * 0.04),
                        child: Divider(
                          color: Colors.orange,
                          height: AppSize.height * 0.04,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        return _recentItem(items[index]);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _summaryCard(List<_RecentItem> items, AppLocalizations l10n) {
    final totalApps = items.length;
    final highRiskCount = items
        .where((e) => e.app.riskLevel == RiskLevel.highRisk)
        .length;
    final totalTime = items.fold<int>(0, (sum, e) => sum + e.foregroundTime);

    return Container(
      padding: EdgeInsets.all(AppSize.width * 0.04),
      decoration: BoxDecoration(
        color: AppColor.CartDark,
        borderRadius: BorderRadius.circular(AppSize.width * 0.035),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.todaySummary, style: AppTextStyle.summary(context)),
          SizedBox(height: AppSize.height * 0.01),
          _summaryRow(l10n.appsUsedToday, '$totalApps'),
          _summaryRow(l10n.highRiskAppsUsed, '$highRiskCount'),
          _summaryRow(l10n.totalUsage, formatDuration(totalTime)),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.height * 0.008),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white54,
                fontSize: AppSize.width * 0.03,
              ),
            ),
          ),
          Text(value, style: AppTextStyle.summaryValue(context)),
        ],
      ),
    );
  }

  Widget _recentItem(_RecentItem item) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecentItem(
            icon: Image.memory(
              base64Decode(item.app.iconBase64),
              width: AppSize.width * 0.1,
              height: AppSize.width * 0.1,
            ),
            appName: item.app.appName,
            packageName: item.app.packageName,
            permissions: item.app.permissions,
            riskLevel: item.app.riskLevel,
            formData: formatTime(item.lastUsed),
            formatDuration: formatDuration(item.foregroundTime),
          ),
          SizedBox(height: AppSize.height * 0.008),
        ],
      ),
    );
  }

  Widget _errorState(Object? error, AppLocalizations l10n) {
    return Center(
      child: Text(
        l10n.somethingWentWrong,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}

class _RecentItem {
  final dynamic app;
  final int lastUsed;
  final int foregroundTime;

  _RecentItem({
    required this.app,
    required this.lastUsed,
    required this.foregroundTime,
  });
}

String formatTime(int millis) {
  if (millis <= 0) return '--:--';
  final d = DateTime.fromMillisecondsSinceEpoch(millis);
  return '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

String formatDuration(int millis) {
  if (millis <= 0) return '0m';
  final d = Duration(milliseconds: millis);
  if (d.inMinutes < 1) return '${d.inSeconds}s';
  if (d.inHours < 1) return '${d.inMinutes}m';
  return '${d.inHours}h ${d.inMinutes.remainder(60)}m';
}