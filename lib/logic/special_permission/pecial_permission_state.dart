class SpecialPermissionState {
  final bool usageAccess;
  final bool notificationAccess;
  final bool overlay;
  final bool batteryOptimization;
  final bool doNotDisturb;
  final int riskPercent;
  final bool loading;

  /// تعداد اپ‌ها برای دکمه‌های صفحه اصلی (از کش)
  final int usageCount;
  final int notificationCount;
  final int overlayCount;
  final int batteryCount;
  final int dndCount;

  const SpecialPermissionState({
    required this.usageAccess,
    required this.notificationAccess,
    required this.overlay,
    required this.batteryOptimization,
    required this.doNotDisturb,
    required this.riskPercent,
    required this.loading,
    this.usageCount = 0,
    this.notificationCount = 0,
    this.overlayCount = 0,
    this.batteryCount = 0,
    this.dndCount = 0,
  });

  factory SpecialPermissionState.initial() {
    return const SpecialPermissionState(
      usageAccess: false,
      notificationAccess: false,
      overlay: false,
      batteryOptimization: false,
      doNotDisturb: false,
      riskPercent: 0,
      loading: true,
    );
  }

  SpecialPermissionState copyWith({
    bool? usageAccess,
    bool? notificationAccess,
    bool? overlay,
    bool? batteryOptimization,
    bool? doNotDisturb,
    int? riskPercent,
    bool? loading,
    int? usageCount,
    int? notificationCount,
    int? overlayCount,
    int? batteryCount,
    int? dndCount,
  }) {
    return SpecialPermissionState(
      usageAccess: usageAccess ?? this.usageAccess,
      notificationAccess: notificationAccess ?? this.notificationAccess,
      overlay: overlay ?? this.overlay,
      batteryOptimization:
          batteryOptimization ?? this.batteryOptimization,
      doNotDisturb: doNotDisturb ?? this.doNotDisturb,
      riskPercent: riskPercent ?? this.riskPercent,
      loading: loading ?? this.loading,
      usageCount: usageCount ?? this.usageCount,
      notificationCount: notificationCount ?? this.notificationCount,
      overlayCount: overlayCount ?? this.overlayCount,
      batteryCount: batteryCount ?? this.batteryCount,
      dndCount: dndCount ?? this.dndCount,
    );
  }
}
