// lib/presentation/viewmodels/create_habit_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/domain/usecases/create_habit_usecase.dart';
import 'providers.dart';

final createHabitNotifierProvider =
    StateNotifierProvider<CreateHabitNotifier, AsyncValue<void>>((ref) {
  final createHabitUseCase = ref.watch(createHabitUseCaseProvider);
  return CreateHabitNotifier(createHabitUseCase);
});

class CreateHabitNotifier extends StateNotifier<AsyncValue<void>> {
  final CreateHabitUseCase createHabitUseCase;

  CreateHabitNotifier(this.createHabitUseCase)
      : super(const AsyncValue.data(null));

  Future<void> createHabit(HabitEntity habit) async {
    state = const AsyncValue.loading();
    try {
      await createHabitUseCase(habit);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
