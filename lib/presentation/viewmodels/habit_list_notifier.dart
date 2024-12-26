import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';
import 'package:self_discipline_app/domain/usecases/get_habits_usecase.dart';
import 'package:self_discipline_app/domain/usecases/create_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/update_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/delete_habit_usecase.dart';
import 'package:self_discipline_app/presentation/viewmodels/streak_celebration_provider.dart';
import 'providers.dart';

final habitListProvider =
    StateNotifierProvider<HabitListNotifier, AsyncValue<List<HabitEntity>>>(
        (ref) {
  return HabitListNotifier(
    getHabits: ref.watch(getHabitsUseCaseProvider),
    createHabit: ref.watch(createHabitUseCaseProvider),
    updateHabit: ref.watch(updateHabitUseCaseProvider),
    deleteHabit: ref.watch(deleteHabitUseCaseProvider),
    habitBox: ref.watch(habitBoxProvider),
    streakCelebrationNotifier: ref.read(streakCelebrationProvider.notifier),
  );
});

class HabitListNotifier extends StateNotifier<AsyncValue<List<HabitEntity>>> {
  final GetHabitsUseCase getHabits;
  final CreateHabitUseCase createHabit;
  final UpdateHabitUseCase updateHabit;
  final DeleteHabitUseCase deleteHabit;
  final Box<HabitModel> habitBox;
  final StreakCelebrationNotifier streakCelebrationNotifier;

  HabitListNotifier({
    required this.getHabits,
    required this.createHabit,
    required this.updateHabit,
    required this.deleteHabit,
    required this.habitBox,
    required this.streakCelebrationNotifier,
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

  Future<void> completeHabit(String habitId) async {
    final currentState = state;
    if (!currentState.hasValue) return;

    final habits = currentState.value!;
    final habitIndex = habits.indexWhere((h) => h.id == habitId);
    if (habitIndex == -1) return;

    final habit = habits[habitIndex];
    final now = DateTime.now();

    // Streak hesaplama
    int newStreak = habit.currentStreak;
    if (habit.lastCompletedAt == null) {
      newStreak = 1;
    } else {
      final difference = now.difference(habit.lastCompletedAt!);
      if (habit.frequency == 'daily') {
        if (difference.inDays == 0) return; // Aynı gün tekrar tamamlanamaz
        if (difference.inDays == 1) {
          newStreak++;
        } else {
          newStreak = 1; // Streak kırıldı
        }
      } else if (habit.frequency == 'weekly') {
        if (difference.inDays < 7) return; // Haftalık hedef erken tamamlanamaz
        if (difference.inDays <= 14) {
          newStreak++;
        } else {
          newStreak = 1; // Streak kırıldı
        }
      }
    }

    final newBestStreak =
        newStreak > habit.bestStreak ? newStreak : habit.bestStreak;

    final updatedHabit = habit.copyWith(
      currentStreak: newStreak,
      bestStreak: newBestStreak,
      lastCompletedAt: now,
    );

    // Streak milestone kontrolü
    if (newStreak > 0 && newStreak % 7 == 0) {
      _showStreakCelebration(newStreak);
    }

    final updatedHabits = [...habits];
    updatedHabits[habitIndex] = updatedHabit;
    state = AsyncValue.data(updatedHabits);

    // Hive'a kaydet
    final habitModel = HabitModel.fromEntity(updatedHabit);
    await habitBox.put(habitId, habitModel);
  }

  void _showStreakCelebration(int streak) {
    streakCelebrationNotifier.showCelebration(streak);
  }
}
