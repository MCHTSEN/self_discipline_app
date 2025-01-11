import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';

@RoutePage()
class HabitRecommendationPage extends ConsumerWidget {
  const HabitRecommendationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lightbulb_outline, size: 32),
                  const SizedBox(height: 8),
                  Text('Recommended Habits',
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFF7F50), // Coral
                      Color(0xFFFF6B45), // Lighter coral
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildCategorySection(
                context,
                ref,
                'Health & Fitness',
                '💪',
                'Build a stronger, healthier you',
                [
                  _RecommendedHabit(
                    title: 'Daily Exercise',
                    icon: '🏃',
                    targetType: 'duration',
                    targetValue: 30,
                    frequency: 'daily',
                    difficulty: 3,
                    description: 'Stay active with daily workouts',
                  ),
                  _RecommendedHabit(
                    title: 'Drink Water',
                    icon: '💧',
                    targetType: 'quantity',
                    targetValue: 8,
                    frequency: 'daily',
                    difficulty: 2,
                    description: 'Stay hydrated throughout the day',
                  ),
                  _RecommendedHabit(
                    title: 'Meditation',
                    icon: '🧘‍♂️',
                    targetType: 'duration',
                    targetValue: 15,
                    frequency: 'daily',
                    difficulty: 2,
                    description: 'Find inner peace and reduce stress',
                  ),
                ],
              ),
              _buildCategorySection(
                context,
                ref,
                'Personal Growth',
                '🌱',
                'Invest in your personal development',
                [
                  _RecommendedHabit(
                    title: 'Read Books',
                    icon: '📚',
                    targetType: 'duration',
                    targetValue: 30,
                    frequency: 'daily',
                    difficulty: 3,
                    description: 'Expand your knowledge daily',
                  ),
                  _RecommendedHabit(
                    title: 'Learn New Skill',
                    icon: '💡',
                    targetType: 'duration',
                    targetValue: 45,
                    frequency: 'daily',
                    difficulty: 4,
                    description: 'Challenge yourself with new abilities',
                  ),
                  _RecommendedHabit(
                    title: 'Journal',
                    icon: '✍️',
                    targetType: 'duration',
                    targetValue: 15,
                    frequency: 'daily',
                    difficulty: 2,
                    description: 'Reflect on your thoughts and growth',
                  ),
                ],
              ),
              _buildCategorySection(
                context,
                ref,
                'Productivity',
                '⚡',
                'Maximize your daily efficiency',
                [
                  _RecommendedHabit(
                    title: 'Morning Routine',
                    icon: '🌅',
                    targetType: 'duration',
                    targetValue: 60,
                    frequency: 'daily',
                    difficulty: 4,
                    description: 'Start your day with purpose',
                  ),
                  _RecommendedHabit(
                    title: 'No Social Media',
                    icon: '📵',
                    targetType: 'duration',
                    targetValue: 120,
                    frequency: 'daily',
                    difficulty: 4,
                    description: 'Focus on what truly matters',
                  ),
                  _RecommendedHabit(
                    title: 'Deep Work',
                    icon: '💻',
                    targetType: 'duration',
                    targetValue: 90,
                    frequency: 'daily',
                    difficulty: 5,
                    description: 'Achieve flow state in your work',
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    WidgetRef ref,
    String title,
    String emoji,
    String subtitle,
    List<_RecommendedHabit> habits,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 16),
          ...habits.map((habit) => _buildHabitCard(context, ref, habit)),
        ],
      ),
    );
  }

  Widget _buildHabitCard(
    BuildContext context,
    WidgetRef ref,
    _RecommendedHabit habit,
  ) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? AppSecondaryColors.gluonGrey.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _addHabit(context, ref, habit),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppSecondaryColors.liquidLava.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        habit.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            habit.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            habit.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.add_circle_outline,
                      color: AppSecondaryColors.liquidLava,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      context,
                      Icons.timer_outlined,
                      '${habit.targetValue}${habit.targetType == 'duration' ? ' min' : ' times'}',
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      context,
                      Icons.calendar_today_outlined,
                      habit.frequency,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      context,
                      Icons.trending_up_outlined,
                      _getDifficultyText(habit.difficulty),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppSecondaryColors.liquidLava.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppSecondaryColors.liquidLava,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppSecondaryColors.liquidLava,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Very Easy';
      case 2:
        return 'Easy';
      case 3:
        return 'Medium';
      case 4:
        return 'Hard';
      case 5:
        return 'Very Hard';
      default:
        return 'Medium';
    }
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
      createdAt: DateTime.now(),
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
  final String description;

  const _RecommendedHabit({
    required this.title,
    required this.icon,
    required this.targetType,
    required this.targetValue,
    required this.frequency,
    required this.difficulty,
    required this.description,
  });
}
