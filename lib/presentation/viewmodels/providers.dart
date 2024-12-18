import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:self_discipline_app/data/datasources/habit_local_data_source.dart';
import 'package:self_discipline_app/data/models/habit_model.dart';
import 'package:self_discipline_app/data/repositories/habit_repository_impl.dart';
import 'package:self_discipline_app/domain/usecases/create_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/delete_habit_usecase.dart';
import 'package:self_discipline_app/domain/usecases/get_habits_usecase.dart';
import 'package:self_discipline_app/domain/usecases/update_habit_usecase.dart';

final habitBoxProvider = Provider<Box<HabitModel>>((ref) {
  throw UnimplementedError();
});

final completionBoxProvider = Provider<Box<List<DateTime>>>((ref) {
  throw UnimplementedError();
});

final habitLocalDataSourceProvider = Provider<HabitLocalDataSource>((ref) {
  final habitBox = ref.watch(habitBoxProvider);
  final completionBox = ref.watch(completionBoxProvider);
  return HabitLocalDataSourceImpl(habitBox, completionBox);
});

final habitRepositoryProvider = Provider((ref) {
  final localDS = ref.watch(habitLocalDataSourceProvider);
  return HabitRepositoryImpl(localDS);
});

final getHabitsUseCaseProvider = Provider((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  return GetHabitsUseCase(repo);
});

final createHabitUseCaseProvider = Provider((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  return CreateHabitUseCase(repo);
});

final updateHabitUseCaseProvider = Provider<UpdateHabitUseCase>((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  return UpdateHabitUseCase(repo);
});

final deleteHabitUseCaseProvider = Provider<DeleteHabitUseCase>((ref) {
  final repo = ref.watch(habitRepositoryProvider);
  return DeleteHabitUseCase(repo);
});