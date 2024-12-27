import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/presentation/pages/home/components/header_section.dart';
import 'package:self_discipline_app/presentation/pages/home/components/weekly_streak_widget.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';
import 'package:self_discipline_app/presentation/widgets/predict_line_chart.dart';
import 'package:self_discipline_app/presentation/widgets/streak_celebration.dart';
import 'package:self_discipline_app/presentation/pages/home/components/habits_section.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final habitListState = ref.watch(habitListProvider);

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: ProjectPaddingType
                      .defaultPadding.symmetricHorizontalPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderSection(),
                      Text('🚀 Small steps lead to big changes.',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                Gap.normal,
                const DailyStreakWidget(),
                Gap.normal,
                Expanded(
                  child: Padding(
                    padding: ProjectPaddingType
                        .defaultPadding.symmetricHorizontalPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LineChartSample5(),
                        Text('Today\'s Tasks',
                            style: Theme.of(context).textTheme.labelLarge),
                        Gap.low,
                        _buildHabitsSection(habitListState)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const StreakCelebration(),
      ],
    );
  }

  Widget _buildHabitsSection(AsyncValue<List<HabitEntity>> habitListState) {
    return habitListState.when(
      data: (habits) => HabitsSection(
        habits: habits,
        onCompleteHabit: (habitId) {
          ref.read(habitListProvider.notifier).completeHabit(habitId);
        },
      ),
      loading: () => const Expanded(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Expanded(
        child: Center(child: Text('Error: $err')),
      ),
    );
  }
}
