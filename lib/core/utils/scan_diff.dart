
import 'package:permissions_app/core/models/scan_model.dart';

ScanDiff diffSnapshots(ScanSnapshot prev, ScanSnapshot curr) {
  final prevPkgs = prev.appsByPackage.keys.toSet();
  final currPkgs = curr.appsByPackage.keys.toSet();

  final newPkgs = currPkgs.difference(prevPkgs);
  final commonPkgs = currPkgs.intersection(prevPkgs);

  final newApps = newPkgs.map((p) => curr.appsByPackage[p]!).toList()
    ..sort((a, b) => a.name.compareTo(b.name));

  final changedApps = <PermChange>[];

  for (final pkg in commonPkgs) {
    final prevApp = prev.appsByPackage[pkg]!;
    final currApp = curr.appsByPackage[pkg]!;

    final addedSet = currApp.grantedPerms.difference(prevApp.grantedPerms);
    final removedSet = prevApp.grantedPerms.difference(currApp.grantedPerms);

    if (addedSet.isNotEmpty || removedSet.isNotEmpty) {
      changedApps.add(
        PermChange(
          current: currApp,
          added: (addedSet.toList()..sort()),
          removed: (removedSet.toList()..sort()),
        ),
      );
    }
  }

  changedApps.sort((a, b) => a.current.name.compareTo(b.current.name));

  return ScanDiff(newApps: newApps, changedApps: changedApps);
}
