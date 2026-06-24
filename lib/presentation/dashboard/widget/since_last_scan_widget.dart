import 'dart:convert';
import 'dart:typed_data';
import 'package:Privio/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Privio/constant/app_color.dart';
import 'package:Privio/constant/app_style.dart';
import 'package:Privio/core/models/scan_model.dart';
import 'package:Privio/generated/app_localizations.dart';
import 'package:Privio/presentation/utils/app_size.dart';

enum ScanTab { newApps, changedPerms }

class SinceLastScanWidget extends StatelessWidget {
  final ScanDiff? diff;
  final DateTime? lastScanTime;
  final bool scanning;
  final VoidCallback onRunScan;
  final ScanTab selectedTab;
  final void Function(ScanTab) onTabChange;

  const SinceLastScanWidget({
    super.key,
    required this.diff,
    required this.lastScanTime,
    required this.scanning,
    required this.onRunScan,
    required this.selectedTab,
    required this.onTabChange,
  });

  Uint8List? _decodeIcon(String? base64Str) {
    if (base64Str == null || base64Str.isEmpty) return null;
    try {
      return base64Decode(base64Str);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final newCount = diff?.newApps.length ?? 0;
    final changedCount = diff?.changedApps.length ?? 0;

    final lastText = (lastScanTime == null)
        ? l10n.noPreviousScan
        : l10n.lastScan(lastScanTime!.toLocal().toString().substring(0, 16));

    return Container(
      padding: EdgeInsets.all(AppSize.width * 0.035),
      decoration: BoxDecoration(
        color: context.isDark ? AppColor.CartDark : AppColor.btnLight,
        borderRadius: BorderRadius.circular(AppSize.width * 0.04),
        border: Border.all(
            color: context.isDark
                ? Colors.white.withAlpha(20)
                : AppColor.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/dashboard/clock.svg"),
              SizedBox(width: AppSize.width * 0.02),
              Expanded(
                child: Text(
                  l10n.sinceLastScan,
                  style: AppTextStyle.dashboardTitle(context),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(AppSize.width * 0.025),
                onTap: scanning ? null : onRunScan,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.width * 0.03,
                    vertical: AppSize.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: AppColor.blue1),
                    color:
                        context.isDark ? AppColor.CartDark : AppColor.btnLight,
                    borderRadius: BorderRadius.circular(AppSize.width * 0.025),
                  ),
                  child: Row(
                    children: [
                      if (scanning) ...[
                        SizedBox(
                          width: AppSize.width * 0.04,
                          height: AppSize.width * 0.04,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColor.blue2,
                          ),
                        ),
                        SizedBox(width: AppSize.width * 0.02),
                      ] else ...[
                        Icon(Icons.refresh,
                            color: AppColor.blue1, size: AppSize.width * 0.04),
                        SizedBox(width: AppSize.width * 0.015),
                      ],
                      Text(
                        scanning ? l10n.scanning : l10n.runScan,
                        style: AppTextStyle.trustDescription(context)
                            .copyWith(color: AppColor.blue1),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.height * 0.01),
          Text(lastText,
              style: AppTextStyle.lastScan(context)
                  .copyWith(color: AppColor.blue1)),
          SizedBox(height: AppSize.height * 0.015),
          Row(
            children: [
              _pill(l10n.newApps, newCount, context),
              SizedBox(width: AppSize.width * 0.02),
              _pill(l10n.changedPermissions, changedCount, context),
            ],
          ),
          SizedBox(height: AppSize.height * 0.015),
          Row(
            children: [
              Expanded(
                child: _tabBtn(
                  context,
                  text: l10n.newApps,
                  selected: selectedTab == ScanTab.newApps,
                  onTap: () => onTabChange(ScanTab.newApps),
                ),
              ),
              SizedBox(width: AppSize.width * 0.025),
              Expanded(
                child: _tabBtn(
                  context,
                  text: l10n.changed,
                  selected: selectedTab == ScanTab.changedPerms,
                  onTap: () => onTabChange(ScanTab.changedPerms),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.height * 0.015),
          if (diff == null)
            Text(
              l10n.runScanToCompare,
              style: AppTextStyle.specialPermission(context)
                  .copyWith(color: AppColor.blue2),
            )
          else if (diff!.isEmpty)
            Text(
              l10n.noChangesSinceLastScan,
              style: AppTextStyle.specialPermission(context)
                  .copyWith(color: AppColor.blue2),
            )
          else
            _buildList(selectedTab, diff!, _decodeIcon, l10n, context),
        ],
      ),
    );
  }

  Widget _pill(String label, int count, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width * 0.025,
        vertical: AppSize.height * 0.008,
      ),
      decoration: BoxDecoration(
        color: AppColor.blue1.withAlpha(51),
        borderRadius: BorderRadius.circular(AppSize.width * 0.25),
      ),
      child: Text(
        '$label: $count',
        style: AppTextStyle.trustDescription(context)
            .copyWith(fontSize: AppSize.width * 0.03),
      ),
    );
  }

  Widget _tabBtn(
    BuildContext context, {
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSize.width * 0.025),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSize.height * 0.015),
        decoration: BoxDecoration(
          color: context.isDark ? AppColor.CartDark : AppColor.btnLight,
          borderRadius: BorderRadius.circular(AppSize.width * 0.025),
          border: Border.all(
            color: selected ? AppColor.blue1 : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: AppTextStyle.lastScan(context).copyWith(
              color: selected
                  ? AppColor.blue1
                  : (context.isDark ? AppColor.borderCard : AppColor.textLight),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    ScanTab tab,
    ScanDiff diff,
    Uint8List? Function(String?) decodeIcon,
    AppLocalizations l10n,
    BuildContext context,
  ) {
    if (tab == ScanTab.newApps) {
      return Column(
        children: diff.newApps.map((a) {
          final bytes = decodeIcon(a.iconBase64);
          return _simpleRow(
            context: context,
            icon: bytes,
            title: a.name,
            subtitle: a.packageName,
            trailing: l10n.newLabel,
            trailingColor: Colors.greenAccent,
          );
        }).toList(),
      );
    }

    return Column(
      children: diff.changedApps.map((c) {
        final a = c.current;
        final bytes = decodeIcon(a.iconBase64);
        return _changedRow(
          context: context,
          icon: bytes,
          title: a.name,
          subtitle: a.packageName,
          added: c.added,
          removed: c.removed,
          l10n: l10n,
        );
      }).toList(),
    );
  }

  Widget _simpleRow({
    required BuildContext context,
    required Uint8List? icon,
    required String title,
    required String subtitle,
    required String trailing,
    required Color trailingColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.height * 0.012),
      padding: EdgeInsets.all(AppSize.width * 0.03),
      decoration: BoxDecoration(
        color:context.isDark? Colors.white.withOpacity(0.04):AppColor.btnLight,
        borderRadius: BorderRadius.circular(AppSize.width * 0.03),
      ),
      child: Row(
        children: [
          _iconBox(icon),
          SizedBox(width: AppSize.width * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.appName(context)),
                SizedBox(height: AppSize.height * 0.005),
                Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.lastScan(context).copyWith(color: context.isDark? Colors.white38:AppColor.textLight)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.width * 0.025,
              vertical: AppSize.height * 0.008,
            ),
            decoration: BoxDecoration(
              color: trailingColor.withAlpha(38),
              borderRadius: BorderRadius.circular(AppSize.width * 0.25),
            ),
            child: Text(
              trailing,
              style: AppTextStyle.lastScan(context).copyWith(color: context.isDark? AppColor.green2:AppColor.green4)
            ),
          ),
        ],
      ),
    );
  }

  Widget _changedRow({
    required Uint8List? icon,
    required String title,
    required String subtitle,
    required List<String> added,
    required List<String> removed,
    required AppLocalizations l10n,
    required BuildContext context,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.height * 0.012),
      padding: EdgeInsets.all(AppSize.width * 0.03),
      decoration: BoxDecoration(
        color: context.isDark ? Colors.white.withAlpha(10) : AppColor.btnLight,
        borderRadius: BorderRadius.circular(AppSize.width * 0.03),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _iconBox(icon),
              SizedBox(width: AppSize.width * 0.025),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:AppTextStyle.appName(context)),
                    SizedBox(height: AppSize.height * 0.005),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.lastScan(context).copyWith(
                            color: context.isDark
                                ? Colors.white38
                                : AppColor.textLight)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.width * 0.025,
                  vertical: AppSize.height * 0.008,
                ),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withAlpha(38),
                  borderRadius: BorderRadius.circular(AppSize.width * 0.25),
                ),
                child: Text(
                  l10n.changed,
                  style: TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.w900,
                      fontSize: AppSize.width * 0.028),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.height * 0.012),
          if (added.isNotEmpty)
            _changeLine(context,l10n.added, added, Colors.greenAccent),
          if (removed.isNotEmpty)
            _changeLine(context,l10n.removed, removed, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _changeLine(BuildContext context,String label, List<String> items, Color c) {
    final text = items.take(6).join(', ') + (items.length > 6 ? ' …' : '');
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: AppSize.height * 0.008),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.width * 0.025,
        vertical: AppSize.height * 0.01,
      ),
      decoration: BoxDecoration(
        color: c.withAlpha(20),
        borderRadius: BorderRadius.circular(AppSize.width * 0.025),
        border: Border.all(color: c.withAlpha(51)),
      ),
      child: Text(
        '$label: $text',
        style:
        AppTextStyle.lastScan(context).copyWith(
            color: context.isDark
                ? Colors.white38
                : AppColor.textLight),
      ),
    );
  }

  Widget _iconBox(Uint8List? bytes) {
    return Container(
      width: AppSize.width * 0.1,
      height: AppSize.width * 0.1,
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(15),
        borderRadius: BorderRadius.circular(AppSize.width * 0.025),
      ),
      child: bytes == null
          ? Icon(Icons.apps, color: Colors.white38, size: AppSize.width * 0.05)
          : ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.width * 0.025),
              child: Image.memory(bytes, fit: BoxFit.cover),
            ),
    );
  }
}
