import 'dart:convert';

import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/constant/specialPermissionType.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:Privio/core/servises/app_special_permiision_service.dart';
import 'package:Privio/core/servises/special_permission_cache_service.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/presentation/utils/empty_page_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisplayOverAppsDetail extends StatefulWidget {
  const DisplayOverAppsDetail({super.key});

  @override
  State<DisplayOverAppsDetail> createState() => _DisplayOverAppsDetailState();
}

class _DisplayOverAppsDetailState extends State<DisplayOverAppsDetail>
    with WidgetsBindingObserver {
  List<Map<String, dynamic>>? _apps;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _refresh();
  }

  Future<void> _load() async {
    final cached = await SpecialPermissionCacheService.loadApps(
      SpecialPermissionType.displayOverApps,
    );
    if (!mounted) return;
    setState(() {
      _apps = cached;
      _loading = false;
    });
    // بعد از کش، native با آیکون
    _refresh();
  }

  Future<void> _refresh() async {
    final fresh = await SpecialPermissionCacheService.refreshApps(
      SpecialPermissionType.displayOverApps,
    );
    if (!mounted) return;
    setState(() => _apps = fresh);
  }

  RiskLevel _overlayLevel(int count) {
    return count > 0 ? RiskLevel.mediumRisk : RiskLevel.noRisk;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.all(AppSize.width * 0.04),
      child: _loading
          ? const Center(
              child: CustomDotsLoader(
                svgPath1: 'assets/utils/Property 1=1 (1).svg',
                svgPath2: 'assets/utils/Property 1=2 (1).svg',
                svgPath3: 'assets/utils/Property 1=3 (1).svg',
                svgPath4: 'assets/utils/Property 1=4 (1).svg',
              ),
            )
          : _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    final apps = _apps ?? [];

    if (apps.isEmpty) {
      return Center(
        child: EmptyPageWidget(text: l10n.noAppsWithOverlayPermission),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sectionTitle(l10n.displayOverOtherApps, context),
        paragraph(l10n.displayOverAppsDesc, context),
        SizedBox(height: AppSize.height * 0.02),
        riskBadge(level: _overlayLevel(apps.length), context),
        SizedBox(height: AppSize.height * 0.04),
        sectionTitle(l10n.appsWithOverlayPermission, context),
        SizedBox(height: AppSize.height * 0.015),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: ListView.separated(
              itemCount: apps.length,
              separatorBuilder: (_, __) => Divider(
                color:
                    context.isDark ? Colors.white12 : AppColor.textLight,
              ),
              itemBuilder: (context, index) {
                final app = apps[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: app['icon'] != null &&
                          (app['icon'] as String).isNotEmpty
                      ? Image.memory(
                          base64Decode(app['icon']),
                          width: AppSize.width * 0.1,
                          height: AppSize.width * 0.1,
                        )
                      : Icon(
                          Icons.layers,
                          color: context.isDark
                              ? Colors.white54
                              : AppColor.textLight,
                        ),
                  title: Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Text(
                      app['name'] ?? '',
                      style: AppTextStyle.appName(context),
                    ),
                  ),
                  subtitle: Text(
                    app['package'] ?? '',
                    style: AppTextStyle.lastScan(context).copyWith(
                      color: context.isDark
                          ? Colors.white54
                          : AppColor.textLight,
                      fontSize: AppSize.width * 0.03,
                    ),
                  ),
                  trailing: Padding(
                    padding: EdgeInsets.only(top: 25.h),
                    child: Icon(
                      Icons.settings_outlined,
                      color: context.isDark
                          ? Colors.white54
                          : AppColor.textLight,
                      size: 24,
                    ),
                  ),
                  onTap: () {
                    AppSpecialPermissionPlatform()
                        .openAppOverlaySettings(app['package']);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
