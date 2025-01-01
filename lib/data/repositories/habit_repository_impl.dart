import 'package:self_discipline_app/data/datasources/habit_local_data_source.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl(this.localDataSource);

  @override
  Future<void> createHabit(HabitEntity habit) async {
    await localDataSource.createHabit(habit);
  }

  @override
  Future<List<HabitEntity>> getHabits() async {
    return await localDataSource.getHabits();
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    await localDataSource.updateHabit(habit);
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    await localDataSource.deleteHabit(habitId);
  }

  @override
  Future<void> markHabitCompleted(String habitId, DateTime date) async {
    final habits = await getHabits();
    final habit = habits.firstWhere((h) => h.id == habitId);

    final updatedHabit = habit.copyWith(
      completions: [...habit.completions, date],
    );

    await updateHabit(updatedHabit);
  }

  @override
  Future<List<DateTime>> getHabitCompletionDates(String habitId) async {
    final habits = await getHabits();
    final habit = habits.firstWhere((h) => h.id == habitId);
    return habit.completions;
  }
}
