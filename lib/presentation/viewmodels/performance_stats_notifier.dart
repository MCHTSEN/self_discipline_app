import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';
import 'dart:math' as math;

part 'performance_stats_notifier.freezed.dart';

/// Performance Statistics Documentation
///
/// This module manages performance statistics and projections for habits in the app.
/// It calculates various metrics based on current habit completion rates and projects
/// future performance.
///
/// Key Concepts:
/// - Current Consistency: The ratio of completed habits to total possible completions
///   from the start of the year to today.
/// - Projected Completions: Estimated total completions by year end, based on current
///   consistency rate.
/// - Room for Improvement: The percentage of additional completions possible compared
///   to the projected total.
/// - Projected Streak: Estimated streak length achievable based on current performance
///   and consistency.
///
/// Usage:
/// ```dart
/// // Access the performance stats
/// final stats = ref.watch(performanceStatsProvider);
///
/// // Use specific metrics
/// Text('Potential improvement: ${stats.roomForImprovement}%');
/// Text('Projected streak: ${stats.projectedStreak} days');
/// ```
///
/// The calculations are automatically updated whenever the habit list changes.

/// Represents the performance statistics state
@freezed
class PerformanceStats with _$PerformanceStats {
  const factory PerformanceStats({
    required int projectedTotalCompletions,
    required int potentialCompletions,
    required int roomForImprovement,
    required int projectedStreak,
    required double currentConsistency,
    required double compoundGrowthRate,
    required int daysLeft,
    required double potentialGrowth,
  }) = _PerformanceStats;

  factory PerformanceStats.initial() => const PerformanceStats(
        projectedTotalCompletions: 0,
        potentialCompletions: 0,
        roomForImprovement: 0,
        projectedStreak: 0,
        currentConsistency: 0.0,
        compoundGrowthRate: 0.01, // 1% daily growth
        daysLeft: 0,
        potentialGrowth: 1.0,
      );
}

/// Provider for performance statistics
final performanceStatsProvider =
    StateNotifierProvider<PerformanceStatsNotifier, PerformanceStats>((ref) {
  final habits = ref.watch(habitListProvider);
  return PerformanceStatsNotifier(habits.value ?? []);
});

/// Notifier class to manage performance statistics
class PerformanceStatsNotifier extends StateNotifier<PerformanceStats> {
  PerformanceStatsNotifier(List<HabitEntity> habits)
      : super(PerformanceStats.initial()) {
    calculateProjections(habits);
  }

  /// Calculates year-end projections based on current habits and performance
  void calculateProjections(List<HabitEntity> habits) {
    if (habits.isEmpty) {
      state = PerformanceStats.initial();
      return;
    }

    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    int totalPossibleCompletions = 0;
    int actualCompletions = 0;

    // Calculate from start of year to today
    for (var date = startOfYear;
        date.isBefore(now) || _isSameDay(date, now);
        date = date.add(const Duration(days: 1))) {
      final habitsForDate = habits
          .where((h) =>
              (h.createdAt.isBefore(date) || _isSameDay(h.createdAt, date)) &&
              _shouldShowHabitOnDate(h, date))
          .toList();

      totalPossibleCompletions += habitsForDate.length;
      actualCompletions += habitsForDate
          .where((h) =>
              h.completions.any((completion) => _isSameDay(completion, date)))
          .length;
    }

    // Calculate current consistency with a minimum value
    double currentConsistency = totalPossibleCompletions > 0
        ? actualCompletions / totalPossibleCompletions
        : 0.0;

    // If all habits are completed today, boost consistency
    final todayHabits =
        habits.where((h) => _shouldShowHabitOnDate(h, now)).toList();
    final completedTodayHabits = todayHabits
        .where((h) =>
            h.completions.any((completion) => _isSameDay(completion, now)))
        .length;

    if (todayHabits.isNotEmpty && completedTodayHabits == todayHabits.length) {
      currentConsistency = (currentConsistency + 1) / 2; // Boost consistency
    }

    // Ensure minimum consistency of 30%
    currentConsistency = currentConsistency.clamp(0.3, 1.0);

    // Calculate days left and projected outcomes
    final daysLeft = DateTime(now.year, 12, 31).difference(now).inDays + 1;
    int projectedRemainingPossible = 0;

    // Calculate projected completions for remaining days
    for (var date = now.add(const Duration(days: 1));
        date.isBefore(DateTime(now.year, 12, 31));
        date = date.add(const Duration(days: 1))) {
      final habitsForDate = habits
          .where((h) =>
              (h.createdAt.isBefore(date) || _isSameDay(h.createdAt, date)) &&
              _shouldShowHabitOnDate(h, date))
          .toList();
      projectedRemainingPossible += habitsForDate.length;
    }

    // Calculate projections with optimistic bias for good performance
    final projectedRemainingCompletions = (projectedRemainingPossible *
            (currentConsistency * 1.2)
                .clamp(0.0, 1.0)) // Add 20% optimistic bias
        .round();

    final projectedTotalCompletions =
        actualCompletions + projectedRemainingCompletions;
    final potentialCompletions =
        totalPossibleCompletions + projectedRemainingPossible;

    // Calculate improvement potential with minimum value
    final roomForImprovement = potentialCompletions > 0
        ? ((potentialCompletions - projectedTotalCompletions) /
                potentialCompletions *
                100)
            .round()
            .clamp(5, 100) // Ensure minimum 5% improvement potential
        : 5;

    // Calculate projected streak with improved logic
    final averageCurrentStreak = habits.isEmpty
        ? 0
        : habits.fold<int>(0, (sum, habit) => sum + habit.currentStreak) ~/
            habits.length;

    // Calculate projected streak with minimum value and optimistic projection
    final baseProjectedStreak =
        (averageCurrentStreak * (1 + currentConsistency)).round();
    final projectedStreak = baseProjectedStreak < 3
        ? (averageCurrentStreak + 3) // Minimum +3 days projection
        : baseProjectedStreak;

    // Calculate compound growth rate based on current performance
    double dailyGrowthRate = 0.01; // 1% base growth
    if (currentConsistency < 0.5) {
      dailyGrowthRate = 0.01; // Max 1% growth for all performers
    } else if (currentConsistency < 0.8) {
      dailyGrowthRate = 0.01; // Max 1% growth for all performers
    }

    // Calculate potential growth using compound interest formula: (1 + r)^t
    final potentialGrowth = math.pow(1 + dailyGrowthRate, daysLeft).toDouble();

    state = PerformanceStats(
      projectedTotalCompletions: projectedTotalCompletions,
      potentialCompletions: potentialCompletions,
      roomForImprovement: roomForImprovement,
      projectedStreak: projectedStreak,
      currentConsistency: currentConsistency,
      compoundGrowthRate: dailyGrowthRate,
      daysLeft: daysLeft,
      potentialGrowth: potentialGrowth,
    );
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
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
}
