import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/domain/repositories/habit_repository.dart';

class CreateHabitUseCase {
  final HabitRepository repository;
  CreateHabitUseCase(this.repository);

  Future<void> call(HabitEntity habit) {
    // Gerekirse validation
    return repository.createHabit(habit);
  }
}


