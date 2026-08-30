import 'package:Privio/core/models/scan_model.dart';
import 'package:Privio/generated/app_localizations.dart';

enum ScanStatus { restoring, initial, loading, loaded, error }

class ScanState {
  final DateTime? lastScanTime;
  final ScanDiff? scanDiff;
  final ScanStatus status;

  const ScanState({
    this.lastScanTime,
    this.scanDiff,
    this.status = ScanStatus.initial,
  });

  bool get isScanning => status == ScanStatus.loading;

  ScanState copyWith({
    DateTime? lastScanTime,
    ScanDiff? scanDiff,
    ScanStatus? status,
  }) {
    return ScanState(
      lastScanTime: lastScanTime ?? this.lastScanTime,
      scanDiff: scanDiff ?? this.scanDiff,
      status: status ?? this.status,
    );
  }
}

String getTimeAgo(DateTime dateTime, AppLocalizations l10n) {
  final difference = DateTime.now().difference(dateTime);

  if (difference.inSeconds < 60) {
    return l10n.justNow;
  } else if (difference.inMinutes < 60) {
    return l10n.minutesAgo(difference.inMinutes);
  } else if (difference.inHours < 24) {
    return l10n.hoursAgo(difference.inHours);
  } else if (difference.inDays < 30) {
    return l10n.daysAgo(difference.inDays);
  } else if (difference.inDays < 365) {
    return l10n.monthsAgo((difference.inDays / 30).floor());
  } else {
    return l10n.yearsAgo((difference.inDays / 365).floor());
  }
}
