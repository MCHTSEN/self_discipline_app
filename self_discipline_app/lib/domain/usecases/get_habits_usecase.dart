import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/domain/repositories/habit_repository.dart';

class GetHabitsUseCase {
  final HabitRepository repository;
  GetHabitsUseCase(this.repository);

  Future<List<HabitEntity>> call() {
    return repository.getHabits();
  }
}