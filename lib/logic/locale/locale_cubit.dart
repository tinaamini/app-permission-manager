import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class LocaleCubit extends Cubit<Locale> {
  static const storageKey = 'languageCode';
  static const _supported = {'en', 'fa'};
  static const _channel = MethodChannel('notification_navigation');

  final Box _box;

  LocaleCubit(this._box) : super(_resolveInitialLocale(_box)) {
    // فقط وقتی کاربر قبلاً زبان را به‌صورت دستی انتخاب کرده (مقدار در
    // storage ذخیره شده)، به سمت native سینک می‌کنیم. اگر کاربر هیچ‌وقت
    // انتخابی نکرده، نباید چیزی به native فرستاده شود تا سمت native با
    // fallback خودش (Locale.getDefault) همیشه زبان سیستم را دنبال کند و
    // با تغییر زبان گوشی به‌روز بماند.
    final saved = _box.get(storageKey);
    if (saved is String && _supported.contains(saved)) {
      _notifyNative(state.languageCode);
    }
  }

  static Locale _resolveInitialLocale(Box box) {
    final saved = box.get(storageKey);

    if (saved is String && _supported.contains(saved)) {
      return Locale(saved);
    }

    final systemCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;

    if (_supported.contains(systemCode)) {
      return Locale(systemCode);
    }

    return const Locale('fa');
  }

  static int initialLanguageIndex(Box box) {
    return _resolveInitialLocale(box).languageCode == 'en' ? 0 : 1;
  }

  bool get _hasExplicitChoice {
    final saved = _box.get(storageKey);
    return saved is String && _supported.contains(saved);
  }

  void syncWithSystemLocale(Locale systemLocale) {
    if (_hasExplicitChoice) return;
    final code = _supported.contains(systemLocale.languageCode)
        ? systemLocale.languageCode
        : 'fa';
    if (state.languageCode != code) {
      emit(Locale(code));
    }
  }

  Future<void> toggle() async {
    final next = state.languageCode == 'fa'
        ? const Locale('en')
        : const Locale('fa');
    await setLocale(next);
  }

  Future<void> setLocale(Locale locale) async {
    if (!_supported.contains(locale.languageCode)) return;

    await _box.put(storageKey, locale.languageCode);
    if (state.languageCode != locale.languageCode) {
      emit(Locale(locale.languageCode));
      await _notifyNative(locale.languageCode);
    }
  }

  Future<void> _notifyNative(String languageCode) async {
    try {
      await _channel.invokeMethod('setLanguage', {'language': languageCode});
    } catch (e) {
      debugPrint('Failed to send language to native: $e');
    }
  }
}