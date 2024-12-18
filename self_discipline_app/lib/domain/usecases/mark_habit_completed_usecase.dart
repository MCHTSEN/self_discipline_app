import 'package:self_discipline_app/domain/repositories/habit_repository.dart';

class MarkHabitCompletedUseCase {
  final HabitRepository repository;
  MarkHabitCompletedUseCase(this.repository);

  Future<void> call(String habitId, DateTime date) {
    return repository.markHabitCompleted(habitId, date);
  }
}
