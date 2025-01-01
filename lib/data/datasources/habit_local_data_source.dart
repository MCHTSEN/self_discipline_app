import 'package:hive/hive.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';

abstract class HabitLocalDataSource {
  Future<List<HabitEntity>> getHabits();
  Future<void> createHabit(HabitEntity habit);
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(String habitId);
}

class HabitLocalDataSourceImpl implements HabitLocalDataSource {
  final Box<HabitModel> habitBox;

  HabitLocalDataSourceImpl(this.habitBox);

  @override
  Future<List<HabitEntity>> getHabits() async {
    return habitBox.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> createHabit(HabitEntity habit) async {
    final habitModel = HabitModel.fromEntity(habit);
    await habitBox.put(habit.id, habitModel);
  }

  @override
  Future<void> updateHabit(HabitEntity habit) async {
    final habitModel = HabitModel.fromEntity(habit);
    await habitBox.put(habit.id, habitModel);
  }

  @override
  Future<void> deleteHabit(String habitId) async {
    await habitBox.delete(habitId);
  }
}
