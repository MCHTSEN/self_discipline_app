import 'package:hive/hive.dart';
import 'package:self_discipline_app/domain/entities/habit_entity.dart';

part 'habit_model.g.dart';

@HiveType(typeId: 0)
class HabitModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String iconPath;
  @HiveField(3)
  int targetAmount;
  @HiveField(4)
  String frequency;
  @HiveField(5)
  int? targetDurationInMinutes;
  @HiveField(6)
  DateTime notificationTime;

  HabitModel({
    required this.id,
    required this.title,
    required this.iconPath,
    required this.targetAmount,
    required this.frequency,
    this.targetDurationInMinutes,
    required this.notificationTime,
  });

  HabitEntity toEntity() {
    return HabitEntity(
      id: id,
      title: title,
      iconPath: iconPath,
      targetAmount: targetAmount,
      frequency: frequency,
      targetDuration: targetDurationInMinutes != null
          ? Duration(minutes: targetDurationInMinutes!)
          : null,
      notificationTime: notificationTime,
    );
  }

  factory HabitModel.fromEntity(HabitEntity entity) {
    return HabitModel(
      id: entity.id,
      title: entity.title,
      iconPath: entity.iconPath,
      targetAmount: entity.targetAmount,
      frequency: entity.frequency,
      targetDurationInMinutes:
          entity.targetDuration != null ? entity.targetDuration!.inMinutes : null,
      notificationTime: entity.notificationTime,
    );
  }
}