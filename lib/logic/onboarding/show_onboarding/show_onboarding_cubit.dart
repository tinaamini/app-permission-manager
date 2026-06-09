import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Privio/core/utils/onboarding_storage.dart';

enum OnboardingStatus { unknown, show, done }

class OnboardingShowCubit extends Cubit<OnboardingStatus> {
  final OnboardingStorage storage;

  OnboardingShowCubit(this.storage) : super(OnboardingStatus.unknown);

  Future<void> load() async {
    final seen = await storage.isOnboardingSeen();
    emit(seen ? OnboardingStatus.done : OnboardingStatus.show);
  }

  Future<void> complete() async {
    await storage.setOnboardingSeen();
    emit(OnboardingStatus.done);
  }

  Future<void> delete() async {
    await storage.delOnboardingSeen();
    emit(OnboardingStatus.unknown);
  }
}