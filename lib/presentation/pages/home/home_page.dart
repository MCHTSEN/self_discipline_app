import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/presentation/pages/habit_creation_page.dart';
import 'package:self_discipline_app/presentation/pages/home/components/weekly_streak_widget.dart';
import 'package:self_discipline_app/presentation/widgets/base_background.dart';
import 'package:self_discipline_app/presentation/widgets/habit_widget.dart';
import 'package:self_discipline_app/presentation/widgets/line_chart.dart';
import 'package:self_discipline_app/presentation/viewmodels/habit_list_notifier.dart';
import 'package:self_discipline_app/presentation/widgets/predict_line_chart.dart';
import '../../../domain/entities/habit_entity.dart';
import 'package:self_discipline_app/presentation/widgets/streak_celebration.dart';
import 'package:flutter/foundation.dart';
import 'package:self_discipline_app/presentation/viewmodels/providers.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final habitListState = ref.watch(habitListProvider);
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDarkMode ? AppSecondaryColors.snow : AppSecondaryColors.darkVoid;

    Widget habitsSection = habitListState.when(
      data: (habits) {
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
            slivers: [
              // Uncompleted Habits
              if (uncompletedHabits.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'To Complete',
                      style: TextStyle(
                        color: AppSecondaryColors.dustyGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = uncompletedHabits[index];
                      return HabitWidget(
                        habit: habit,
                        onComplete: () {
                          ref
                              .read(habitListProvider.notifier)
                              .completeHabit(habit.id);
                        },
                        isCompleted: false,
                      );
                    },
                    childCount: uncompletedHabits.length,
                  ),
                ),
              ],

              // Completed Habits
              if (completedHabits.isNotEmpty) ...[
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Completed Today',
                      style: TextStyle(
                        color: AppSecondaryColors.dustyGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final habit = completedHabits[index];
                      return HabitWidget(
                        habit: habit,
                        onComplete: () {},
                        isCompleted: true,
                      );
                    },
                    childCount: completedHabits.length,
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Expanded(
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Expanded(
        child: Center(child: Text('Error: $err')),
      ),
    );

    return Stack(
      children: [
        Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppSecondaryColors.liquidLava,
            foregroundColor: AppSecondaryColors.snow,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HabitCreationPage()),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: SafeArea(
            child: Padding(
              padding:
                  ProjectPaddingType.defaultPadding.symmetricHorizontalPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _nameAndSettings(context),
                  _quote(context),
                  Gap.normal,
                  const DailyStreakWidget(),
                  Gap.normal,
                  // Örneğin bir grafik gösterimi
                  const LineChartSample5(),
                  Text(
                    'Today\'s Tasks',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: textColor,
                        ),
                  ),
                  Gap.low,
                  // Burada artık hard-coded HabitWidget'lar yerine dinamik liste geliyor
                  habitsSection,
                ],
              ),
            ),
          ),
        ),
        const StreakCelebration(),
      ],
    );
  }

  Text _quote(BuildContext context) {
    return Text(
      '🚀 Small steps lead to big changes.',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: AppSecondaryColors.darkVoid),
    );
  }

  Row _nameAndSettings(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Hello, Mucahit',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        // Debug mode'da görünecek cache temizleme butonu
        if (kDebugMode)
          IconButton(
            onPressed: () async {
              final habitBox = ref.read(habitBoxProvider);
              final completionBox = ref.read(completionBoxProvider);

              await habitBox.clear();
              await completionBox.clear();

              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache cleared'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            },
            icon: const Icon(Icons.cleaning_services),
            tooltip: 'Clear Cache (Debug)',
          ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  String _resolveIcon(String iconPath) {
    return iconPath.isNotEmpty ? iconPath : '🔥';
  }
}
