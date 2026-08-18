import 'dart:convert';

import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/constant/permissionConst.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:Privio/core/models/app_permission_ui.dart';
import 'package:Privio/core/servises/app_permission_service.dart';
import 'package:Privio/core/servises/app_special_permiision_service.dart';
import 'package:Privio/core/servises/dashboard_permission_service.dart';
import 'package:Privio/core/servises/usage_access_service.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/logic/app_permission/app_permission_cubit.dart';
import 'package:Privio/logic/app_permission/app_permission_state.dart';
import 'package:Privio/presentation/apps_permission/widgets/info_widget.dart';
import 'package:Privio/presentation/apps_permission/widgets/keep_btn.dart';
import 'package:Privio/presentation/apps_permission/widgets/permission_tile.dart';
import 'package:Privio/presentation/apps_permission/widgets/question_dialog.dart';
import 'package:Privio/presentation/apps_permission/widgets/risk_badge.dart';
import 'package:Privio/presentation/apps_permission/widgets/trust_btn.dart';
import 'package:Privio/presentation/utils/app_bar.dart';
import 'package:Privio/presentation/utils/app_snackbar.dart';
import 'package:Privio/presentation/utils/base_screen.dart';
import 'package:Privio/presentation/utils/custome_dotsloader.dart';
import 'package:Privio/presentation/utils/permission_ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

class AppDetailScreen extends StatefulWidget {
  final AppPermissionUi app;

  const AppDetailScreen({
    super.key,
    required this.app,
  });

  @override
  State<AppDetailScreen> createState() => _AppDetailScreenState();
}

