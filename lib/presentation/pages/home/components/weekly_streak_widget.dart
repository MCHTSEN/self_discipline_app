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

  /// Returns the first day of the current month
  DateTime get startDate => DateTime(currentDate.year, currentDate.month, 1);

  /// Returns the last day of the current month
  DateTime get endDate => DateTime(currentDate.year, currentDate.month + 1, 0);

  /// Returns the current month name
  String get _currentDate => DateFormat('MMMM').format(currentDate);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // Scroll to current date after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDate();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scrolls the calendar to the current date
  void _scrollToCurrentDate() {
    // Calculate scroll offset based on current date
    final dayWidth = 68.0; // Container width (60) + margin (8)
    final currentDayIndex = currentDate.day - 1;
    final offset = currentDayIndex * dayWidth;

    // Animate to the calculated position
    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  /// Returns the current streak count from all habits
  /// The streak increases when all habits are completed for the day
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
  /// Returns true only if every habit was completed on that day
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

  @override
  Widget build(BuildContext context) {
    final currentStreak = _getCurrentStreak();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: ProjectPaddingType.defaultPadding.symmetricHorizontalPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentDate,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(),
              ),
              Row(
                children: [
                  Text(
                    'Streak:',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(),
                  ),
                  Gap.low,
                  StreakIndicator(streak: currentStreak),
                ],
              ),
            ],
          ),
        ),
        Gap.low,
        SingleChildScrollView(
          controller: _scrollController,
          physics: const PageScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              endDate.day,
              (index) {
                DateTime date = startDate.add(Duration(days: index));
                bool isCompleted = _isDateCompleted(date);

                return Container(
                  width: 60,
                  height: 80,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: currentDate.day == date.day
                        ? AppSecondaryColors.liquidLava.withOpacity(.7)
                        : isCompleted
                            ? AppSecondaryColors.liquidLava.withOpacity(.07)
                            : Colors.grey[200],
                    borderRadius: ProjectRadiusType.xLargeRadius.allRadius,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isCompleted
                          ? const Text(
                              '🔥',
                              style: TextStyle(fontSize: 17),
                            )
                          : Container(
                              width: 16,
                              height: 16,
                              margin: const EdgeInsets.symmetric(vertical: 3),
                              decoration: BoxDecoration(
                                color: currentDate.day == date.day
                                    ? AppSecondaryColors.liquidLava
                                    : Colors.grey[400],
                                shape: BoxShape.circle,
                              ),
                            ),
                      Text(
                        DateFormat('d \n EEE').format(date),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
