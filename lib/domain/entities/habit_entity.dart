class HabitEntity {
  final String id;
  final String title;
  final String iconPath;
  final int targetAmount;
  final String frequency;
  final Duration? targetDuration;
  final DateTime notificationTime;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastCompletedAt;

  const HabitEntity({
    required this.id,
    required this.title,
    required this.iconPath,
    required this.targetAmount,
    required this.frequency,
    this.targetDuration,
    required this.notificationTime,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastCompletedAt,
  });

  HabitEntity copyWith({
    String? id,
    String? title,
    String? iconPath,
    int? targetAmount,
    String? frequency,
    Duration? targetDuration,
    DateTime? notificationTime,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastCompletedAt,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      iconPath: iconPath ?? this.iconPath,
      targetAmount: targetAmount ?? this.targetAmount,
      frequency: frequency ?? this.frequency,
      targetDuration: targetDuration ?? this.targetDuration,
      notificationTime: notificationTime ?? this.notificationTime,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
    );
  }
}
