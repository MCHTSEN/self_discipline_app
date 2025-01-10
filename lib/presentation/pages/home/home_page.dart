// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/core/utils/logger.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/pages/home/components/daily_streak_widget.dart';
import 'package:self_discipline_app/presentation/pages/home/components/habits_section.dart';
import 'package:self_discipline_app/presentation/pages/home/components/header_section.dart';
import 'package:self_discipline_app/presentation/pages/home/components/performance_widget.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';
import 'package:self_discipline_app/presentation/widgets/dotted_divider.dart';
import 'package:self_discipline_app/presentation/widgets/predict_line_chart.dart';
import 'package:self_discipline_app/presentation/widgets/streak_celebration.dart';

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
    final formattedCurrentMonth = DateFormat.MMMM().format(DateTime.now());

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
                      Gap.normal,
                      _dailyStreakAndYearlyProgress(
                          formattedCurrentMonth, context),
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

  Container _dailyStreakAndYearlyProgress(
      String formattedCurrentMonth, BuildContext context) {
    return Container(
      margin: ProjectPaddingType.defaultPadding.symmetricHorizontalPadding,
      padding: ProjectPaddingType.defaultPadding.allPadding,
      decoration: BoxDecoration(
        borderRadius: ProjectRadiusType.extraLargeRadius.allRadius,
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(formattedCurrentMonth),
          _buildStreakCard(context),
          Row(
            children: [
              _buildProgressCard(context),
              Gap.normal,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PerformanceWidget(
                        text: 'Keep pushing your limits!',
                        icon: Icons.rocket_launch_rounded),
                    Gap.extraLow,
                    DottedDivider(),
                    Gap.extraLow,
                    PerformanceWidget(
                        text: 'Stay consistent to build a streak!',
                        icon: Icons.star),
                    Gap.extraLow,
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      margin: ProjectPaddingType.defaultPadding.symmetricHorizontalPadding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(105, 245, 15, 237),
            AppSecondaryColors.liquidLava.withOpacity(0.4),
            Color.fromARGB(94, 245, 15, 203).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.6, 0.99],
        ),
        borderRadius: ProjectRadiusType.extraLargeRadius.allRadius,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: const HeaderSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: ProjectRadiusType.extraLargeRadius.bottomLeftRightRadius,
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: const DailyStreakWidget(),
    );
  }

  Widget _buildProgressCard(BuildContext context) {
    return Container(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
