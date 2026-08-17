import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> with WidgetsBindingObserver{
  final Box box;

  ThemeCubit(this.box) : super(_initialTheme(box)) {
    WidgetsBinding.instance.addObserver(this);
  }

  static ThemeMode _initialTheme(Box box) {
    if (box.containsKey('isDark')) {
      return (box.get('isDark') as bool) ? ThemeMode.dark : ThemeMode.light;
    }
    final systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return systemBrightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  @override
  void didChangePlatformBrightness() {
    if (box.containsKey('isDark')) return;
    final systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    emit(systemBrightness == Brightness.dark
        ? ThemeMode.dark
        : ThemeMode.light);
  }
  Future<void> toggle() async {
    final isDark = state == ThemeMode.light;

    await box.put('isDark', isDark);

    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
  @override
  Future<void> close() {
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
