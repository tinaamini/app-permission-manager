import 'package:permissions_app/core/models/app_permission_ui.dart';

abstract class AppPermissionState {}

class AppPermissionInitial extends AppPermissionState {}

class AppPermissionLoading extends AppPermissionState {}

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

class AppPermissionError extends AppPermissionState {
  final String message;

  AppPermissionError(this.message);
}


class AppKeptSuccess extends AppPermissionState {
  final String packageName;

  AppKeptSuccess(this.packageName);
}

class AppUnkeptSuccess extends AppPermissionState {
  final String packageName;

  AppUnkeptSuccess(this.packageName);
}

