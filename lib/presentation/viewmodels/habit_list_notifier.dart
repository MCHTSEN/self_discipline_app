import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/domain/usecases/get_habits_usecase.dart';
import 'package:self_discipline_app/domain/usecases/create_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/update_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/delete_habit_usecase.dart';
import 'package:self_discipline_app/presentation/viewmodels/streak_celebration_provider.dart';
import 'package:self_discipline_app/presentation/widgets/completion_celebration.dart';
import 'package:self_discipline_app/presentation/widgets/bottom_completion_animation.dart';
import 'package:self_discipline_app/presentation/widgets/top_celebration_animation.dart';
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

  bool _shouldShowHabitOnDate(HabitEntity habit, DateTime date) {
    final dayOfWeek = date.weekday;
    final dayOfMonth = date.day;

    switch (habit.frequency) {
      case 'daily':
        return true;
      case 'weekly':
        return habit.customDays?.contains(dayOfWeek) ?? false;
      case 'custom':
        return habit.customDays?.contains(dayOfMonth) ?? false;
      default:
        return false;
    }
  }

  int get currentStreak {
    int streak = 0;
    DateTime checkDate = DateTime.now().subtract(const Duration(days: 1));

    while (isDateCompleted(checkDate)) {
      streak++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    if (isDateCompleted(DateTime.now())) {
      streak++;
    }

    return streak;
  }

  bool isDateCompleted(DateTime date) {
    final habitsState = state;
    return habitsState.when(
      data: (habits) {
        if (habits.isEmpty) return false;

        // O tarihe kadar oluşturulmuş ve o tarihte yapılması gereken habitleri filtrele
        final habitsForDate = habits.where((habit) {
          return (habit.createdAt.isBefore(date) ||
                  _isSameDay(habit.createdAt, date)) &&
              _shouldShowHabitOnDate(habit, date);
        }).toList();

        if (habitsForDate.isEmpty) return false;

        // O güne ait habitlerin hepsi tamamlanmış mı kontrol et
        return habitsForDate.every(
          (habit) => habit.completions.any(
            (completion) => _isSameDay(completion, date),
          ),
        );
      },
      loading: () => false,
      error: (_, __) => false,
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
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
  Future<void> completeHabit(String habitId, BuildContext context) async {
    final currentState = state;
    if (!currentState.hasValue) return;

    final habits = currentState.value!;
    final habitIndex = habits.indexWhere((h) => h.id == habitId);
    if (habitIndex == -1) return;

    final habit = habits[habitIndex];
    final now = DateTime.now();

    if (habit.isCompletedToday) return;

    final newCompletions = [...habit.completions, now];

    // Sadece bugün için planlanmış habitleri kontrol et
    bool allHabitsCompletedToday =
        habits.where((h) => _shouldShowHabitOnDate(h, now)).every((h) {
      if (h.id == habitId) return true;
      return h.completions.any((completion) => _isSameDay(completion, now));
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
      currentQuantity: habit.targetType == 'quantity' ? habit.targetValue : 0,
    );

    await _updateHabitInStateAndStorage(habitIndex, updatedHabit);

    // Show celebrations after updating the habit
    showCompletionCelebration(context);
  }

  /// Updates the quantity progress for a habit
  Future<void> updateQuantity(
      String habitId, int newQuantity, BuildContext context) async {
    final currentState = state;
    if (!currentState.hasValue) return;

    final habits = currentState.value!;
    final habitIndex = habits.indexWhere((h) => h.id == habitId);
    if (habitIndex == -1) return;

    final habit = habits[habitIndex];
    final now = DateTime.now();

    if (habit.targetType != 'quantity' || habit.isCompletedToday) return;

    if (newQuantity >= habit.targetValue) {
      await completeHabit(habitId, context);
      return;
    }

    final updatedHabit = habit.copyWith(
      currentQuantity: newQuantity,
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

    final newCompletions =
        habit.completions.where((date) => !_isSameDay(date, now)).toList();

    int newStreak = habit.currentStreak;
    bool anyHabitCompletedToday =
        habits.where((h) => _shouldShowHabitOnDate(h, now)).any((h) {
      if (h.id == habitId) return false;
      return h.completions.any((completion) => _isSameDay(completion, now));
    });

    if (!anyHabitCompletedToday) {
      newStreak = 0;
    }

    final updatedHabit = habit.copyWith(
      completions: newCompletions,
      currentStreak: newStreak,
      bestStreak: habit.bestStreak,
      currentQuantity: 0,
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

    switch (habit.frequency) {
      case 'daily':
        // For daily habits, streak continues if completed today or yesterday
        if (difference <= 1) {
          return habit.currentStreak + 1;
        }
        return 1;

      case 'weekly':
        // For weekly habits, check if the completion is within the required days
        if (habit.customDays == null || habit.customDays!.isEmpty) {
          return 1; // Invalid configuration
        }

        // Get the last required day before today
        final todayWeekday = now.weekday;
        final lastRequiredDay = habit.customDays!
            .where((day) => day < todayWeekday)
            .fold<int>(0, (prev, curr) => curr > prev ? curr : prev);

        // If no previous required day this week, check last week's last day
        final daysToCheck = lastRequiredDay == 0
            ? habit.customDays!.reduce((a, b) => a > b ? a : b)
            : lastRequiredDay;

        // Calculate the maximum allowed difference based on the days
        final maxAllowedDifference =
            lastRequiredDay == 0 ? 7 : (todayWeekday - daysToCheck);

        if (difference <= maxAllowedDifference) {
          return habit.currentStreak + 1;
        }
        return 1;

      case 'custom': // Monthly
        // For monthly habits, check if the completion is within the required days
        if (habit.customDays == null || habit.customDays!.isEmpty) {
          return 1; // Invalid configuration
        }

        final todayDay = now.day;
        // Get the last required day before today
        final lastRequiredDay = habit.customDays!
            .where((day) => day < todayDay)
            .fold<int>(0, (prev, curr) => curr > prev ? curr : prev);

        // If no previous required day this month, check last month's last day
        final daysToCheck = lastRequiredDay == 0
            ? habit.customDays!.reduce((a, b) => a > b ? a : b)
            : lastRequiredDay;

        // Calculate the maximum allowed difference based on the days
        final maxAllowedDifference = lastRequiredDay == 0
            ? _getDaysInMonth(now.month - 1, now.year) // Previous month
            : (todayDay - daysToCheck);

        if (difference <= maxAllowedDifference) {
          return habit.currentStreak + 1;
        }
        return 1;

      default:
        return 1;
    }
  }

  int _getDaysInMonth(int month, int year) {
    if (month == 0) {
      month = 12;
      year--;
    }
    return DateTime(year, month + 1, 0).day;
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

  /// Shows completion celebration when all habits are completed
  void showCompletionCelebration(BuildContext context) {

     // Check if all habits are completed
    final now = DateTime.now();
    final habits = state.value ?? [];
    bool allHabitsCompletedToday = habits
        .where((h) => _shouldShowHabitOnDate(h, now))
        .every((h) => h.isCompletedToday);


    // Show bottom animation for individual completion
    if(!allHabitsCompletedToday)
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => const BottomCompletionAnimation(),
    );

   

    if (allHabitsCompletedToday) {
      // Show top celebration for all habits completion
      Future.delayed(const Duration(milliseconds: 500), () {
        if (context.mounted) {
          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (context) => const TopCelebrationAnimation(),
          );
        }
      });
    }
  }

  /// Gets the total number of habits scheduled for today
  int getTotalHabitsForToday() {
    final now = DateTime.now();
    return state.when(
      data: (habits) {
        return habits.where((h) => _shouldShowHabitOnDate(h, now)).length;
      },
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  /// Gets the number of completed habits for today
  int getCompletedHabitsForToday() {
    final now = DateTime.now();
    return state.when(
      data: (habits) {
        return habits
            .where((h) => _shouldShowHabitOnDate(h, now))
            .where((h) => h.completions.any((c) => _isSameDay(c, now)))
            .length;
      },
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  /// Gets the completion rate for a specific date
  double getCompletionRateForDate(DateTime date) {
    return state.when(
      data: (habits) {
        final habitsForDate =
            habits.where((h) => _shouldShowHabitOnDate(h, date)).toList();
        if (habitsForDate.isEmpty) return 0.0;

        final completedHabits = habitsForDate
            .where((h) => h.completions.any((c) => _isSameDay(c, date)))
            .length;

        return completedHabits / habitsForDate.length;
      },
      loading: () => 0.0,
      error: (_, __) => 0.0,
    );
  }

  /// Gets the completion rate for the last 7 days
  double getWeeklyCompletionRate() {
    final now = DateTime.now();
    double totalRate = 0.0;
    int daysWithHabits = 0;

    for (int i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      final rate = getCompletionRateForDate(date);
      if (rate > 0) {
        totalRate += rate;
        daysWithHabits++;
      }
    }

    return daysWithHabits > 0 ? totalRate / daysWithHabits : 0.0;
  }

  /// Gets the completion rate for the last 30 days
  double getMonthlyCompletionRate() {
    final now = DateTime.now();
    double totalRate = 0.0;
    int daysWithHabits = 0;

    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final rate = getCompletionRateForDate(date);
      if (rate > 0) {
        totalRate += rate;
        daysWithHabits++;
      }
    }

    return daysWithHabits > 0 ? totalRate / daysWithHabits : 0.0;
  }

  /// Gets the number of habits completed in the last 7 days
  int getHabitsCompletedThisWeek() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: 6));
    return state.when(
      data: (habits) {
        int total = 0;
        for (var habit in habits) {
          for (var date = weekStart;
              date.isBefore(now) || _isSameDay(date, now);
              date = date.add(const Duration(days: 1))) {
            if (_shouldShowHabitOnDate(habit, date) &&
                habit.completions.any((c) => _isSameDay(c, date))) {
              total++;
            }
          }
        }
        return total;
      },
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  /// Gets the number of habits completed in the last 30 days
  int getHabitsCompletedThisMonth() {
    final now = DateTime.now();
    final monthStart = now.subtract(const Duration(days: 29));
    return state.when(
      data: (habits) {
        int total = 0;
        for (var habit in habits) {
          for (var date = monthStart;
              date.isBefore(now) || _isSameDay(date, now);
              date = date.add(const Duration(days: 1))) {
            if (_shouldShowHabitOnDate(habit, date) &&
                habit.completions.any((c) => _isSameDay(c, date))) {
              total++;
            }
          }
        }
        return total;
      },
      loading: () => 0,
      error: (_, __) => 0,
    );
  }
}
