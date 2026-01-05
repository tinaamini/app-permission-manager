class SpecialPermissionRisk {
  static const int usageAccess = 30;
  static const int notificationAccess = 30;
  static const int overlay = 40;
  static const int batteryOptimization = 10;
  static const int doNotDisturb = 5;

  static const int maxScore =
      usageAccess +
          notificationAccess +
          overlay +
          batteryOptimization +
          doNotDisturb; // = 115
}
