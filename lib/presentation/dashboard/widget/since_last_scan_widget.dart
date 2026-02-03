import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permissions_app/core/models/scan_model.dart';

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
    final newCount = diff?.newApps.length ?? 0;
    final changedCount = diff?.changedApps.length ?? 0;

    final lastText = (lastScanTime == null)
        ? 'No previous scan yet'
        : 'Last scan: ${lastScanTime!.toLocal().toString().substring(0, 16)}';

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history, color: Colors.white70, size: 18.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Since last scan',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(10.r),
                onTap: scanning ? null : onRunScan,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(scanning ? 0.04 : 0.08),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      if (scanning) ...[
                        SizedBox(
                          width: 14.r,
                          height: 14.r,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 8.w),
                      ] else ...[
                        Icon(Icons.refresh, color: Colors.white70, size: 16.sp),
                        SizedBox(width: 6.w),
                      ],
                      Text(
                        scanning ? 'Scanning' : 'Run scan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(lastText, style: TextStyle(color: Colors.white38, fontSize: 11.sp)),
          SizedBox(height: 12.h),

          Row(
            children: [
              _pill('New apps', newCount),
              SizedBox(width: 8.w),
              _pill('Changed permissions', changedCount),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              Expanded(
                child: _tabBtn(
                  text: 'New apps',
                  selected: selectedTab == ScanTab.newApps,
                  onTap: () => onTabChange(ScanTab.newApps),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _tabBtn(
                  text: 'Changed',
                  selected: selectedTab == ScanTab.changedPerms,
                  onTap: () => onTabChange(ScanTab.changedPerms),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          if (diff == null)
            Text(
              'Run a scan to compare changes.',
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
            )
          else if (diff!.isEmpty)
            Text(
              'No changes since the last scan.',
              style: TextStyle(color: Colors.white70, fontSize: 12.sp),
            )
          else
            _buildList(selectedTab, diff!, _decodeIcon),
        ],
      ),
    );
  }

  Widget _pill(String label, int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _tabBtn({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.12) : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: selected ? Colors.white.withOpacity(0.20) : Colors.transparent,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.white70,
              fontWeight: FontWeight.w800,
              fontSize: 12.sp,
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
      ) {
    if (tab == ScanTab.newApps) {
      return Column(
        children: diff.newApps.map((a) {
          final bytes = decodeIcon(a.iconBase64);
          return _simpleRow(
            icon: bytes,
            title: a.name,
            subtitle: a.packageName,
            trailing: 'NEW',
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
          icon: bytes,
          title: a.name,
          subtitle: a.packageName,
          added: c.added,
          removed: c.removed,
        );
      }).toList(),
    );
  }

  Widget _simpleRow({
    required Uint8List? icon,
    required String title,
    required String subtitle,
    required String trailing,
    required Color trailingColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          _iconBox(icon),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.sp)),
                SizedBox(height: 4.h),
                Text(subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white38, fontSize: 11.sp)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: trailingColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(999.r),
            ),
            child: Text(
              trailing,
              style: TextStyle(color: trailingColor, fontWeight: FontWeight.w900, fontSize: 11.sp),
            ),
          )
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
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _iconBox(icon),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.sp)),
                    SizedBox(height: 4.h),
                    Text(subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white38, fontSize: 11.sp)),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  'CHANGED',
                  style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.w900, fontSize: 11.sp),
                ),
              )
            ],
          ),
          SizedBox(height: 10.h),
          if (added.isNotEmpty) _changeLine('Added', added, Colors.greenAccent),
          if (removed.isNotEmpty) _changeLine('Removed', removed, Colors.redAccent),
        ],
      ),
    );
  }

  Widget _changeLine(String label, List<String> items, Color c) {
    final text = items.take(6).join(', ') + (items.length > 6 ? ' …' : '');
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: c.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: c.withOpacity(0.20)),
      ),
      child: Text(
        '$label: $text',
        style: TextStyle(color: Colors.white70, fontSize: 11.sp),
      ),
    );
  }

  Widget _iconBox(Uint8List? bytes) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: bytes == null
          ? Icon(Icons.apps, color: Colors.white38, size: 20.sp)
          : ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: Image.memory(bytes, fit: BoxFit.cover),
      ),
    );
  }
}
