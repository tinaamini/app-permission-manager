


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class LocaleCubit extends Cubit<Locale> {
  static const storageKey = 'languageCode';
  static const _supportedLanguageCodes = {'en', 'fa'};

  final Box _box;

  LocaleCubit(this._box) : super(_localeFromBox(_box));

  static Locale _localeFromBox(Box box) {
    final saved = box.get(storageKey);


    if (saved is String && _supportedLanguageCodes.contains(saved)) {
      return Locale(saved);
    }

    final systemCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;

    if (_supportedLanguageCodes.contains(systemCode)) {
      return Locale(systemCode);
    }

    return const Locale('fa');
  }

  Future<void> toggle() async {
    final locale = state.languageCode == 'fa'
        ? const Locale('en')
        : const Locale('fa');
    await setLocale(locale);
  }

  Future<void> setLocale(Locale locale) async {
    if (!_supportedLanguageCodes.contains(locale.languageCode)) return;

    await _box.put(storageKey, locale.languageCode);
    if (state.languageCode != locale.languageCode) {
      emit(Locale(locale.languageCode));
    }
  }
}

