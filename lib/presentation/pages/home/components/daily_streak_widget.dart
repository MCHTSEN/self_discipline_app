import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:self_discipline_app/domain/entities/daily_streak_entity.dart';
import 'package:self_discipline_app/presentation/viewmodels/providers.dart';

/// A widget that displays the daily streak calendar and current streak count.
/// Shows a flame emoji for days where all habits were completed.
class DailyStreakWidget extends ConsumerStatefulWidget {
  const DailyStreakWidget({super.key});

  @override
  ConsumerState<DailyStreakWidget> createState() => _DailyStreakWidgetState();
}

class _DailyStreakWidgetState extends ConsumerState<DailyStreakWidget> {
  late PageController _pageController;
  late DateTime _currentDate;
  late int _currentWeek;
  late int _totalWeeks;

  @override
  void initState() {
    super.initState();
    _currentDate = DateTime.now();
    _initializeController();
  }

  void _initializeController() {
    final DateTime firstDayOfMonth =
        DateTime(_currentDate.year, _currentDate.month, 1);
    final DateTime lastDayOfMonth =
        DateTime(_currentDate.year, _currentDate.month + 1, 0);

    _totalWeeks =
        ((lastDayOfMonth.day + firstDayOfMonth.weekday - 1) / 7).ceil();
    _currentWeek =
        ((_currentDate.day + firstDayOfMonth.weekday - 1) / 7).ceil() - 1;
    _pageController = PageController(initialPage: _currentWeek);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<DateTime> _getDaysInWeek(int week) {
    final DateTime firstDayOfMonth =
        DateTime(_currentDate.year, _currentDate.month, 1);
    final int firstWeekday = firstDayOfMonth.weekday - 1;
    final int startingDay = week * 7 - firstWeekday;

    return List.generate(7, (index) {
      final int dayNumber = startingDay + index;
      if (dayNumber < 0) {
        final DateTime lastMonth =
            DateTime(_currentDate.year, _currentDate.month, 0);
        return lastMonth.add(Duration(days: dayNumber + 1));
      } else if (dayNumber >=
          DateTime(_currentDate.year, _currentDate.month + 1, 0).day) {
        return DateTime(
            _currentDate.year,
            _currentDate.month + 1,
            dayNumber -
                DateTime(_currentDate.year, _currentDate.month + 1, 0).day +
                1);
      }
      return DateTime(_currentDate.year, _currentDate.month, dayNumber + 1);
    });
  }

  bool _isDateCompleted(DateTime date) {
    final streakNotifier = ref.read(streakProvider.notifier);
    return streakNotifier.isDateCompleted(date);
  }

  @override
  Widget build(BuildContext context) {
    final streaks = ref.watch(streakProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(_currentDate),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                'Current Streak: ${streaks.where((streak) => streak.isCompleted).length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                .map((day) =>
                    Text(day, style: Theme.of(context).textTheme.bodySmall))
                .toList(),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _totalWeeks,
              itemBuilder: (context, weekIndex) {
                final weekDays = _getDaysInWeek(weekIndex);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekDays.map((date) {
                    final bool isCompleted = _isDateCompleted(date);
                    final bool isToday = date.year == DateTime.now().year &&
                        date.month == DateTime.now().month &&
                        date.day == DateTime.now().day;
                    final bool isCurrentMonth =
                        date.month == _currentDate.month;

                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color:
                            isCompleted ? Colors.green.withOpacity(0.2) : null,
                        border: isToday
                            ? Border.all(color: Theme.of(context).primaryColor)
                            : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isCompleted)
                              const Text('🔥', style: TextStyle(fontSize: 12)),
                            Text(
                              '${date.day}',
                              style: TextStyle(
                                color: isCurrentMonth
                                    ? Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.color
                                    : Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
