
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/domain/repositories/habit_repository.dart';

class UpdateHabitUseCase {
  final HabitRepository repository;
  UpdateHabitUseCase(this.repository);

  Future<void> call(HabitEntity habit) {
    return repository.updateHabit(habit);
  }
}