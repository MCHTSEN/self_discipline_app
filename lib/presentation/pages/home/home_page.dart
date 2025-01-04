import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/core/utils/logger.dart';
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
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeaderCard(context),
                      _buildStreakCard(context),
                      Gap.normal,
                      _buildProgressCard(context),
                      Gap.normal,
                    ],
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: _buildHabitsSection(habitListState),
                ),
              ],
            ),
          ),
        ),
        const StreakCelebration(),
      ],
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      margin: ProjectPaddingType.defaultPadding.allPadding,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppSecondaryColors.liquidLava,
            AppSecondaryColors.liquidLava.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppSecondaryColors.liquidLava.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeaderSection(),
          Gap.low,
          Text(
            '🚀 Small steps lead to big changes.',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  height: 0.8,
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    return Container(
      margin: ProjectPaddingType.defaultPadding.symmetricHorizontalPadding,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const DailyStreakWidget(),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: ProjectPaddingType.defaultPadding.value,
        right: ProjectPaddingType.defaultPadding.value,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Container(
            padding: ProjectPaddingType.smallPadding.allPadding,
            child: Text(
              '📈 Progress Overview',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 5,
                child: Text('Jan'),
              ),
              Positioned(
                bottom: 0,
                right: 5,
                child: Text('Dec'),
              ),
              LineChartSample5(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsSection(AsyncValue<List<HabitEntity>> habitListState) {
    return habitListState.when(
      data: (habits) => HabitsSection(
        habits: habits,
        onCompleteHabit: (habitId) {
          Logger.info('Completing habit: $habitId');
          ref.read(habitListProvider.notifier).completeHabit(habitId);
        },
        onUncompleteHabit: (habitId) {
          Logger.info('Uncompleting habit: $habitId');
          ref.read(habitListProvider.notifier).uncompleteHabit(habitId);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
