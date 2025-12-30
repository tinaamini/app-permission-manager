import 'package:permissions_app/core/models/app_permission_ui.dart';

/// Base state
abstract class AppPermissionState {}

/// Initial state (before loading)
class AppPermissionInitial extends AppPermissionState {}

/// Loading state (optional – اگر خواستی بعداً استفاده کنی)
class AppPermissionLoading extends AppPermissionState {}

/// Loaded state (main state)
class AppPermissionLoaded extends AppPermissionState {
  final List<AppPermissionUi> noRisk;
  final List<AppPermissionUi> lowRisk;
  final List<AppPermissionUi> mediumRisk;
  final List<AppPermissionUi> highRisk;

  AppPermissionLoaded({
    required this.noRisk,
    required this.lowRisk,
    required this.mediumRisk,
    required this.highRisk,
  });
}

/// Error state
class AppPermissionError extends AppPermissionState {
  final String message;

  AppPermissionError(this.message);
}
