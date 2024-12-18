import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/domain/usecases/get_habits_usecase.dart';
import 'package:self_discipline_app/domain/usecases/create_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/update_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/delete_habit_usecase.dart';
import 'providers.dart';

final habitListProvider = StateNotifierProvider<HabitListNotifier, AsyncValue<List<HabitEntity>>>((ref) {
  final getHabitsUseCase = ref.watch(getHabitsUseCaseProvider);
  final createHabitUseCase = ref.watch(createHabitUseCaseProvider);
  final updateHabitUseCase = ref.watch(updateHabitUseCaseProvider);
  final deleteHabitUseCase = ref.watch(deleteHabitUseCaseProvider);
  
  return HabitListNotifier(
    getHabits: getHabitsUseCase,
    createHabit: createHabitUseCase,
    updateHabit: updateHabitUseCase,
    deleteHabit: deleteHabitUseCase,
  );
});

class HabitListNotifier extends StateNotifier<AsyncValue<List<HabitEntity>>> {
  final GetHabitsUseCase getHabits;
  final CreateHabitUseCase createHabit;
  final UpdateHabitUseCase updateHabit;
  final DeleteHabitUseCase deleteHabit;

  HabitListNotifier({
    required this.getHabits,
    required this.createHabit,
    required this.updateHabit,
    required this.deleteHabit,
  }) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final habits = await getHabits();
      // State’i bir kereye mahsus dolduruyoruz.
      state = AsyncValue.data(habits);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addHabit(HabitEntity newHabit) async {
    try {
      // Önce veritabanına kaydet
      await createHabit(newHabit);

      // Mevcut state değerini al, yeni habit’i ekle.
      final currentList = state.value ?? [];
      final updatedList = [...currentList, newHabit];

      // State’i güncelle
      state = AsyncValue.data(updatedList);
    } catch (e, st) {
      // Hata olursa state’i bozmadan sadece error verebilirsiniz ya da handle edebilirsiniz.
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> modifyHabit(HabitEntity updatedHabit) async {
    try {
      await updateHabit(updatedHabit);

      final currentList = state.value ?? [];
      // updatedHabit’in id’sine göre bulup değiştir
      final index = currentList.indexWhere((h) => h.id == updatedHabit.id);
      if (index >= 0) {
        final updatedList = List<HabitEntity>.from(currentList);
        updatedList[index] = updatedHabit;
        state = AsyncValue.data(updatedList);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> removeHabit(String habitId) async {
    try {
      await deleteHabit(habitId);

      final currentList = state.value ?? [];
      final updatedList = currentList.where((h) => h.id != habitId).toList();

      state = AsyncValue.data(updatedList);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}