import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:permissions_app/constant/app_color.dart';
import 'package:permissions_app/constant/app_style.dart';
import 'package:permissions_app/constant/risk_level.dart';
import 'package:permissions_app/core/servises/recent_apps_service.dart';
import 'package:permissions_app/logic/app_permission/app_permission_cubit.dart';
import 'package:permissions_app/logic/app_permission/app_permission_state.dart';
import 'package:permissions_app/presentation/apps_permission/recently_apps/widgets/recent_item.dart';
import 'package:permissions_app/presentation/home/widgets/app_bar.dart';
import 'package:permissions_app/presentation/utils/base_screen.dart';
import 'package:permissions_app/presentation/utils/custome_dotsloader.dart';
import 'package:permissions_app/presentation/utils/empty_page_widget.dart';

class RecentAppsScreen extends StatefulWidget {
  const RecentAppsScreen({super.key});

  @override
  State<RecentAppsScreen> createState() => _RecentAppsScreenState();
}

class _RecentAppsScreenState extends State<RecentAppsScreen> {
  late final Future<List<dynamic>> _future = RecentAppsService.getTodayRecentApps();

  @override
  Widget build(BuildContext context) {
    return  BaseScreen(
      child: BlocBuilder<AppPermissionCubit, AppPermissionState>(
            builder: (context, state) {
              if (state is! AppPermissionLoaded) {
                return  const  Center(
                    child: CustomDotsLoader(
                        svgPath1:
                        'assets/utils/Property 1=1 (1).svg',
                        svgPath2: 'assets/utils/Property 1=2 (1).svg',
                        svgPath3: 'assets/utils/Property 1=3 (1).svg',
                        svgPath4:
                        'assets/utils/Property 1=4 (1).svg'));
              }

              return FutureBuilder<List<dynamic>>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return  const  Center(
                        child: CustomDotsLoader(
                            svgPath1:
                            'assets/utils/Property 1=1 (1).svg',
                            svgPath2: 'assets/utils/Property 1=2 (1).svg',
                            svgPath3: 'assets/utils/Property 1=3 (1).svg',
                            svgPath4:
                            'assets/utils/Property 1=4 (1).svg'));
                  }

                  if (snapshot.hasError) {
                    return _errorState(snapshot.error);
                  }

                  final recentRaw = snapshot.data ?? [];

                  final items = recentRaw
                      .map((recent) {
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
                  })
                      .whereType<_RecentItem>()
                      .toList();

                  if (items.isEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBarWidget(text: "RECENT APPS", ontap:(){
                          context.pop();
                        }, ),
                        Flexible(child: EmptyPageWidget(text: 'No apps used today', )),
                      ],
                    );
                  }

                  items.sort(
                        (a, b) => b.lastUsed.compareTo(a.lastUsed),
                  );

                  return
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppBarWidget(text: "RECENT APPS", ontap:(){
                          context.pop();
                        }, ),
                        SizedBox(height: 12.h),
                        Padding(  padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: _summaryCard(items)),
                        SizedBox(height: 26.h),
                        Padding(
                          padding:  EdgeInsets.only(left: 16.w),
                          child: Text("Recent apps",style: AppTextStyle.summary,),
                        ),
                        SizedBox(height: 26.h),
                        Expanded(
                          child: ListView.separated(
                            itemCount: items.length,
                            separatorBuilder: (_, __) =>
                                Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: 16.w),
                                  child: Divider(color: Colors.orange, height: 40.h),
                                ),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _recentItem(item);
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

  // ================= UI PARTS =================
  Widget _summaryCard(List<_RecentItem> items) {
    final totalApps = items.length;
    final highRiskCount = items
        .where((e) => e.app.riskLevel == RiskLevel.highRisk)
        .length;

    final totalTime = items.fold<int>(
      0,
          (sum, e) => sum + e.foregroundTime,
    );

    return Container(
      padding:  EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.CartDark,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today Summary',
            style:AppTextStyle.summary
          ),
          SizedBox(height: 8.h),
          _summaryRow('Apps used today', '$totalApps',),
          _summaryRow('High risk apps used', '$highRiskCount'),
          _summaryRow('Total usage', formatDuration(totalTime)),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,  maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white54, fontSize: 12.sp)),
          ),
          Text(value,
           style:AppTextStyle.summaryValue),
        ],
      ),
    );
  }

  Widget _recentItem(_RecentItem item) {
    return Padding(
  padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecentItem(
            icon: Image.memory(
              base64Decode(item.app.iconBase64),
              width: 40,
              height: 40,
            ),
            appName: item.app.appName,
            packageName: item.app.packageName,
            permissions: item.app.permissions,
            riskLevel: item.app.riskLevel, formData: '${formatTime(item.lastUsed)}', formatDuration: '${formatDuration(item.foregroundTime)}',
       ),
          SizedBox(height: 6.h),
          // Text(
          //   'Last used at ${formatTime(item.lastUsed)} · '
          //       'Used today ${formatDuration(item.foregroundTime)}',
          //   style: TextStyle(color: Colors.white54, fontSize: 12.sp),
          // ),
          SizedBox(height: 6.h),
        ],
      ),
    );
  }

  Widget _errorState(Object? error) {
    return Center(
      child: Text(
        'Something went wrong\n$error',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}

// ================= HELPERS =================

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
