import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('fa'));

  void toggle() {
    emit(state.languageCode == 'fa' ? const Locale('en') : const Locale('fa'));
  }
}