import 'package:flutter_riverpod/flutter_riverpod.dart';

final onboardingAnimationProvider =
    StateNotifierProvider<OnboardingAnimationNotifier, bool>((ref) {
  return OnboardingAnimationNotifier();
});

class OnboardingAnimationNotifier extends StateNotifier<bool> {
  OnboardingAnimationNotifier() : super(false);

  void setAnimationComplete() {
    state = true;
  }

  void resetAnimation() {
    state = false;
  }
}
