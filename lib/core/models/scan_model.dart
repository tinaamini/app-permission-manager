class ScanSnapshot {
  final int timestampMs;
  final Map<String, AppPermSnapshot> appsByPackage;

  const ScanSnapshot({
    required this.timestampMs,
    required this.appsByPackage,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestampMs': timestampMs,
      'appsByPackage': appsByPackage.map((k, v) => MapEntry(k, v.toJson())),
    };
  }

  static ScanSnapshot fromJson(Map<String, dynamic> json) {
    final raw = (json['appsByPackage'] as Map?) ?? {};
    final apps = <String, AppPermSnapshot>{};

    raw.forEach((k, v) {
      apps[k.toString()] = AppPermSnapshot.fromJson(Map<String, dynamic>.from(v));
    });

    return ScanSnapshot(
      timestampMs: (json['timestampMs'] as num).toInt(),
      appsByPackage: apps,
    );
  }
}

class AppPermSnapshot {
  final String packageName;
  final String name;
  final String? iconBase64;
  final Set<String> grantedPerms;

  const AppPermSnapshot({
    required this.packageName,
    required this.name,
    required this.iconBase64,
    required this.grantedPerms,
  });

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'name': name,
      'iconBase64': iconBase64,
      'grantedPerms': grantedPerms.toList(),
    };
  }

  static AppPermSnapshot fromJson(Map<String, dynamic> json) {
    return AppPermSnapshot(
      packageName: (json['packageName'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      iconBase64: json['iconBase64']?.toString(),
      grantedPerms: ((json['grantedPerms'] as List?) ?? const [])
          .map((e) => e.toString())
          .toSet(),
    );
  }
}

class ScanDiff {
  final List<AppPermSnapshot> newApps;
  final List<PermChange> changedApps;

  const ScanDiff({
    required this.newApps,
    required this.changedApps,
  });

  bool get isEmpty => newApps.isEmpty && changedApps.isEmpty;

  // ✅ اضافه شد
  Map<String, dynamic> toJson() {
    return {
      'newApps': newApps.map((a) => a.toJson()).toList(),
      'changedApps': changedApps.map((c) => c.toJson()).toList(),
    };
  }

  // ✅ اضافه شد
  static ScanDiff fromJson(Map<String, dynamic> json) {
    return ScanDiff(
      newApps: ((json['newApps'] as List?) ?? [])
          .map((e) => AppPermSnapshot.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      changedApps: ((json['changedApps'] as List?) ?? [])
          .map((e) => PermChange.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class PermChange {
  final AppPermSnapshot current;
  final List<String> added;
  final List<String> removed;

  const PermChange({
    required this.current,
    required this.added,
    required this.removed,
  });

  bool get hasChanges => added.isNotEmpty || removed.isNotEmpty;

  // ✅ اضافه شد
  Map<String, dynamic> toJson() {
    return {
      'current': current.toJson(),
      'added': added,
      'removed': removed,
    };
  }

  // ✅ اضافه شد
  static PermChange fromJson(Map<String, dynamic> json) {
    return PermChange(
      current: AppPermSnapshot.fromJson(
          Map<String, dynamic>.from(json['current'])),
      added: List<String>.from(json['added'] ?? []),
      removed: List<String>.from(json['removed'] ?? []),
    );
  }
}
