import 'package:hive/hive.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class HabitModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String iconPath;

  @HiveField(3)
  final String targetType;

  @HiveField(4)
  final int targetValue;

  @HiveField(5)
  final String frequency;

  @HiveField(6)
  final List<int>? customDays;

  @HiveField(7)
  final DateTime? notificationTime;

  @HiveField(8)
  final int difficulty;

  @HiveField(9)
  final List<DateTime> completions;

  @HiveField(10)
  final int currentStreak;

  @HiveField(11)
  final int bestStreak;

  HabitModel({
    required this.id,
    required this.title,
    required this.iconPath,
    required this.targetType,
    required this.targetValue,
    required this.frequency,
    this.customDays,
    this.notificationTime,
    required this.difficulty,
    this.completions = const [],
    this.currentStreak = 0,
    this.bestStreak = 0,
  });

  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      title: entity.title,
      iconPath: entity.iconPath,
      targetType: entity.targetType,
      targetValue: entity.targetValue,
      frequency: entity.frequency,
      customDays: entity.customDays,
      notificationTime: entity.notificationTime,
      difficulty: entity.difficulty,
      completions: entity.completions,
      currentStreak: entity.currentStreak,
      bestStreak: entity.bestStreak,
    );
  }

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      title: title,
      iconPath: iconPath,
      targetType: targetType,
      targetValue: targetValue,
      frequency: frequency,
      customDays: customDays,
      notificationTime: notificationTime,
      difficulty: difficulty,
      completions: completions,
      currentStreak: currentStreak,
      bestStreak: bestStreak,
    );
  }
}
