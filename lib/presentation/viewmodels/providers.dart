import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:self_discipline_app/data/datasources/habit_local_data_source.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'package:self_discipline_app/data/repositories/habit_repository_impl.dart';
import 'package:self_discipline_app/domain/repositories/habit_repository.dart';
import 'package:self_discipline_app/domain/usecases/create_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/delete_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/get_habits_usecase.dart';
import 'package:self_discipline_app/domain/usecases/update_habit_usecase.dart';
import 'package:self_discipline_app/domain/entities/daily_streak_entity.dart';
import 'package:self_discipline_app/presentation/viewmodels/streak_notifier.dart';

// Hive Boxes
final habitBoxProvider = Provider<Box<HabitModel>>((ref) {
  throw UnimplementedError('habitBoxProvider not initialized');
});

final settingsProvider = StateProvider<Box>((ref) {
  throw UnimplementedError('settingsProvider not initialized');
});

// Data Sources
final habitLocalDataSourceProvider = Provider<HabitLocalDataSource>((ref) {
  final habitBox = ref.watch(habitBoxProvider);
  return HabitLocalDataSourceImpl(habitBox);
});

// Repositories
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final localDataSource = ref.watch(habitLocalDataSourceProvider);
  return HabitRepositoryImpl(localDataSource);
});

// Use Cases
final getHabitsUseCaseProvider = Provider<GetHabitsUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return GetHabitsUseCase(repository);
});

final createHabitUseCaseProvider = Provider<CreateHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return CreateHabitUseCase(repository);
});

final updateHabitUseCaseProvider = Provider<UpdateHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return UpdateHabitUseCase(repository);
});

final deleteHabitUseCaseProvider = Provider<DeleteHabitUseCase>((ref) {
  final repository = ref.watch(habitRepositoryProvider);
  return DeleteHabitUseCase(repository);
});

final streakProvider =
    StateNotifierProvider<StreakNotifier, List<DailyStreakEntity>>((ref) {
  return StreakNotifier();
});
