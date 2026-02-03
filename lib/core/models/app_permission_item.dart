class AppPermissionItem {
  final String name;
  final String packageName;
  final String? iconBase64;

  final String locationState;
  final String locationPrecision;

  const AppPermissionItem({
    required this.name,
    required this.packageName,
    required this.iconBase64,
    required this.locationState,
    required this.locationPrecision,
  });

  AppPermissionItem copyWith({
    String? locationState,
    String? locationPrecision,
  }) {
    return AppPermissionItem(
      name: name,
      packageName: packageName,
      iconBase64: iconBase64,
      locationState: locationState ?? this.locationState,
      locationPrecision: locationPrecision ?? this.locationPrecision,
    );
  }
}
