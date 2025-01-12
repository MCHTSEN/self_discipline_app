import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'dart:math' show max;
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/domain/usecases/get_habits_usecase.dart';
import 'package:self_discipline_app/domain/usecases/create_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/update_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/delete_habit_usecase.dart';
import 'package:self_discipline_app/presentation/viewmodels/streak_celebration_provider.dart';
import 'providers.dart';

final habitListProvider =
    StateNotifierProvider<HabitListNotifier, AsyncValue<List<HabitEntity>>>(
        (ref) {
  return HabitListNotifier(
    getHabits: ref.watch(getHabitsUseCaseProvider),
    createHabit: ref.watch(createHabitUseCaseProvider),
    updateHabit: ref.watch(updateHabitUseCaseProvider),
    deleteHabit: ref.watch(deleteHabitUseCaseProvider),
    habitBox: ref.watch(habitBoxProvider),
    streakCelebrationNotifier: ref.read(streakCelebrationProvider.notifier),
  );
});

/// A state notifier that manages the list of habits and their completion status.
/// Handles habit creation, modification, completion, and streak calculations.
class HabitListNotifier extends StateNotifier<AsyncValue<List<HabitEntity>>> {
  final GetHabitsUseCase getHabits;
  final CreateHabitUseCase createHabit;
  final UpdateHabitUseCase updateHabit;
  final DeleteHabitUseCase deleteHabit;
  final Box<HabitModel> habitBox;
  final StreakCelebrationNotifier streakCelebrationNotifier;

  HabitListNotifier({
    required this.getHabits,
    required this.createHabit,
    required this.updateHabit,
    required this.deleteHabit,
    required this.habitBox,
    required this.streakCelebrationNotifier,
  }) : super(const AsyncValue.loading()) {
    _init();
  }

  /// Initializes the habit list by loading habits from storage
  Future<void> _init() async {
    try {
      final habits = await getHabits();
      state = AsyncValue.data(habits);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Adds a new habit to the list and persists it to storage
  Future<void> addHabit(HabitEntity newHabit) async {
    try {
      final now = DateTime.now();
      final creationDate = DateTime(
        now.year,
        now.month,
        now.day,
      );

      newHabit = newHabit.copyWith(createdAt: creationDate);

      await createHabit(newHabit);

      final currentList = state.value ?? [];
      final updatedList = [...currentList, newHabit];
      state = AsyncValue.data(updatedList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Updates an existing habit in the list and storage
  Future<void> modifyHabit(HabitEntity updatedHabit) async {
    try {
      await updateHabit(updatedHabit);
      final currentList = state.value ?? [];
      final index = currentList.indexWhere((h) => h.id == updatedHabit.id);
      if (index >= 0) {
        final updatedList = List<HabitEntity>.from(currentList);
        updatedList[index] = updatedHabit;
        state = AsyncValue.data(updatedList);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Removes a habit from the list and storage
  Future<void> removeHabit(String habitId) async {
    try {
      await deleteHabit(habitId);
      final currentList = state.value ?? [];
      final updatedList = currentList.where((h) => h.id != habitId).toList();
      state = AsyncValue.data(updatedList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Marks a habit as completed for today
  /// Updates the streak if all habits for today are completed
  /// Shows a celebration animation for weekly streak milestones
  Future<void> completeHabit(String habitId) async {
    final currentState = state;
    if (!currentState.hasValue) return;

    final habits = currentState.value!;
    final habitIndex = habits.indexWhere((h) => h.id == habitId);
    if (habitIndex == -1) return;

    final habit = habits[habitIndex];
    final now = DateTime.now();

    if (habit.isCompletedToday) return;

    final newCompletions = [...habit.completions, now];

    // Check if all habits for today are completed
    bool allHabitsCompletedToday = habits.every((h) {
      if (h.id == habitId) return true;
      return h.completions.any((completion) =>
          completion.year == now.year &&
          completion.month == now.month &&
          completion.day == now.day);
    });

    int newStreak = habit.currentStreak;
    if (allHabitsCompletedToday) {
      newStreak = _calculateNewStreak(habit, now);
      if (newStreak > 0 && newStreak % 7 == 0) {
        _showStreakCelebration(newStreak);
      }
    }

    final newBestStreak = max(newStreak, habit.bestStreak);

    final updatedHabit = habit.copyWith(
      completions: newCompletions,
      currentStreak: newStreak,
      bestStreak: newBestStreak,
    );

    await _updateHabitInStateAndStorage(habitIndex, updatedHabit);
  }

  /// Marks a habit as not completed for today
  /// Resets the streak if no habits are completed for today
  Future<void> uncompleteHabit(String habitId) async {
    final currentState = state;
    if (!currentState.hasValue) return;

    final habits = currentState.value!;
    final habitIndex = habits.indexWhere((h) => h.id == habitId);
    if (habitIndex == -1) return;

    final habit = habits[habitIndex];
    final now = DateTime.now();

    final newCompletions = habit.completions
        .where((date) =>
            date.year != now.year ||
            date.month != now.month ||
            date.day != now.day)
        .toList();

    int newStreak = habit.currentStreak;
    bool anyHabitCompletedToday = habits.any((h) {
      if (h.id == habitId) return false;
      return h.completions.any((completion) =>
          completion.year == now.year &&
          completion.month == now.month &&
          completion.day == now.day);
    });

    if (!anyHabitCompletedToday) {
      newStreak = 0;
    }

    final updatedHabit = habit.copyWith(
      completions: newCompletions,
      currentStreak: newStreak,
      bestStreak: habit.bestStreak,
    );

    await _updateHabitInStateAndStorage(habitIndex, updatedHabit);
  }

  /// Checks if a habit is completed for today
  bool _isCompletedToday(HabitEntity habit) {
    return habit.isCompletedToday;
  }

  /// Calculates the new streak value based on the habit's frequency and last completion
  /// Returns 1 for a broken streak, or increments the current streak
  int _calculateNewStreak(HabitEntity habit, DateTime now) {
    if (habit.completions.isEmpty) return 1;

    final lastCompletion = habit.completions.last;
    final difference = now.difference(lastCompletion).inDays;

    if (habit.frequency == 'daily') {
      if (difference == 0) {
        return habit.currentStreak + 1;
      } else if (difference == 1) {
        return habit.currentStreak + 1;
      } else {
        return 1;
      }
    } else if (habit.frequency == 'weekly') {
      if (difference <= 7) {
        return habit.currentStreak + 1;
      } else {
        return 1;
      }
    }

    return 1;
  }

  /// Updates a habit in both state and persistent storage
  Future<void> _updateHabitInStateAndStorage(
      int habitIndex, HabitEntity updatedHabit) async {
    final currentList = state.value!;
    final updatedList = [...currentList];
    updatedList[habitIndex] = updatedHabit;
    state = AsyncValue.data(updatedList);

    final habitModel = HabitModel.fromEntity(updatedHabit);
    await habitBox.put(updatedHabit.id, habitModel);
  }

  /// Shows a celebration animation for streak milestones
  void _showStreakCelebration(int streak) {
    streakCelebrationNotifier.showCelebration(streak);
  }
}
