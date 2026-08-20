import 'package:flutter/material.dart';
import 'package:Privio/constant/risk_level.dart';
import 'package:Privio/constant/specialPermissionType.dart';
import 'package:Privio/core/servises/app_special_permiision_service.dart';
import 'package:Privio/core/servises/special_permission_cache_service.dart';
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
      SpecialPermissionType.doNotDisturb,
    );
    if (!mounted) return;
    setState(() {
      _apps = cached;
      _loading = false;
    });
    _refresh();
  }

  Future<void> _refresh() async {
    final fresh = await SpecialPermissionCacheService.refreshApps(
      SpecialPermissionType.doNotDisturb,
    );
    if (!mounted) return;
    setState(() => _apps = fresh);
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

    final RiskLevel level = SpecialPermissionRiskResolver.fromCount(
      type: SpecialPermissionType.doNotDisturb,
      count: apps.length,
    );

    if (apps.isEmpty) {
      return Center(
        child: EmptyPageWidget(text: l10n.noAppsWithDoNotDisturb),
      );
    }

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
      ],
    );
  }
}
