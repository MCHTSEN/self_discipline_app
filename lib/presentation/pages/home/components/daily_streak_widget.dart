import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';

class DailyStreakWidget extends ConsumerStatefulWidget {
  const DailyStreakWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<DailyStreakWidget> createState() => _DailyStreakWidgetState();
}

class _DailyStreakWidgetState extends ConsumerState<DailyStreakWidget> {
  DateTime currentDate = DateTime.now();

  late final ScrollController _scrollController;
  late final PageController _pageController;
  late int totalWeeks;
  late int currentWeek;

  /// Returns the first day of the current month
  DateTime get startDate => DateTime(currentDate.year, currentDate.month, 1);

  /// Returns the last day of the current month
  DateTime get endDate => DateTime(currentDate.year, currentDate.month + 1, 0);

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _scrollToCurrentWeek();
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

  /// Bu metot, sayfa controller ekrana mount olmadan çağrılırsa hata verir.
  /// O yüzden mounted + hasClients kontrolü ekliyoruz.
  void _scrollToCurrentWeek() {
    if (!mounted) return;
    if (!_pageController.hasClients) return;

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

  /// Haftalık görünümdeki günleri hesaplar
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
          dayNumber < 0 ? 31 + dayNumber : dayNumber - endDate.day + 1,
        ));
      } else {
        days.add(DateTime(currentDate.year, currentDate.month, dayNumber + 1));
      }
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dayWidth = (screenWidth - 150) / 7;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final habitState = ref.watch(habitListProvider.notifier);
    final Color firstColor = Colors.black;
    final Color secondaryColor = Colors.grey[700]!;
    final currentMonrh = DateFormat('MMMM').format(currentDate);

    return Container(
      width: double.infinity,
      height: 80,
      child: PageView.builder(
        controller: _pageController,
        itemCount: totalWeeks,
        itemBuilder: (context, weekIndex) {
          final weekDays = _getDaysInWeek(weekIndex);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: weekDays.map((date) {
                  final bool isCompleted = habitState.isDateCompleted(date);
                  final bool isCurrentDay = date.day == currentDate.day &&
                      date.month == currentDate.month;
                  final bool isCurrentMonth = date.month == currentDate.month;

                  final cardColor = (isCurrentDay)
                      ? Colors.white
                      : Colors.transparent;

                  final borderColor =
                      isCurrentDay ? Colors.grey : Colors.transparent;

                  final dayTextColor = isCompleted
                      ? Colors.white
                      : isCurrentDay
                          ? Colors.red
                          : secondaryColor;

                  final dayNumberTextColor =
                      isCompleted ? Colors.white : secondaryColor;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: dayWidth,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          gradient: isCompleted
                              ? LinearGradient(
                                  colors: [
                                    const Color.fromARGB(255, 234, 15, 245)
                                        .withOpacity(.3),
                                    const Color.fromARGB(255, 157, 15, 245)
                                        .withOpacity(.6),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                )
                              : null,
                          color: isCompleted ? null : cardColor,
                          borderRadius:
                              ProjectRadiusType.normalRadius.allRadius,
                          border: Border.all(color: borderColor, width: 0.6),
                        ),
                        child: Column(
                          children: [
                            Text(
                              // "6\nTue" format
                              DateFormat('d').format(date),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: dayNumberTextColor,
                                fontWeight: isCurrentMonth
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            Text(
                              // "6\nTue" format
                              DateFormat('EEE').format(date).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: dayTextColor,
                                fontWeight: isCurrentMonth
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
