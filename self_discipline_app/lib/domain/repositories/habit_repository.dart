
import 'package:self_discipline_app/domain/entities/habit_entity.dart';

abstract class HabitRepository {
  Future<void> createHabit(HabitEntity habit);
  Future<List<HabitEntity>> getHabits();
  Future<void> updateHabit(HabitEntity habit);
  Future<void> deleteHabit(String habitId);
  Future<void> markHabitCompleted(String habitId, DateTime date);
  Future<List<DateTime>> getHabitCompletionDates(String habitId);

}







