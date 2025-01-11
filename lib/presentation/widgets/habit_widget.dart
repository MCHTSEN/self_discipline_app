import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';
import 'package:self_discipline_app/presentation/widgets/animated_text.dart';

class HabitWidget extends ConsumerWidget {
  final HabitEntity habit;
  final VoidCallback onComplete;
  final VoidCallback onUncomplete;
  final Function(int) onQuantityAdd;
  final bool isCompleted;

  const HabitWidget({
    super.key,
    required this.habit,
    required this.onComplete,
    required this.onUncomplete,
    required this.onQuantityAdd,
    required this.isCompleted,
  });

  void _handleComplete(BuildContext context, WidgetRef ref) {
    onComplete();

    // Show completion celebration
    ref.read(habitListProvider.notifier).showCompletionCelebration(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitFrequencyString = habit.frequency == 'daily'
        ? 'Günlük'
        : habit.frequency == 'weekly'
            ? 'Haftalık'
            : 'Ozel';
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppSecondaryColors.dustyGrey.withOpacity(0.2)
            : AppSecondaryColors.snow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isCompleted
                ? Color.fromARGB(255, 255, 109, 255)
                : Colors.transparent,
            width: 1),
      ),
      child: ListTile(
        leading: _habitIcon(),
        title: _title(context),
        subtitle: _infos(context, habitFrequencyString),
        trailing: _buildTrailingButton(context, ref),
      ),
    );
  }

  Widget _buildTrailingButton(BuildContext context, WidgetRef ref) {
    if (isCompleted) {
      return IconButton(
        icon: Icon(
          Icons.check_circle,
          color: Color.fromARGB(255, 255, 109, 255),
        ),
        onPressed: onUncomplete,
      );
    }

    if (habit.targetType == 'quantity' && habit.targetValue > 1) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedText(
            text: '${habit.currentQuantity}/${habit.targetValue}',
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              onQuantityAdd(habit.currentQuantity + 1);
              HapticFeedback.lightImpact();
            },
          ),
        ],
      );
    }

    return IconButton(
      icon: Icon(Icons.check_circle_outline),
      onPressed: () {
        _handleComplete(context, ref);
        HapticFeedback.lightImpact();
      },
    );
  }

  Widget _infos(BuildContext context, String habitFrequencyString) {
    return isCompleted
        ? Row(
            children: [
              if (habit.currentStreak != 0)
                AnimatedText(
                  text: "Tamamlandı!",
                  textStyle: TextStyle(fontSize: 14.sp, color: Colors.purple),
                )
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap.extraLow,
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
                          .copyWith(fontWeight: FontWeight.w400)),
                  Text('  | ', style: TextStyle(fontSize: 12.sp)),
                  Icon(Icons.repeat, size: 11.sp),
                  Flexible(
                    child: Text(' $habitFrequencyString olarak yenilenir',
                        style: TextStyle(fontSize: 11.sp)),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '🔥 ${habit.currentStreak} gün',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              )
            ],
          );
  }

  Row _title(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Text(
            habit.title,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontSize: 14, color: isCompleted ? Colors.purple : null),
          ),
        ),
      ],
    );
  }

  Widget _habitIcon() {
    return isCompleted
        ? Icon(
            Icons.star,
            color: Color.fromARGB(255, 255, 211, 36),
          )
        : Text(
            habit.iconPath,
            style: const TextStyle(fontSize: 28),
          );
  }
}
