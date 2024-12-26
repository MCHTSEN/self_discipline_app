import 'dart:math';
import 'package:flutter/material.dart';

import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/pages/home/components/flame_animation.dart';

class HabitWidget extends StatelessWidget {
  final HabitEntity habit;
  final VoidCallback onComplete;
  final bool isCompleted;

  const HabitWidget({
    super.key,
    required this.habit,
    required this.onComplete,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppSecondaryColors.gluonGrey.withOpacity(0.7)
            : AppSecondaryColors.snow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Text(
          habit.iconPath,
          style: const TextStyle(fontSize: 24),
        ),
        title: Text(habit.title),
        subtitle: Text(
          '${habit.targetValue}${habit.targetType == 'duration' ? ' min' : ' times'} | ${habit.frequency}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: isCompleted
            ? const Icon(Icons.check_circle,
                color: AppSecondaryColors.dustyGrey)
            : IconButton(
                icon: const Icon(Icons.check_circle_outline),
                onPressed: onComplete,
              ),
      ),
    );
  }
}
