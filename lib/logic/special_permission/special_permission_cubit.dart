import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Privio/core/servises/app_special_permiision_service.dart';
import 'package:Privio/core/servises/special_permission_cache_service.dart';
import 'package:Privio/logic/special_permission/pecial_permission_state.dart';

class SpecialPermissionCubit extends Cubit<SpecialPermissionState> {
  final AppSpecialPermissionPlatform platform;

  bool _bgRefreshing = false;

  SpecialPermissionCubit(this.platform)
      : super(SpecialPermissionState.initial());

  /// cache-first
  Future<void> loadStatus() async {
    final cached = await SpecialPermissionCacheService.loadStatusCached();

    if (cached != null) {
      _emitFromMap(cached, loading: false);
      _refreshInBackground();
      return;
    }

    emit(state.copyWith(loading: true));
    try {
      final fresh =
          await SpecialPermissionCacheService.fetchStatusAndCountsNative();
      if (!isClosed) _emitFromMap(fresh, loading: false);
    } catch (_) {
      if (!isClosed) emit(state.copyWith(loading: false));
    }
  }

  Future<void> refresh() async {
    await _refreshInBackground(force: true);
  }

  Future<void> _refreshInBackground({bool force = false}) async {
    if (_bgRefreshing && !force) return;
    _bgRefreshing = true;
    try {
      final fresh =
          await SpecialPermissionCacheService.fetchStatusAndCountsNative();
      if (!isClosed) _emitFromMap(fresh, loading: false);
    } catch (_) {
    } finally {
      _bgRefreshing = false;
    }
  }

  void _emitFromMap(Map<String, dynamic> map, {required bool loading}) {
    emit(SpecialPermissionState(
      usageAccess: map['usageAccess'] == true,
      notificationAccess: map['notificationAccess'] == true,
      overlay: map['overlay'] == true,
      batteryOptimization: map['batteryOptimization'] == true,
      doNotDisturb: map['doNotDisturb'] == true,
      riskPercent: (map['riskPercent'] as num?)?.toInt() ?? 0,
      loading: loading,
      usageCount: (map['usageCount'] as num?)?.toInt() ?? 0,
      notificationCount: (map['notificationCount'] as num?)?.toInt() ?? 0,
      overlayCount: (map['overlayCount'] as num?)?.toInt() ?? 0,
      batteryCount: (map['batteryCount'] as num?)?.toInt() ?? 0,
      dndCount: (map['dndCount'] as num?)?.toInt() ?? 0,
    ));
  }
}
