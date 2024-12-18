import 'package:self_discipline_app/data/datasources/habit_local_data_source.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/domain/repositories/habit_repository.dart';

class HabitRepositoryImpl implements HabitRepository {
  final HabitLocalDataSource localDataSource;

  HabitRepositoryImpl(this.localDataSource);

  @override
  Future<void> createHabit(HabitEntity habit) {
    final model = HabitModel.fromEntity(habit);
    return localDataSource.createHabit(model);
  }

  @override
  Future<List<HabitEntity>> getHabits() async {
    final models = await localDataSource.getHabits();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> updateHabit(HabitEntity habit) {
    final model = HabitModel.fromEntity(habit);
    return localDataSource.updateHabit(model);
  }

  @override
  Future<void> deleteHabit(String habitId) {
    return localDataSource.deleteHabit(habitId);
  }

  @override
  Future<void> markHabitCompleted(String habitId, DateTime date) {
    return localDataSource.markHabitCompleted(habitId, date);
  }

  @override
  Future<List<DateTime>> getHabitCompletionDates(String habitId) {
    return localDataSource.getHabitCompletionDates(habitId);
  }
}
