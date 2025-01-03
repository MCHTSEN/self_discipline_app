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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppSecondaryColors.liquidLava,
            AppSecondaryColors.liquidLava.withOpacity(0.9),
            AppSecondaryColors.liquidLava.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.2, 0.6, 0.9],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppSecondaryColors.liquidLava.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: AppSecondaryColors.liquidLava.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 12),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.04),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const HeaderSection(),
              Gap.low,
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.rocket_launch_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                    Gap.extraLow,
                    Flexible(
                      child: Text(
                        'Keep pushing your limits!',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.2,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
