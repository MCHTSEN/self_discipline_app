import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/domain/entities/daily_streak_entity.dart';

class StreakNotifier extends StateNotifier<List<DailyStreakEntity>> {
  StreakNotifier() : super([]);

  void addStreak(DateTime date, bool isCompleted) {
    // Remove if already exists for the same date
    state = state
        .where((streak) => !(streak.date.year == date.year &&
            streak.date.month == date.month &&
            streak.date.day == date.day))
        .toList();

    // Add new streak
    state = [...state, DailyStreakEntity(date: date, isCompleted: isCompleted)];
  }

  bool isDateCompleted(DateTime date) {
    return state.any((streak) =>
        streak.date.year == date.year &&
        streak.date.month == date.month &&
        streak.date.day == date.day &&
        streak.isCompleted);
  }

  int getCurrentStreak() {
    return state.where((streak) => streak.isCompleted).length;
  }
}
