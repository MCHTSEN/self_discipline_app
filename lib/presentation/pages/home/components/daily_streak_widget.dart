import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
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

  /// Kontrol: Belirli bir tarihte (date) var olan tüm habit'ler tamamlanmış mı?
  bool _isDateCompleted(DateTime date) {
    final habitsState = ref.watch(habitListProvider);
    return habitsState.when(
      data: (habits) {
        if (habits.isEmpty) return false;

        // Sadece date tarihinden önce ya da aynı gün oluşturulmuş habit'leri kontrol ediyoruz
        final habitsExistingOnDate = habits.where((habit) {
          // createdAt, habit'in ne zaman oluşturulduğunu tutar
          return habit.createdAt.isBefore(date) ||
              _isSameDay(habit.createdAt, date);
        }).toList();

        // O güne kadar henüz hiç habit oluşturulmamışsa false dönelim
        if (habitsExistingOnDate.isEmpty) return false;

        // Bu tarihe kadar var olan habit'lerin hepsinde, date günü bir completion var mı?
        return habitsExistingOnDate.every(
          (habit) => habit.completions.any(
            (completion) =>
                completion.year == date.year &&
                completion.month == date.month &&
                completion.day == date.day,
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
    final dayWidth = (screenWidth - 130) / 7;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
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
                      ? Colors.white
                      : isCompleted
                          ? Color(0xffffbe0b)
                          : isDarkMode
                              ? Color(0xff283618)
                              : Colors.white.withOpacity(.3),
                  borderRadius: ProjectRadiusType.largeRadius.allRadius,
                  border: Border.all(
                    color: isCurrentDay
                        ? Colors.white
                        : isCompleted
                            ? Colors.white
                            : Colors.transparent,
                    width: 1,
                  ),
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
                                  ? Color(0xfffb5607)
                                  : isDarkMode
                                      ? Color(0xff606c38)
                                      : Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                          ),
                    Text(
                      // "6\nTue" format
                      DateFormat('d\nEEE').format(date),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: isCurrentMonth
                            ? isDarkMode
                                ? Colors.white
                                : Colors.black
                            : isDarkMode
                                ? Colors.white.withOpacity(0.6)
                                : Colors.black.withOpacity(0.6),
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
    );
  }
}
