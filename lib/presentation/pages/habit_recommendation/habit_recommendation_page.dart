import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';

@RoutePage()
class HabitRecommendationPage extends ConsumerWidget {
  const HabitRecommendationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Habits'),
      ),
      body: ListView(
        children: [
          _buildCategorySection(
            context,
            ref,
            'Health & Fitness 💪',
            [
              _RecommendedHabit(
                title: 'Daily Exercise',
                icon: '🏃',
                targetType: 'duration',
                targetValue: 30,
                frequency: 'daily',
                difficulty: 3,
              ),
              _RecommendedHabit(
                title: 'Drink Water',
                icon: '💧',
                targetType: 'quantity',
                targetValue: 8,
                frequency: 'daily',
                difficulty: 2,
              ),
              _RecommendedHabit(
                title: 'Meditation',
                icon: '🧘‍♂️',
                targetType: 'duration',
                targetValue: 15,
                frequency: 'daily',
                difficulty: 2,
              ),
            ],
          ),
          _buildCategorySection(
            context,
            ref,
            'Personal Growth 🌱',
            [
              _RecommendedHabit(
                title: 'Read Books',
                icon: '📚',
                targetType: 'duration',
                targetValue: 30,
                frequency: 'daily',
                difficulty: 3,
              ),
              _RecommendedHabit(
                title: 'Learn New Skill',
                icon: '💡',
                targetType: 'duration',
                targetValue: 45,
                frequency: 'daily',
                difficulty: 4,
              ),
              _RecommendedHabit(
                title: 'Journal',
                icon: '✍️',
                targetType: 'duration',
                targetValue: 15,
                frequency: 'daily',
                difficulty: 2,
              ),
            ],
          ),
          _buildCategorySection(
            context,
            ref,
            'Productivity ⚡',
            [
              _RecommendedHabit(
                title: 'Morning Routine',
                icon: '🌅',
                targetType: 'duration',
                targetValue: 60,
                frequency: 'daily',
                difficulty: 4,
              ),
              _RecommendedHabit(
                title: 'No Social Media',
                icon: '📵',
                targetType: 'duration',
                targetValue: 120,
                frequency: 'daily',
                difficulty: 4,
              ),
              _RecommendedHabit(
                title: 'Deep Work',
                icon: '💻',
                targetType: 'duration',
                targetValue: 90,
                frequency: 'daily',
                difficulty: 5,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    WidgetRef ref,
    String title,
    List<_RecommendedHabit> habits,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            return ListTile(
              leading: Text(
                habit.icon,
                style: const TextStyle(fontSize: 24),
              ),
              title: Text(habit.title),
              subtitle: Text(
                '${habit.targetValue}${habit.targetType == 'duration' ? ' min' : ' times'} | ${habit.frequency}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _addHabit(context, ref, habit),
              ),
            );
          },
        ),
        const Divider(),
      ],
    );
  }

  void _addHabit(BuildContext context, WidgetRef ref, _RecommendedHabit habit) {
    final currentHabits = ref.read(habitListProvider).value ?? [];

    final isAlreadyAdded = currentHabits.any((h) => h.title == habit.title);

    if (isAlreadyAdded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${habit.title} is already in your habits'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final newHabit = HabitEntity(
      id: DateTime.now().toIso8601String(),
      title: habit.title,
      iconPath: habit.icon,
      targetType: habit.targetType,
      targetValue: habit.targetValue,
      frequency: habit.frequency,
      difficulty: habit.difficulty,
    );

    ref.read(habitListProvider.notifier).addHabit(newHabit);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${habit.title} added to your habits'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }
}

class _RecommendedHabit {
  final String title;
  final String icon;
  final String targetType;
  final int targetValue;
  final String frequency;
  final int difficulty;

  const _RecommendedHabit({
    required this.title,
    required this.icon,
    required this.targetType,
    required this.targetValue,
    required this.frequency,
    required this.difficulty,
  });
}
