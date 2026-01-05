
class SpecialPermissionState  {
  final bool usageAccess;
  final bool notificationAccess;
  final bool overlay;
  final bool batteryOptimization;
  final bool doNotDisturb;
  final int riskPercent;
  final bool loading;

  const SpecialPermissionState({
    required this.usageAccess,
    required this.notificationAccess,
    required this.overlay,
    required this.batteryOptimization,
    required this.doNotDisturb,
    required this.riskPercent,
    required this.loading,
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
    );
  }

  @override
  List<Object> get props => [
    usageAccess,
    notificationAccess,
    overlay,
    batteryOptimization,
    doNotDisturb,
    riskPercent,
    loading,
  ];
}
