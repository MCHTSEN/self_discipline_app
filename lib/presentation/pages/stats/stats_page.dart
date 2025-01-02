import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:collection/collection.dart';

enum TimePeriod { day, month, year }

@RoutePage()
class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  TimePeriod selectedPeriod = TimePeriod.day;

  Map<TimePeriod, Widget> get timeSegments => {
        TimePeriod.day: const Text('Day'),
        TimePeriod.month: const Text('Month'),
        TimePeriod.year: const Text('Year'),
      };

  (int completed, int total, String rate, int streak) _calculateStats(
      List<HabitEntity> habits, TimePeriod period) {
    int completedHabits = 0;
    int totalHabits = habits.length;
    int longestStreak = 0;

    switch (period) {
      case TimePeriod.day:
        completedHabits =
            habits.where((habit) => habit.isCompletedToday).length;
        longestStreak = habits.fold(
            0,
            (max, habit) =>
                habit.currentStreak > max ? habit.currentStreak : max);
        break;
      case TimePeriod.month:
        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month, 1);
        for (var habit in habits) {
          final monthlyCompletions = habit.completions
              .where((date) =>
                  date.isAfter(
                      startOfMonth.subtract(const Duration(days: 1))) &&
                  date.isBefore(now.add(const Duration(days: 1))))
              .length;
          completedHabits += monthlyCompletions;
        }
        totalHabits = habits.length * DateTime.now().day;
        break;
      case TimePeriod.year:
        final now = DateTime.now();
        final startOfYear = DateTime(now.year, 1, 1);
        final daysInYear =
            now.difference(startOfYear).inDays + 1; // +1 to include today

        for (var habit in habits) {
          final yearlyCompletions = habit.completions
              .where((date) =>
                  date.isAfter(startOfYear.subtract(const Duration(days: 1))) &&
                  date.isBefore(now.add(const Duration(days: 1))))
              .length;
          completedHabits += yearlyCompletions;
        }
        totalHabits = habits.length * daysInYear;
        break;
    }

    final completionRate = totalHabits > 0
        ? (completedHabits / totalHabits * 100).toStringAsFixed(1)
        : '0';

    return (completedHabits, totalHabits, completionRate, longestStreak);
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

  Widget _buildBestPerformerSection(
      BuildContext context, List<HabitEntity> habits) {
    if (habits.isEmpty) return const SizedBox.shrink();

    // Find habit with longest streak
    final bestHabit = habits.reduce(
        (curr, next) => curr.currentStreak > next.currentStreak ? curr : next);

    // Find the most productive day
    final allCompletions = habits.expand((habit) => habit.completions).toList();

    final groupedByDay = groupBy(
        allCompletions, (date) => DateTime(date.year, date.month, date.day));

    final bestDay = groupedByDay.entries.reduce(
        (curr, next) => curr.value.length > next.value.length ? curr : next);

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
            'Best Performers',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Gap.normal,
          ListTile(
            leading: Icon(Icons.local_fire_department,
                color: Theme.of(context).primaryColor),
            title: Text('Longest Streak'),
            subtitle:
                Text('${bestHabit.title} - ${bestHabit.currentStreak} days'),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today,
                color: Theme.of(context).primaryColor),
            title: Text('Most Productive Day'),
            subtitle: Text(
              '${bestDay.value.length} habits completed on '
              '${bestDay.key.day}/${bestDay.key.month}/${bestDay.key.year}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrendSection(
      BuildContext context, List<HabitEntity> habits) {
    if (habits.isEmpty) return const SizedBox.shrink();

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));

    final List<({String day, int completed})> weeklyData =
        List.generate(7, (index) {
      final date = weekStart.add(Duration(days: index));
      final completionsForDay = habits
          .where((habit) => habit.completions.any((completion) =>
              completion.year == date.year &&
              completion.month == date.month &&
              completion.day == date.day))
          .length;

      return (
        day: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index],
        completed: completionsForDay,
      );
    });

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
            'Weekly Trend',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Gap.normal,
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weeklyData.map((data) {
                final double height = data.completed > 0
                    ? (data.completed * 60 / habits.length).clamp(20.0, 60.0)
                    : 20.0;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 30,
                      height: height,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withOpacity(data.completed > 0 ? 1.0 : 0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Gap.low,
                    Text(data.day,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearlyProjectionSection(
      BuildContext context, List<HabitEntity> habits) {
    if (habits.isEmpty) return const SizedBox.shrink();

    // Calculate current consistency from start of year
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final daysSinceYearStart =
        now.difference(startOfYear).inDays + 1; // Including today

    int totalPossibleCompletions = habits.length * daysSinceYearStart;
    int actualCompletions = 0;

    for (var habit in habits) {
      actualCompletions += habit.completions
          .where((date) =>
              date.isAfter(startOfYear.subtract(const Duration(days: 1))) &&
              date.isBefore(now.add(const Duration(days: 1))))
          .length;
    }

    final currentConsistency = totalPossibleCompletions > 0
        ? actualCompletions / totalPossibleCompletions
        : 0.0;

    // Project remaining year outcomes
    final daysLeftInYear =
        DateTime(now.year, 12, 31).difference(now).inDays + 1;
    final projectedRemainingCompletions =
        (daysLeftInYear * habits.length * currentConsistency).round();
    final projectedTotalCompletions =
        actualCompletions + projectedRemainingCompletions;
    final potentialCompletions = 365 * habits.length;

    // Calculate improvement potential
    final roomForImprovement =
        ((potentialCompletions - projectedTotalCompletions) /
                potentialCompletions *
                100)
            .round();

    // Calculate projected streak based on current performance
    final averageCurrentStreak = habits.isEmpty
        ? 0
        : habits.fold<int>(0, (sum, habit) => sum + habit.currentStreak) ~/
            habits.length;
    final projectedStreak =
        (averageCurrentStreak * (1 + currentConsistency)).round();

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
          Row(
            children: [
              Icon(
                Icons.timeline,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              Gap.low,
              Text(
                'Yearly Projection',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          Gap.normal,
          Text(
            'Based on your consistency of ${(currentConsistency * 100).round()}% since January 1st',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          Gap.normal,
          ListTile(
            leading: Icon(Icons.check_circle_outline,
                color: Theme.of(context).primaryColor),
            title: const Text('Current Progress'),
            subtitle: Text(
              '$actualCompletions completions so far this year',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today,
                color: Theme.of(context).primaryColor),
            title: const Text('Projected Year End'),
            subtitle: Text(
              'Expected to reach $projectedTotalCompletions out of $potentialCompletions completions',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading:
                Icon(Icons.trending_up, color: Theme.of(context).primaryColor),
            title: const Text('Potential Improvement'),
            subtitle: Text(
              'You can improve by up to $roomForImprovement% by year end',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          ListTile(
            leading: Icon(Icons.local_fire_department,
                color: Theme.of(context).primaryColor),
            title: const Text('Projected Streak'),
            subtitle: Text(
              'You could reach a $projectedStreak day streak with consistent effort',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habitsState = ref.watch(habitListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: habitsState.when(
        data: (habits) {
          final stats = _calculateStats(habits, selectedPeriod);

          return ListView(
            padding: ProjectPaddingType.defaultPadding.allPadding,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CupertinoSegmentedControl<TimePeriod>(
                  children: timeSegments,
                  onValueChanged: (TimePeriod value) {
                    setState(() {
                      selectedPeriod = value;
                    });
                  },
                  groupValue: selectedPeriod,
                ),
              ),
              Gap.normal,
              _buildStatsSection(
                context,
                completedHabits: stats.$1,
                totalHabits: stats.$2,
                completionRate: stats.$3,
                longestStreak: stats.$4,
              ),
              Gap.normal,
              _buildWeeklyTrendSection(context, habits),
              Gap.normal,
              _buildYearlyProjectionSection(context, habits),
              Gap.normal,
              _buildBestPerformerSection(context, habits),
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
}
