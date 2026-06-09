import 'dart:async';
import 'package:flutter/services.dart';
import 'package:Privio/core/models/app_permission_item.dart';

import 'dashboard_permission_service.dart';

class DashboardPermissionService {
  DashboardPermissionService._();

  static const MethodChannel _installedAppsChannel =
  MethodChannel('permission_channel'); // همون CHANNEL تو MainActivity

  /// کش ساده برای جلوگیری از callهای اضافی
  static final Map<String, Map<String, dynamic>> _locationCache = {};

  static Future<List<AppPermissionItem>> loadAppsWithLocation({
    int concurrency = 6,
  }) async {
    // 1) لیست اپ‌ها از channel قدیمی خودت
    final List<dynamic> raw =
    await _installedAppsChannel.invokeMethod('getInstalledAppsList');

    final apps = raw
        .map((e) => Map<String, dynamic>.from(e as Map))
        .map((m) => AppPermissionItem(
      name: (m['name'] ?? '').toString(),
      packageName: (m['package'] ?? '').toString(),
      iconBase64: m['icon']?.toString(),
      locationState: 'unknown',
      locationPrecision: 'none',
    ))
        .where((a) => a.packageName.isNotEmpty)
        .toList();

    // 2) برای هر اپ، وضعیت Location را بگیر (با محدود کردن همزمانی)
    final results = await _mapWithConcurrency<AppPermissionItem, AppPermissionItem>(
      items: apps,
      concurrency: concurrency,
      mapper: (app) async {
        // cache
        final cached = _locationCache[app.packageName];
        if (cached != null) {
          return app.copyWith(
            locationState: (cached['state'] ?? 'denied').toString(),
            locationPrecision: (cached['precision'] ?? 'none').toString(),
          );
        }

        try {
          final loc = await SafeDashboardPlatform.getLocationState(app.packageName);
          _locationCache[app.packageName] = loc;
          return app.copyWith(
            locationState: (loc['state'] ?? 'denied').toString(),
            locationPrecision: (loc['precision'] ?? 'none').toString(),
          );
        } catch (_) {
          return app.copyWith(locationState: 'denied', locationPrecision: 'none');
        }
      },
    );

    return results;
  }

  static void clearCache() => _locationCache.clear();
}

/// helper: map با محدودیت همزمانی (بدون پکیج اضافه)
Future<List<R>> _mapWithConcurrency<T, R>({
  required List<T> items,
  required int concurrency,
  required Future<R> Function(T) mapper,
}) async {
  final out = <R>[];
  final sem = _Semaphore(concurrency);

  final futures = items.map((item) async {
    await sem.acquire();
    try {
      final r = await mapper(item);
      out.add(r);
    } finally {
      sem.release();
    }
  }).toList();

  await Future.wait(futures);
  return out;
}

class _Semaphore {
  _Semaphore(this._max);
  final int _max;
  int _current = 0;
  final _queue = <Completer<void>>[];

  Future<void> acquire() async {
    if (_current < _max) {
      _current++;
      return;
    }
    final c = Completer<void>();
    _queue.add(c);
    await c.future;
    _current++;
  }

  void release() {
    _current--;
    if (_queue.isNotEmpty) {
      final c = _queue.removeAt(0);
      c.complete();
    }
  }
}
