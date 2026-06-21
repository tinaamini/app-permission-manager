import 'package:Privio/core/models/scan_model.dart';
import 'package:Privio/core/servises/scan_service.dart';
import 'package:Privio/core/servises/scan_storage_hive.dart';
import 'package:Privio/core/utils/scan_diff.dart';
import 'package:Privio/logic/utils/scan/scan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(const ScanState());

  Future<void> loadLastScan() async {
    final last = await ScanStorageHive.loadLastSnapshot();
    emit(state.copyWith(
      lastScanTime: last == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(last.timestampMs),
    ));
  }

  Future<void> runScan() async {
    if (state.scanning) return;
    emit(state.copyWith(scanning: true));

    try {
      final prev = await ScanStorageHive.loadLastSnapshot();
      final curr = await ScanService.takeSnapshot();
      await ScanStorageHive.saveLastSnapshot(curr);

      emit(state.copyWith(
        lastScanTime: DateTime.fromMillisecondsSinceEpoch(curr.timestampMs),
        scanDiff: prev == null ? null : diffSnapshots(prev, curr),
        scanning: false,
      ));
    } catch (_) {
      emit(state.copyWith(scanning: false));
    }
  }
}