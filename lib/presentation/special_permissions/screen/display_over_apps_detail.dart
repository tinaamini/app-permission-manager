import 'dart:convert';

import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:Privio/core/servises/app_special_permiision_service.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:Privio/presentation/utils/app_size.dart';
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

  Key _refreshKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {
        _refreshKey = UniqueKey();
      });
    }
  }

  RiskLevel _overlayLevel(int count) {
    return count > 0 ? RiskLevel.mediumRisk : RiskLevel.noRisk;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.all(AppSize.width * 0.04),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        key: _refreshKey,
        future: AppSpecialPermissionPlatform().getOverlayApps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final apps = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle(l10n.displayOverOtherApps, context),
              paragraph(l10n.displayOverAppsDesc, context),
              SizedBox(height: AppSize.height * 0.02),
              riskBadge(level: _overlayLevel(apps.length), context),
              SizedBox(height: AppSize.height * 0.03),
              actionButton(
                context: context,
                text: l10n.openDisplayOverAppsSettings,
                onTap: () {
                  AppSpecialPermissionPlatform().openOverlaySettings();
                },
              ),
              SizedBox(height: AppSize.height * 0.04),
              sectionTitle(l10n.appsWithOverlayPermission, context),
              SizedBox(height: AppSize.height * 0.015),
              Expanded(
                child: apps.isEmpty
                    ? Center(
                  child: EmptyPageWidget(
                    text: l10n.appsWithOverlayPermission,
                  ),
                )
                    : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: ListView.separated(
                    itemCount: apps.length,
                    separatorBuilder: (_, __) => Divider(
                      color: context.isDark
                          ? Colors.white12
                          : AppColor.textLight,
                    ),
                    itemBuilder: (context, index) {
                      final app = apps[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: app['icon'] != null
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


                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}