
class StreakCalculator {
  /// Calculates the current streak for a habit based on its completions and frequency
  static int calculateStreak(
    String frequency,
    List<DateTime> completions,
    List<int>? customDays, {
    bool removingCompletion = false,
    required DateTime createdAt,
  }) {
    if (completions.isEmpty) return 0;

    // Filter out completions before creation date
    final validCompletions =
        completions.where((date) => date.isAfter(createdAt)).toList();
    if (validCompletions.isEmpty) return 0;

    final sortedCompletions = List<DateTime>.from(validCompletions)..sort();
    final now = DateTime.now();

    // If we're removing today's completion, remove it from calculations
    if (removingCompletion) {
      sortedCompletions.removeWhere((date) =>
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day);
      if (sortedCompletions.isEmpty) return 0;
    }

    // For daily habits
    if (frequency == 'daily') {
      var lastDate = sortedCompletions.last;
      int streak = 1;

      // Check if the last completion was today or yesterday
      final daysSinceLastCompletion = now.difference(lastDate).inDays;
      if (daysSinceLastCompletion > 1) {
        return 0; // Streak broken if more than 1 day passed
      }

      // Count consecutive days backwards
      for (int i = sortedCompletions.length - 2; i >= 0; i--) {
        final currentDate = sortedCompletions[i];
        final difference = lastDate.difference(currentDate).inDays;

        if (difference == 1) {
          // Must be exactly 1 day difference for daily habits
          streak++;
          lastDate = currentDate;
        } else {
          break;
        }
      }
      return streak;
    }
    // For custom frequency habits
    else if (frequency == 'custom' && customDays != null) {
      var lastDate = sortedCompletions.last;
      int streak = 1;

      // Check if we completed it on the last expected day
      if (!customDays.contains(lastDate.day)) return 0;

      // Sort custom days to handle month transitions properly
      final sortedDays = List<int>.from(customDays)..sort();

      // If removing today's completion, we need to check if the last completion
      // was on the previous expected day
      if (removingCompletion) {
        final lastExpectedDay = _getLastExpectedDay(now, sortedDays);
        if (!_isSameDay(lastDate, lastExpectedDay)) {
          return 1; // Only count the last completion if it's not consecutive
        }
      }

      // Count consecutive completions on expected days
      var expectedPreviousDay = _getPreviousExpectedDay(lastDate, sortedDays);
      if (expectedPreviousDay == null) return streak;

      for (int i = sortedCompletions.length - 2; i >= 0; i--) {
        final currentDate = sortedCompletions[i];

        // Skip non-custom days
        if (!customDays.contains(currentDate.day)) continue;

        // Check if this completion matches the expected previous day
        if (_isSameDay(currentDate, expectedPreviousDay)) {
          streak++;
          lastDate = currentDate;
          final nextExpectedDay = _getPreviousExpectedDay(lastDate, sortedDays);
          if (nextExpectedDay == null) break;
          expectedPreviousDay = nextExpectedDay;
        } else if (expectedPreviousDay != null &&
            currentDate.isBefore(expectedPreviousDay)) {
          // We've gone too far back, streak is broken
          break;
        }
      }
      return streak;
    }

    return 0;
  }

  /// Gets the previous expected day before the given date
  static DateTime? _getPreviousExpectedDay(
      DateTime date, List<int> sortedDays) {
    final currentDay = date.day;
    final currentIndex = sortedDays.indexOf(currentDay);

    if (currentIndex <= 0) {
      // If it's the first day or not found, go to previous month
      final lastDayOfPrevMonth = DateTime(date.year, date.month, 0).day;
      final validDaysInPrevMonth =
          sortedDays.where((d) => d <= lastDayOfPrevMonth).toList()..sort();
      if (validDaysInPrevMonth.isEmpty) return null;

      return DateTime(
        date.month == 1 ? date.year - 1 : date.year,
        date.month == 1 ? 12 : date.month - 1,
        validDaysInPrevMonth.last,
      );
    }

    // Return the previous day in the same month
    return DateTime(date.year, date.month, sortedDays[currentIndex - 1]);
  }

  /// Gets the last expected day before or on the given date
  /// Never returns null because it always finds a valid day in current or previous month
  static DateTime _getLastExpectedDay(DateTime date, List<int> sortedDays) {
    // Find the last custom day that's not after the given date
    final validDays = sortedDays.where((day) => day <= date.day).toList()
      ..sort();

    if (validDays.isEmpty) {
      // If no valid days in current month, get the last day from previous month
      final lastDayOfPrevMonth = DateTime(date.year, date.month, 0).day;
      final validDaysInPrevMonth =
          sortedDays.where((d) => d <= lastDayOfPrevMonth).toList()..sort();

      // There must be at least one valid day in the previous month
      // because sortedDays is not empty and months have at least 28 days
      return DateTime(
        date.month == 1 ? date.year - 1 : date.year,
        date.month == 1 ? 12 : date.month - 1,
        validDaysInPrevMonth.last,
      );
    }

    return DateTime(date.year, date.month, validDays.last);
  }

  /// Checks if two dates represent the same day
  static bool _isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
