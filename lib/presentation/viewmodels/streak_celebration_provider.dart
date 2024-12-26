import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreakCelebrationState {
  final bool isShowing;
  final int streak;

  StreakCelebrationState({
    this.isShowing = false,
    this.streak = 0,
  });
}

class StreakCelebrationNotifier extends StateNotifier<StreakCelebrationState> {
  StreakCelebrationNotifier() : super(StreakCelebrationState());

  void showCelebration(int streak) {
    state = StreakCelebrationState(isShowing: true, streak: streak);
    Future.delayed(const Duration(seconds: 3), () {
      state = StreakCelebrationState(isShowing: false, streak: 0);
    });
  }
}

final streakCelebrationProvider =
    StateNotifierProvider<StreakCelebrationNotifier, StreakCelebrationState>(
  (ref) => StreakCelebrationNotifier(),
);
