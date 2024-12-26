import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/widgets/habit_widget.dart';

class HabitsSection extends ConsumerWidget {
  final List<HabitEntity> habits;
  final Function(String) onCompleteHabit;

  const HabitsSection({
    super.key,
    required this.habits,
    required this.onCompleteHabit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (habits.isEmpty) {
      return const Text('No habits found. Add a new habit.');
    }

    final completedHabits = habits
        .where((h) => h.lastCompletedAt?.day == DateTime.now().day)
        .toList();
    final uncompletedHabits = habits
        .where((h) => h.lastCompletedAt?.day != DateTime.now().day)
        .toList();

    return Expanded(
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
            onComplete: isCompleted ? () {} : () => onCompleteHabit(habit.id),
            isCompleted: isCompleted,
          );
        },
        childCount: habits.length,
      ),
    );
  }
}
