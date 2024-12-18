import 'package:self_discipline_app/domain/repositories/habit_repository.dart';

class GetHabitCompletionDatesUseCase {
  final HabitRepository repository;
  GetHabitCompletionDatesUseCase(this.repository);

  Future<List<DateTime>> call(String habitId) {
    return repository.getHabitCompletionDates(habitId);
  }
}

