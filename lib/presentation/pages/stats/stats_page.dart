import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';

@RoutePage()
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsState = ref.watch(habitListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: habitsState.when(
        data: (habits) {
          final completedHabits =
              habits.where((habit) => habit.isCompletedToday).length;
          final totalHabits = habits.length;
          final completionRate = totalHabits > 0
              ? (completedHabits / totalHabits * 100).toStringAsFixed(1)
              : '0';
          final longestStreak = habits.fold(
              0,
              (max, habit) =>
                  habit.currentStreak > max ? habit.currentStreak : max);

          return ListView(
            padding: ProjectPaddingType.defaultPadding.allPadding,
            children: [
              _buildStatsSection(
                context,
                completedHabits: completedHabits,
                totalHabits: totalHabits,
                completionRate: completionRate,
                longestStreak: longestStreak,
              ),
              Gap.normal,
              _buildAchievementsSection(context, habits),
              Gap.normal,
              _buildAdditionalStats(context, habits),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context, {
    required int completedHabits,
    required int totalHabits,
    required String completionRate,
    required int longestStreak,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Overview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Gap.normal,
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.check_circle_outline,
                  value: '$completedHabits/$totalHabits',
                  label: 'Habits',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.percent,
                  value: '$completionRate%',
                  label: 'Success Rate',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.local_fire_department,
                  value: longestStreak.toString(),
                  label: 'Longest Streak',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(
      BuildContext context, List<HabitEntity> habits) {
    final hasAnyHabit = habits.isNotEmpty;
    final hasSevenDayStreak = habits.any((habit) => habit.currentStreak >= 7);
    final hasAllCompleted =
        habits.isNotEmpty && habits.every((habit) => habit.isCompletedToday);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Achievements',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Gap.normal,
          _buildAchievementItem(
            context,
            icon: Icons.emoji_events,
            title: 'First Habit Created',
            subtitle: 'Created your first habit',
            isUnlocked: hasAnyHabit,
          ),
          _buildAchievementItem(
            context,
            icon: Icons.local_fire_department,
            title: '7 Day Streak',
            subtitle: 'Maintained a streak for 7 days',
            isUnlocked: hasSevenDayStreak,
          ),
          _buildAchievementItem(
            context,
            icon: Icons.star,
            title: 'Perfect Day',
            subtitle: 'Completed all habits for today',
            isUnlocked: hasAllCompleted,
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalStats(BuildContext context, List<HabitEntity> habits) {
    final totalCompletions =
        habits.fold<int>(0, (sum, habit) => sum + habit.completions.length);
    final averageStreak = habits.isEmpty
        ? 0
        : habits.fold<int>(0, (sum, habit) => sum + habit.currentStreak) ~/
            habits.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Progress',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Gap.normal,
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.check_box,
                  value: totalCompletions.toString(),
                  label: 'Total Completions',
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  context,
                  icon: Icons.trending_up,
                  value: averageStreak.toString(),
                  label: 'Average Streak',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        Gap.low,
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAchievementItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isUnlocked,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isUnlocked ? Theme.of(context).primaryColor : Colors.grey,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isUnlocked ? null : Colors.grey,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isUnlocked ? Colors.grey : Colors.grey.withOpacity(0.7),
            ),
      ),
      trailing: Icon(
        isUnlocked ? Icons.check_circle : Icons.lock,
        color: isUnlocked ? Theme.of(context).primaryColor : Colors.grey,
      ),
    );
  }
}
