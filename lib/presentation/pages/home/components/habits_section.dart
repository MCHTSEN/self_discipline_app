import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
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
    final dayOfWeek = now.weekday; // 1 (Monday) to 7 (Sunday)

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
      return const Text('No habits scheduled for today.');
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
          color: AppSecondaryColors.liquidLava.withOpacity(0.05),
          borderRadius: ProjectRadiusType.extraLargeRadius.allRadius),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                    '🌟 Today\'s Tasks (${completedHabits.length}/${filteredHabits.length})',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 16)),
                Gap.normal,
                Expanded(
                    child: Container(
                        height: 2,
                        color: const Color.fromARGB(255, 120, 119, 119)))
              ],
            ),
            Gap.low,
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
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
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final habit = habits[index];
          return HabitWidget(
            habit: habit,
            onComplete: () => onCompleteHabit(habit.id),
            isCompleted: isCompleted,
            onUncomplete: () => onUncompleteHabit(habit.id),
          );
        },
        childCount: habits.length,
      ),
    );
  }
}
