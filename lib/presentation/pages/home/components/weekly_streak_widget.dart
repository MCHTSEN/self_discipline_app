import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/presentation/pages/home/components/flame_animation.dart';
import 'package:self_discipline_app/presentation/pages/home/components/streak_indicator.dart';

class DailyStreakWidget extends StatefulWidget {
  const DailyStreakWidget({super.key});

  @override
  _DailyStreakWidgetState createState() => _DailyStreakWidgetState();
}

class _DailyStreakWidgetState extends State<DailyStreakWidget> {
  DateTime currentDate = DateTime.now();
  late ScrollController _scrollController;

  // Get first and last day of current month
  DateTime get startDate => DateTime(currentDate.year, currentDate.month, 1);
  DateTime get endDate => DateTime(currentDate.year, currentDate.month, 0);
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

  @override
  Widget build(BuildContext context) {
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
                  StreakIndicator(streak: 5),
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
                bool isCompleted = date.isBefore(DateTime.now());

                return Container(
                  width: 60,
                  height: 80,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: currentDate.day == date.day
                        ? AppColors.primaryYellow
                        : isCompleted
                            ? const Color(0xffB9D2B3)
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
                                color: Colors.grey[400],
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
