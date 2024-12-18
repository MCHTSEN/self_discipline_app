import 'package:hive/hive.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';

abstract class HabitLocalDataSource {
  Future<void> createHabit(HabitModel habit);
  Future<List<HabitModel>> getHabits();
  Future<void> updateHabit(HabitModel habit);
  Future<void> deleteHabit(String habitId);
  Future<void> markHabitCompleted(String habitId, DateTime date);
  Future<List<DateTime>> getHabitCompletionDates(String habitId);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final Box<HabitModel> habitBox;
  final Box<List<DateTime>> completionBox;

  HabitLocalDataSourceImpl(this.habitBox, this.completionBox);

  @override
  Future<void> createHabit(HabitModel habit) async {
    await habitBox.put(habit.id, habit);
  }

  @override
  Future<List<HabitModel>> getHabits() async {
    return habitBox.values.toList();
  }

  @override
  Future<void> updateHabit(HabitModel habit) async {
    await habit.save();
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    await habitBox.delete(habitId);
  }

  @override
  Future<void> markHabitCompleted(String habitId, DateTime date) async {
    final completions = completionBox.get(habitId) ?? [];
    completions.add(date);
    await completionBox.put(habitId, completions);
  }

  @override
  Future<List<DateTime>> getHabitCompletionDates(String habitId) async {
    return completionBox.get(habitId) ?? [];
  }
}
