import 'package:Privio/core/models/app_permission_ui.dart';

abstract class AppPermissionState {}

class AppPermissionInitial extends AppPermissionState {}

class AppPermissionLoading extends AppPermissionState {}


class AppTrusting extends AppPermissionState {
  final String packageName;
  final AppPermissionLoaded previous;

  AppTrusting({
    required this.packageName,
    required this.previous,
  });
}
class AppPermissionLoaded extends AppPermissionState {
  final List<AppPermissionUi> noRisk;
  final List<AppPermissionUi> lowRisk;
  final List<AppPermissionUi> mediumRisk;
  final List<AppPermissionUi> highRisk;
  List<AppPermissionUi> get allApps =>
      [
        ...highRisk,
        ...mediumRisk,
        ...lowRisk,
        ...noRisk,
      ];


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


class AppTrustedSuccess extends AppPermissionState {
  final String packageName;
  AppTrustedSuccess(this.packageName);
}

class AppUntrustedSuccess extends AppPermissionState {
  final String packageName;
  AppUntrustedSuccess(this.packageName);
}



