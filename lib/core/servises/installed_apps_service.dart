import '../platform/installed_apps_platform.dart';

class InstalledAppsService {
  Future<int> fetchInstalledAppsCount() {
    return InstalledAppsPlatform.getInstalledAppsCount();
  }

  Future<int> fetchInstalledAppsCountFallback() {
    return InstalledAppsPlatform.getInstalledAppsCountFromList();
  }
}
