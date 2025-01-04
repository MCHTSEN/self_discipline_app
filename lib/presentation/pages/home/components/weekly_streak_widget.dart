import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/presentation/pages/home/components/streak_indicator.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';

/// A widget that displays the daily streak calendar and current streak count.
/// Shows a flame emoji for days where all habits were completed.
class DailyStreakWidget extends ConsumerStatefulWidget {
  const DailyStreakWidget({super.key});

  @override
  ConsumerState<DailyStreakWidget> createState() => _DailyStreakWidgetState();
}

class _DailyStreakWidgetState extends ConsumerState<DailyStreakWidget> {
  DateTime currentDate = DateTime.now();
  late ScrollController _scrollController;
  late PageController _pageController;
  late int totalWeeks;
  late int currentWeek;

  /// Returns the first day of the current month
  DateTime get startDate => DateTime(currentDate.year, currentDate.month, 1);

  /// Returns the last day of the current month
  DateTime get endDate => DateTime(currentDate.year, currentDate.month + 1, 0);

  /// Returns the current month name
  String get _currentDate => DateFormat('MMMM').format(currentDate);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    // Scroll to current date after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentWeek();
    });
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    totalWeeks = ((endDate.day + startDate.weekday - 1) / 7).ceil();
    currentWeek = ((currentDate.day + startDate.weekday - 1) / 7).ceil() - 1;
    _pageController = PageController(initialPage: currentWeek);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _scrollToCurrentWeek() {
    _pageController.animateToPage(
      currentWeek,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  /// Returns the current streak count from all habits
  int _getCurrentStreak() {
    final habitsState = ref.watch(habitListProvider);
    return habitsState.when(
      data: (habits) {
        if (habits.isEmpty) return 0;
        return habits
            .map((h) => h.currentStreak)
            .reduce((a, b) => a > b ? a : b);
      },
      loading: () => 0,
      error: (_, __) => 0,
    );
  }

  /// Checks if all habits were completed for a specific date
  bool _isDateCompleted(DateTime date) {
    final habitsState = ref.watch(habitListProvider);
    return habitsState.when(
      data: (habits) {
        if (habits.isEmpty) return false;
        return habits.every((habit) => habit.completions.any(
              (completion) =>
                  completion.year == date.year &&
                  completion.month == date.month &&
                  completion.day == date.day,
            ));
      },
      loading: () => false,
      error: (_, __) => false,
    );
  }

  List<DateTime> _getDaysInWeek(int week) {
    final List<DateTime> days = [];
    final int firstDayOffset = startDate.weekday - 1;
    final int startingDay = week * 7 - firstDayOffset;

    for (int i = 0; i < 7; i++) {
      final int dayNumber = startingDay + i;
      if (dayNumber < 0 || dayNumber >= endDate.day) {
        days.add(DateTime(
            currentDate.year,
            currentDate.month + (dayNumber < 0 ? -1 : 1),
            dayNumber < 0 ? 31 + dayNumber : dayNumber - endDate.day + 1));
      } else {
        days.add(DateTime(currentDate.year, currentDate.month, dayNumber + 1));
      }
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final currentStreak = _getCurrentStreak();
    final screenWidth = MediaQuery.of(context).size.width;
    final dayWidth = (screenWidth - 103) / 7;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_currentDate, style: Theme.of(context).textTheme.bodyMedium),
            Row(
              children: [
                Text(
                  'Streak:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Gap.low,
                StreakIndicator(streak: currentStreak),
              ],
            ),
          ],
        ),
        Gap.low,
        SizedBox(
          height: 70,
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalWeeks,
            itemBuilder: (context, weekIndex) {
              final weekDays = _getDaysInWeek(weekIndex);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekDays.map((date) {
                  final bool isCompleted = _isDateCompleted(date);
                  final bool isCurrentDay = date.day == currentDate.day &&
                      date.month == currentDate.month;
                  final bool isCurrentMonth = date.month == currentDate.month;

                  return Container(
                    width: dayWidth,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: isCurrentDay
                          ? AppSecondaryColors.liquidLava.withOpacity(.7)
                          : isCompleted
                              ? AppSecondaryColors.liquidLava.withOpacity(.07)
                              : isDarkMode
                                  ? AppSecondaryColors.gluonGrey
                                  : Colors.grey[200],
                      borderRadius: ProjectRadiusType.largeRadius.allRadius,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        isCompleted
                            ? const Text(
                                '🔥',
                                style: TextStyle(fontSize: 14),
                              )
                            : Container(
                                width: 12,
                                height: 12,
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color: isCurrentDay
                                      ? AppSecondaryColors.liquidLava
                                      : isDarkMode
                                          ? AppSecondaryColors.dustyGrey
                                          : Colors.grey[400],
                                  shape: BoxShape.circle,
                                ),
                              ),
                        Text(
                          DateFormat('d\nEEE').format(date),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: isCurrentMonth
                                ? isDarkMode
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimaryLight
                                : isDarkMode
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                            fontWeight: isCurrentMonth
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
