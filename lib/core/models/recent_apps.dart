import 'app_permission_ui.dart';

class RecentAppsIteme {
  final AppPermissionUi App;
  final int lastUsed;
  final int foregroundTime;

  RecentAppsIteme({
    required this.App,
    required this.lastUsed,
    required this.foregroundTime,
});

}