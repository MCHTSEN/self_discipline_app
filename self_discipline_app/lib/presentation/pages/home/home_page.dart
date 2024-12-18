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

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final habitListState = ref.watch(habitListProvider);

    // Bu widget habitListState'in durumuna göre habitleri gösterir.
    Widget habitsSection = habitListState.when(
      data: (habits) {
        if (habits.isEmpty) {
          return const Text('No habits found. Add a new habit.');
        }
        // Habits çok olursa kaydırılabilir bir alan lazım
        return Expanded(
          child: ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final HabitEntity habit = habits[index];
              // HabitWidget'a uygun veriler sağlanır.
              // Eğer habit.iconPath emoji ise direkt verebilirsiniz.
              // durationInMinutes için targetDuration varsa kullanılır, yoksa 0 verilir.
              return Column(
                children: [
                  HabitWidget(
                    title: habit.title,
                    durationInMinutes: habit.targetDuration?.inMinutes ?? 0,
                    icon: _resolveIcon(habit.iconPath),
                  ),
                  Gap.low,
                ],
              );
            },
          ),
        );
      },
      loading: () =>
          const Expanded(child: Center(child: CircularProgressIndicator())),
      error: (err, stack) =>
          Expanded(child: Center(child: Text('Error: $err'))),
    );

    return BaseBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
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
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Gap.low,
                // Burada artık hard-coded HabitWidget'lar yerine dinamik liste geliyor
                habitsSection,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text _quote(BuildContext context) {
    return Text(
      '🚀 Small steps lead to big changes.',
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: AppColors.textSecondaryDark),
    );
  }

  Row _nameAndSettings(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text('Hello, Mucahit',
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.settings))
      ],
    );
  }

  String _resolveIcon(String iconPath) {
    // Eğer iconPath bir emoji ise direk geri dönebiliriz.
    // Eğer değilse bir placeholder emoji dönüyoruz.
    // Gerçek projede iconPath'e göre logic ekleyin.
    return iconPath.isNotEmpty ? iconPath : '🔥';
  }
}
