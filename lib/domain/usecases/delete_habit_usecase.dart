import 'package:self_discipline_app/domain/repositories/habit_repository.dart';

class DeleteHabitUseCase {
  final HabitRepository repository;
  DeleteHabitUseCase(this.repository);

  Future<void> call(String habitId) {
    return repository.deleteHabit(habitId);
  }
}