class _AppDetailScreenState extends State<AppDetailScreen>
    with WidgetsBindingObserver {
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
      context.read<AppPermissionCubit>().refreshApp(widget.app.packageName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final l10n = AppLocalizations.of(context)!;

    return BaseScreen(
      child: BlocConsumer<AppPermissionCubit, AppPermissionState>(
        listenWhen: (_, current) =>
        current is AppTrustedSuccess ||
            current is AppUntrustedSuccess ||
            current is AppKeptSuccess ||
            current is AppUnkeptSuccess,
        listener: (context, state) {
          if (state is AppTrustedSuccess) {
            AppSnackBar.show(context, message: l10n.appMarkedTrusted);
          }
          if (state is AppUntrustedSuccess) {

            AppSnackBar.show(context, message: l10n.appUntrusted,
              icon: Icons.verified_outlined,
            );
          }
          if (state is AppKeptSuccess) {

            AppSnackBar.show(
              context,
              message: l10n.appAddedToKeep,
              accentColor: Colors.green,
              icon: Icons.favorite,

            );
          }
          if (state is AppUnkeptSuccess) {


            AppSnackBar.show(
              context,
              message: l10n.appRemovedFromKeep,
              accentColor: Colors.green,
              icon: Icons.favorite_border_sharp,
            );
          }
        },
        buildWhen: (previous, current) =>
        current is AppPermissionLoaded || current is AppTrusting,
        builder: (context, state) {
          if (state is! AppPermissionLoaded && state is! AppTrusting) {
            return const Center(
              child: CustomDotsLoader(
                svgPath1: 'assets/utils/Property 1=1 (1).svg',
                svgPath2: 'assets/utils/Property 1=2 (1).svg',
                svgPath3: 'assets/utils/Property 1=3 (1).svg',
                svgPath4: 'assets/utils/Property 1=4 (1).svg',
              ),
            );
          }

          final AppPermissionLoaded loaded = state is AppPermissionLoaded
              ? state
              : (state as AppTrusting).previous;

          final app = [
            ...loaded.noRisk,
            ...loaded.lowRisk,
            ...loaded.mediumRisk,
            ...loaded.highRisk,
          ].firstWhere(
                (a) => a.packageName == widget.app.packageName,
            orElse: () => widget.app,
          );

          final percent = calculateRiskPercent(app.permissions);

          final isKept = context.select<AppPermissionCubit, bool>(
                (c) => c.isAppKept(widget.app.packageName),
          );
          final isTrust = context.select<AppPermissionCubit, bool>(
                (c) => c.isAppTrusted(widget.app.packageName),
          );

          final bool isTrusting = state is AppTrusting
              ? (state as AppTrusting).packageName == app.packageName
              : false;

          return Column(
            children: [
              AppBarWidget(
                text: l10n.appDetails,
                ontap: () => context.pop(),
                showBack: true,
                showHome: true,
              ),

              SizedBox(height: screenHeight * 0.015),

              // App icon
              Image.memory(
                base64Decode(app.iconBase64),
                width: screenWidth * 0.2,
                height: screenHeight * 0.1,
              ),

              SizedBox(height: screenHeight * 0.015),

              // App name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Text(app.appName,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.appName(context)),
              ),

              SizedBox(height: screenHeight * 0.01),

              // Trust badge or risk badge
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: isTrust
                    ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.035,
                    vertical: screenHeight * 0.012,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withAlpha(38),
                    borderRadius:
                    BorderRadius.circular(screenWidth * 0.05),
                  ),
                  child: Text(l10n.trustedAppsExcluded,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.trusted(context)),
                )
                    : RiskBadge(riskLevel: app.riskLevel),
              ),

              SizedBox(height: screenHeight * 0.022),

              // Trust & Keep buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    Expanded(
                      child: TrustBtn(
                        isTrusting: isTrusting,
                        isTrusted: isTrust,
                        onTap: () {
                          isTrust
                              ? context
                              .read<AppPermissionCubit>()
                              .untrustApp(app.packageName)
                              : context
                              .read<AppPermissionCubit>()
                              .trustApp(app.packageName);
                        },
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.015),
                    Expanded(
                      child: KeepAppButton(
                        isKept: isKept,
                        onTap: () {
                          isKept
                              ? context
                              .read<AppPermissionCubit>()
                              .unkeepApp(app.packageName)
                              : context
                              .read<AppPermissionCubit>()
                              .keepApp(widget.app.packageName);
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.022),

              // Risk percentage row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.riskPercent((percent * 100).round()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.trusted(context).copyWith(
                            color: isTrust
                                ? Colors.blue
                                : _riskColor(app.riskLevel),
                            fontSize: 20.sp),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                            ),
                            child: InfoWidget(),
                          ),
                        );
                      },
                      child: Container(
                        width: screenWidth * 0.075,
                        height: screenWidth * 0.075,
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(screenWidth * 0.0625),
                          color: AppColor.CartDark,
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color:
                          context.isDark ? Colors.white70 : AppColor.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              // Permissions list
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  children:
                  PermissionConst.displayPermissions.entries.map((entry) {
                    final permissionKey = entry.key;
                    final lang = Localizations.localeOf(context).languageCode;
                    final permissionName = PermissionConst
                        .displayPermissions[permissionKey]?[lang] ??
                        PermissionConst.displayPermissions[permissionKey]
                        ?['en'] ??
                        permissionKey;
                    ;

                    final enabled = app.permissions.contains(permissionKey);
                    final isDangerous = PermissionConst.dangerousPermissions
                        .contains(permissionKey);

                    return PermissionSwitchTile(
                      title: permissionName,
                      enabled: enabled,
                      isDangerous: isDangerous,
                      onTap: () {
                        final dontShowAgain = Hive.box('app_preferences').get(
                          _dialogPreferenceKey,
                          defaultValue: false,
                        ) as bool;
                        if (dontShowAgain) {
                          _openPermissionSettings(permissionKey);
                          return;
                        }
                        showDialog(
                          context: context,
                          builder: (dialogContext) => Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: QuestionDialog(
                              ontapManual: () async {
                                if (dialogContext.canPop()) {
                                  Navigator.pop(dialogContext);
                                }
                                await Future.delayed(
                                  const Duration(milliseconds: 50),
                                );
                                await _openPermissionSettings(permissionKey);
                              },
                              onDontShowAgainChanged: (checked) {
                                Hive.box('app_preferences').put(
                                  _dialogPreferenceKey,
                                  checked,
                                );
                              },
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  static const _dialogPreferenceKey = 'hide_permission_dialog_globally';

  Future<void> _openPermissionSettings(String permissionKey) async {
    switch (permissionKey) {
      case 'android.permission.SYSTEM_ALERT_WINDOW':
        await AppSpecialPermissionPlatform()
            .openAppOverlaySettings(widget.app.packageName);
        break;
      case 'android.permission.PACKAGE_USAGE_STATS':
        await UsageAccessService.openUsageAccessSettings();
        break;
      case 'android.permission.MANAGE_EXTERNAL_STORAGE':
        await AppSpecialPermissionPlatform()
            .openAppAllFilesAccessSettings(widget.app.packageName);
        break;
      case 'android.permission.WRITE_SETTINGS':
        await AppSpecialPermissionPlatform()
            .openAppWriteSettingsSettings(widget.app.packageName);
        break;
      case 'android.permission.BIND_ACCESSIBILITY_SERVICE':
        await SafeDashboardPlatform.openAccessibilitySettings();
        break;
      default:
        await AppPermissionPlatform()
            .openAppSettings(widget.app.packageName);
    }
  }

  Color _riskColor(RiskLevel level) {
    switch (level) {
      case RiskLevel.highRisk:
        return Colors.red;
      case RiskLevel.mediumRisk:
        return Colors.orange;
      case RiskLevel.lowRisk:
        return Colors.green;
      case RiskLevel.noRisk:
        return Colors.blue;
    }
  }
}
