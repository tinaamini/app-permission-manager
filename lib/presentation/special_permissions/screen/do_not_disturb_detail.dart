import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/constant/specialPermissionType.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:Privio/core/servises/app_special_permiision_service.dart';
import 'package:Privio/core/utils/special_permission_risk_resolver.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/special_permissions/widget/helper_widgets.dart';
import 'package:Privio/presentation/utils/app_size.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/presentation/utils/empty_page_widget.dart';

class DoNotDisturbDetail extends StatefulWidget {
  const DoNotDisturbDetail({super.key});

  @override
  State<DoNotDisturbDetail> createState() => _DoNotDisturbDetailState();
}

class _DoNotDisturbDetailState extends State<DoNotDisturbDetail>
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.all(AppSize.width * 0.04),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        key: _refreshKey,
        future: AppSpecialPermissionPlatform().getDoNotDisturbApps(),
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

          final apps = snapshot.data ?? [];

          final RiskLevel level = SpecialPermissionRiskResolver.fromCount(
            type: SpecialPermissionType.doNotDisturb,
            count: apps.length,
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sectionTitle(l10n.doNotDisturb, context),
              paragraph(l10n.doNotDisturbDesc, context),
              SizedBox(height: AppSize.height * 0.02),
              riskBadge(level: level, context),
              SizedBox(height: AppSize.height * 0.03),
              actionButton(
                context: context,
                text: l10n.openDoNotDisturbSettings,
                onTap: () {
                  AppSpecialPermissionPlatform().openDoNotDisturbSettings();
                },
              ),
              SizedBox(height: AppSize.height * 0.04),
              sectionTitle(l10n.appsWithDoNotDisturb, context),
              SizedBox(height: AppSize.height * 0.015),
              Expanded(
                child: apps.isEmpty
                    ? Center(
                  child: EmptyPageWidget(
                    text: l10n.noAppsWithDoNotDisturb,
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
                          Icons.do_not_disturb_on,
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