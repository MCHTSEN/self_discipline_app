import 'package:flutter/material.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';

class HabitCard extends StatelessWidget {
  final HabitEntity habit;

  const HabitCard({required this.habit, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(habit.title),
      subtitle: Text(
        'Target: ${habit.targetValue}${habit.targetType == 'duration' ? ' min' : ' times'} | ${habit.frequency}',
      ),
      onTap: () {
        // Navigate to detail page
      },
    );
  }
}
