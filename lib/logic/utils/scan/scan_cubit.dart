import 'package:Privio/core/models/scan_model.dart';
import 'package:Privio/core/servises/scan_service.dart';
import 'package:Privio/core/servises/scan_storage_hive.dart';
import 'package:Privio/core/utils/scan_diff.dart';
import 'package:Privio/logic/utils/scan/scan_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(const ScanState()); // status = initial

  Future<void> loadLastScan() async {
    final last = await ScanStorageHive.loadLastSnapshot();

    if (last == null) {
      emit(state.copyWith(status: ScanStatus.initial));
      return;
    }

    final diff = await ScanStorageHive.loadLastDiff();

    emit(state.copyWith(
      lastScanTime: DateTime.fromMillisecondsSinceEpoch(last.timestampMs),
      scanDiff: diff,
      status: ScanStatus.loaded,
    ));
  }

  Future<void> runScan() async {
    if (state.isScanning) return;

    emit(state.copyWith(status: ScanStatus.loading));

    try {
      final prev = await ScanStorageHive.loadLastSnapshot();
      final curr = await ScanService.takeSnapshot();
      await ScanStorageHive.saveLastSnapshot(curr);

      emit(state.copyWith(
        lastScanTime: DateTime.fromMillisecondsSinceEpoch(curr.timestampMs),
        scanDiff: prev == null ? null : diffSnapshots(prev, curr),
        status: ScanStatus.loaded,
      ));
    } catch (_) {
      emit(state.copyWith(status: ScanStatus.error));
    }
  }


  void markScanned({required DateTime time, ScanDiff? diff}) {
    emit(state.copyWith(
      lastScanTime: time,
      scanDiff: diff,
      status: ScanStatus.loaded,
    ));
  }
}