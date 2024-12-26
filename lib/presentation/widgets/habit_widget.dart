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
    final completionCount = habit.targetAmount;
    final currentCount = 0; // This should come from completion tracking

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppSecondaryColors.gluonGrey.withOpacity(0.7)
            : AppSecondaryColors.snow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted
              ? AppSecondaryColors.liquidLava.withOpacity(0.5)
              : AppSecondaryColors.slateGrey.withOpacity(0.2),
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isCompleted
                ? AppSecondaryColors.liquidLava
                : AppSecondaryColors.slateGrey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              habit.iconPath,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          habit.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted
                ? AppSecondaryColors.dustyGrey
                : isDarkMode
                    ? AppSecondaryColors.snow
                    : AppSecondaryColors.darkVoid,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (completionCount > 1) ...[
              const SizedBox(height: 4),
              Row(
                children: List.generate(
                  completionCount,
                  (index) => Container(
                    width: 16,
                    height: 4,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: index < currentCount
                          ? AppSecondaryColors.liquidLava
                          : AppSecondaryColors.slateGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ],
            Text(
              habit.frequency,
              style: TextStyle(
                color: AppSecondaryColors.dustyGrey,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: !isCompleted
            ? IconButton(
                onPressed: onComplete,
                icon: Icon(
                  Icons.check_circle_outline,
                  color: AppSecondaryColors.liquidLava,
                ),
              )
            : Icon(
                Icons.check_circle,
                color: AppSecondaryColors.liquidLava,
              ),
      ),
    );
  }
}
