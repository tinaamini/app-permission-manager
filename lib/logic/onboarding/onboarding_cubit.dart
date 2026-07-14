import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void setPage(int index) => emit(index);
}

class BtnLanguageCubit extends Cubit<int> {
  BtnLanguageCubit({int initialIndex = 1}) : super(initialIndex);

  void select(int index) {
    emit(index);
  }
}

