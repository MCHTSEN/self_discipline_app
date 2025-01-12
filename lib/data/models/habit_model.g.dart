// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitModelAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = 0;

  @override
  HabitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitModel(
      createdAt: fields[12] as DateTime,
      id: fields[0] as String,
      title: fields[1] as String,
      iconPath: fields[2] as String,
      targetType: fields[3] as String,
      targetValue: fields[4] as int,
      frequency: fields[5] as String,
      customDays: (fields[6] as List?)?.cast<int>(),
      notificationTime: fields[7] as DateTime?,
      difficulty: fields[8] as int,
      completions: (fields[9] as List).cast<DateTime>(),
      currentStreak: fields[10] as int,
      bestStreak: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.iconPath)
      ..writeByte(3)
      ..write(obj.targetType)
      ..writeByte(4)
      ..write(obj.targetValue)
      ..writeByte(5)
      ..write(obj.frequency)
      ..writeByte(6)
      ..write(obj.customDays)
      ..writeByte(7)
      ..write(obj.notificationTime)
      ..writeByte(8)
      ..write(obj.difficulty)
      ..writeByte(9)
      ..write(obj.completions)
      ..writeByte(10)
      ..write(obj.currentStreak)
      ..writeByte(11)
      ..write(obj.bestStreak)
      ..writeByte(12)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
