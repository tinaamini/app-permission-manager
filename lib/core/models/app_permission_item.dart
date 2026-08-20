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
    String? name,
    String? packageName,
    String? iconBase64,
    bool clearIcon = false,
    String? locationState,
    String? locationPrecision,
  }) {
    return AppPermissionItem(
      name: name ?? this.name,
      packageName: packageName ?? this.packageName,
      iconBase64: clearIcon ? null : (iconBase64 ?? this.iconBase64),
      locationState: locationState ?? this.locationState,
      locationPrecision: locationPrecision ?? this.locationPrecision,
    );
  }

  Map<String, dynamic> toJson({bool includeIcon = true}) {
    return {
      'name': name,
      'packageName': packageName,
      if (includeIcon) 'iconBase64': iconBase64,
      'locationState': locationState,
      'locationPrecision': locationPrecision,
    };
  }

  static AppPermissionItem fromJson(Map<String, dynamic> json) {
    return AppPermissionItem(
      name: (json['name'] ?? '').toString(),
      packageName: (json['packageName'] ?? json['package'] ?? '').toString(),
      iconBase64: json['iconBase64']?.toString() ?? json['icon']?.toString(),
      locationState: (json['locationState'] ?? 'denied').toString(),
      locationPrecision: (json['locationPrecision'] ?? 'none').toString(),
    );
  }
}
