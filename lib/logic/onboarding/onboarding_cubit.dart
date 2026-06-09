import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void setPage(int index) => emit(index);



}
class BtnLanguageCubit extends Cubit<int> {
  BtnLanguageCubit() : super(1);

  void select(int index) {
    emit(index);
  }


}


