import 'package:hive/hive.dart';

class OnboardingStorage {
  static const String boxName = 'app_settings';
  static const String keyOnboardingSeen = 'onboarding_seen';

  Box get _box => Hive.box(boxName);

  Future<bool> isOnboardingSeen() async {
    return (_box.get(keyOnboardingSeen, defaultValue: false) as bool);
  }

  Future<void> setOnboardingSeen() async {
    await _box.put(keyOnboardingSeen, true);
  }

  Future<void> delOnboardingSeen() async {
    await _box.put(keyOnboardingSeen, false);
  }
}