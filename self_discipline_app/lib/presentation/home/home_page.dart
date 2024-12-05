import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/presentation/home/components/flame_animation.dart';
import 'package:self_discipline_app/presentation/home/components/streak_indicator.dart';
import 'package:self_discipline_app/presentation/home/components/weekly_streak_widget.dart';
import 'package:self_discipline_app/presentation/widgets/base_background.dart';
import 'package:self_discipline_app/presentation/widgets/habit_widget.dart';
import 'package:self_discipline_app/presentation/widgets/line_chart.dart';
import 'package:self_discipline_app/presentation/widgets/predict_line_chart.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BaseBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding:
                ProjectPaddingType.defaultPadding.symmetricHorizontalPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  _nameAndSettings(context),
                  _quote(context),
                  Gap.normal,
                  const DailyStreakWidget(),
                  Gap.normal,
                ]),
                LineChartSample5(),
                Text(
                  'Today\'s Tasks',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Gap.low,
                const HabitWidget(
                  title: 'Read a book',
                  durationInMinutes: 30,
                  icon: '📚',
                ),
                Gap.low,
                const HabitWidget(
                  title: 'Drink water',
                  durationInMinutes: 10,
                  icon: '💧',
                ),
                Gap.low,
                const HabitWidget(
                  title: 'Exercise',
                  durationInMinutes: 20,
                  icon: '🏋️‍♂️',
                ),
                Gap.normal,
                const HabitWidget(
                  title: 'Meditate',
                  durationInMinutes: 15,
                  icon: '🧘‍♂️',
                  color: AppColors.primaryYellow,
                ),
                Gap.normal,
                const HabitWidget(
                  title: 'Write a blog post',
                  durationInMinutes: 45,
                  icon: '✍️',
                  color: AppColors.primaryGreen,
                ),

                // LineChartSample3(),
                // const LineChartSample5(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _quote(BuildContext context) {
    return Text(
      '🚀 Small steps lead to big changes.',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: AppColors.textSecondaryDark),
    );
  }

  Row _nameAndSettings(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text('Hello, Mucahit',
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
      ],
    );
  }
}
