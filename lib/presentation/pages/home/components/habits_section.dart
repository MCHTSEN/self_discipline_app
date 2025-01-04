import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/widgets/habit_widget.dart';

class HabitsSection extends ConsumerWidget {
  final List<HabitEntity> habits;
  final Function(String) onCompleteHabit;
  final Function(String) onUncompleteHabit;

  const HabitsSection({
    super.key,
    required this.habits,
    required this.onCompleteHabit,
    required this.onUncompleteHabit,
  });

  bool _shouldShowHabit(HabitEntity habit) {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;

    if (habit.frequency == 'daily') {
      return true;
    } else if (habit.frequency == 'custom' && habit.customDays != null) {
      return habit.customDays!.contains(dayOfWeek);
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredHabits = habits.where(_shouldShowHabit).toList();

    if (filteredHabits.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 48,
              color: AppSecondaryColors.liquidLava.withOpacity(0.5),
            ),
            Gap.normal,
            Text(
              'No habits scheduled for today',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      );
    }

    final now = DateTime.now();
    final completedHabits = filteredHabits.where((h) {
      if (h.lastCompletedAt == null) return false;
      return h.lastCompletedAt!.year == now.year &&
          h.lastCompletedAt!.month == now.month &&
          h.lastCompletedAt!.day == now.day;
    }).toList();

    final uncompletedHabits = filteredHabits.where((h) {
      if (h.lastCompletedAt == null) return true;
      return h.lastCompletedAt!.year != now.year ||
          h.lastCompletedAt!.month != now.month ||
          h.lastCompletedAt!.day != now.day;
    }).toList();

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  '🎯 Today\'s Tasks',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Gap.normal,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppSecondaryColors.liquidLava.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${completedHabits.length}/${filteredHabits.length}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppSecondaryColors.liquidLava,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              primary: false,
              slivers: [
                if (uncompletedHabits.isNotEmpty) ...[
                  _buildSectionHeader(context, 'To Complete'),
                  _buildHabitsList(uncompletedHabits, false),
                ],
                if (completedHabits.isNotEmpty) ...[
                  _buildSectionHeader(context, 'Completed Today'),
                  _buildHabitsList(completedHabits, true),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            color: AppSecondaryColors.dustyGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildHabitsList(List<HabitEntity> habits, bool isCompleted) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final habit = habits[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: HabitWidget(
                habit: habit,
                onComplete: () => onCompleteHabit(habit.id),
                isCompleted: isCompleted,
                onUncomplete: () => onUncompleteHabit(habit.id),
              ),
            );
          },
          childCount: habits.length,
        ),
      ),
    );
  }
}
