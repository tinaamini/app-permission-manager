import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class LocaleCubit extends Cubit<Locale> {
  static const storageKey = 'languageCode';
  static const _supported = {'en', 'fa'};

  final Box _box;

  LocaleCubit(this._box) : super(_resolveInitialLocale(_box));

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
    }
  }
}