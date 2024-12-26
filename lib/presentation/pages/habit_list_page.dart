import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/presentation/pages/habit_creation_page.dart';
import '../viewmodels/habit_list_notifier.dart';
import '../widgets/habit_card.dart';

@RoutePage()
class HabitListPage extends ConsumerWidget {
  const HabitListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitListState = ref.watch(habitListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Habits')),
      body: habitListState.when(
        data: (habits) {
          return ListView.builder(
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return HabitCard(habit: habit);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HabitCreationPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
