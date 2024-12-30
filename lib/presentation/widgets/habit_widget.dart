import 'package:flutter/material.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';

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
            ? AppSecondaryColors.dustyGrey.withOpacity(0.2)
            : AppSecondaryColors.snow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: _habitIcon(),
        title: _title(context),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time_outlined, size: 16),
                Gap.extraLow,
                Text(
                  '${habit.targetValue}${habit.targetType == 'duration' ? ' min' : ' times'}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
                Text(' | ${habit.frequency}'),
              ],
            ),
            Row(
              children: [
                Text(
                  '🔥  5 gün',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            )
          ],
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

  Text _title(BuildContext context) {
    return Text(habit.title,
        style:
            Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 16));
  }

  Text _habitIcon() {
    return Text(
      habit.iconPath,
      style: const TextStyle(fontSize: 28),
    );
  }
}
