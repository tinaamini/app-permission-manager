import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final Box box;

  ThemeCubit(this.box)
      : super(
    (box.get('isDark', defaultValue: true) as bool)
        ? ThemeMode.dark
        : ThemeMode.light,
  );

  Future<void> toggle() async {
    final isDark = state == ThemeMode.light;

    await box.put('isDark', isDark);

    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
