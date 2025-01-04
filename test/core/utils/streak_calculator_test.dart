import 'package:flutter_test/flutter_test.dart';
import 'package:self_discipline_app/core/utils/streak_calculator.dart';

void main() {
  group('StreakCalculator - Daily Habits', () {
    test('should return 0 for empty completions', () {
      final createdAt = DateTime.now().subtract(const Duration(days: 7));
      final result = StreakCalculator.calculateStreak('daily', [], null,
          createdAt: createdAt);
      expect(result, 0);
    });

    test('should return 1 for single completion today', () {
      final now = DateTime.now();
      final createdAt = now.subtract(const Duration(days: 7));
      final result = StreakCalculator.calculateStreak('daily', [now], null,
          createdAt: createdAt);
      expect(result, 1);
    });

    test('should return 2 for consecutive days (yesterday and today)', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final createdAt = now.subtract(const Duration(days: 7));
      final result = StreakCalculator.calculateStreak(
        'daily',
        [yesterday, now],
        null,
        createdAt: createdAt,
      );
      expect(result, 2);
    });

    test('should return 3 for three consecutive days', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final twoDaysAgo = now.subtract(const Duration(days: 2));
      final createdAt = now.subtract(const Duration(days: 7));
      final result = StreakCalculator.calculateStreak(
        'daily',
        [twoDaysAgo, yesterday, now],
        null,
        createdAt: createdAt,
      );
      expect(result, 3);
    });

    test('should break streak if a day is missed', () {
      final now = DateTime.now();
      final twoDaysAgo = now.subtract(const Duration(days: 2));
      final createdAt = now.subtract(const Duration(days: 7));
      final result = StreakCalculator.calculateStreak(
        'daily',
        [twoDaysAgo, now],
        null,
        createdAt: createdAt,
      );
      expect(result, 1); // Only counts today since streak was broken
    });

    test('should handle removing today\'s completion', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final createdAt = now.subtract(const Duration(days: 7));
      final result = StreakCalculator.calculateStreak(
        'daily',
        [yesterday, now],
        null,
        removingCompletion: true,
        createdAt: createdAt,
      );
      expect(result, 1); // Only yesterday's completion should count
    });
  });

  group('StreakCalculator - Custom Days', () {
    test('should return 0 for empty completions', () {
      final createdAt = DateTime(2024, 1, 1);
      final result = StreakCalculator.calculateStreak('custom', [], [1, 15],
          createdAt: createdAt);
      expect(result, 0);
    });

    test('should return 1 for single completion on custom day', () {
      final now = DateTime(2024, 3, 15); // March 15th
      final customDays = [1, 15]; // 1st and 15th of each month
      final createdAt = DateTime(2024, 1, 1);
      final result = StreakCalculator.calculateStreak(
        'custom',
        [now],
        customDays,
        createdAt: createdAt,
      );
      expect(result, 1);
    });

    test('should return 0 for completion on non-custom day', () {
      final now = DateTime(2024, 3, 14); // March 14th
      final customDays = [1, 15]; // 1st and 15th of each month
      final createdAt = DateTime(2024, 1, 1);
      final result = StreakCalculator.calculateStreak(
        'custom',
        [now],
        customDays,
        createdAt: createdAt,
      );
      expect(result, 0);
    });

    test('should return 2 for consecutive custom days across months', () {
      final customDays = [1, 15]; // 1st and 15th of each month
      final march15 = DateTime(2024, 3, 15);
      final april1 = DateTime(2024, 4, 1);
      final createdAt = DateTime(2024, 1, 1);
      final result = StreakCalculator.calculateStreak(
        'custom',
        [march15, april1],
        customDays,
        createdAt: createdAt,
      );
      expect(result, 2);
    });

    test('should handle removing today\'s completion for custom days', () {
      final customDays = [1, 15];
      final march15 = DateTime(2024, 3, 15);
      final april1 = DateTime(2024, 4, 1);
      final createdAt = DateTime(2024, 1, 1);
      final result = StreakCalculator.calculateStreak(
        'custom',
        [march15, april1],
        customDays,
        removingCompletion: true,
        createdAt: createdAt,
      );
      expect(result, 1);
    });

    test('should break streak if custom day is missed', () {
      final customDays = [1, 15];
      final march1 = DateTime(2024, 3, 1);
      final april1 = DateTime(2024, 4, 1);
      final createdAt = DateTime(2024, 1, 1);
      final result = StreakCalculator.calculateStreak(
        'custom',
        [march1, april1],
        customDays,
        createdAt: createdAt,
      );
      expect(result,
          1); // Only counts the last completion since March 15th was missed
    });
  });

  group('StreakCalculator - Edge Cases', () {
    test('should handle unsupported frequency', () {
      final now = DateTime.now();
      final createdAt = now.subtract(const Duration(days: 7));
      final result = StreakCalculator.calculateStreak('weekly', [now], null,
          createdAt: createdAt);
      expect(result, 0);
    });

    test('should handle null customDays for custom frequency', () {
      final now = DateTime.now();
      final createdAt = now.subtract(const Duration(days: 7));
      final result = StreakCalculator.calculateStreak('custom', [now], null,
          createdAt: createdAt);
      expect(result, 0);
    });

    test('should handle unordered completion dates', () {
      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));
      final createdAt = now.subtract(const Duration(days: 7));
      final result = StreakCalculator.calculateStreak(
        'daily',
        [now, yesterday], // Unordered dates
        null,
        createdAt: createdAt,
      );
      expect(result, 2); // Should still count correctly
    });
  });
}
