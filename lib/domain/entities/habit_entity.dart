class HabitEntity {
  final String id;
  final String title;
  final String iconPath;
  final String targetType; // 'duration' or 'quantity'
  final int targetValue;
  final String frequency;
  final List<int>? customDays;
  final DateTime? notificationTime;
  final int difficulty;
  final DateTime? lastCompletedAt;
  final int currentStreak;
  final int bestStreak;
  final List<DateTime> completions;

  const HabitEntity({
    required this.id,
    required this.title,
    required this.iconPath,
    required this.targetType,
    required this.targetValue,
    required this.frequency,
    this.customDays,
    this.notificationTime,
    required this.difficulty,
    this.lastCompletedAt,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.completions = const [],
  });

  HabitEntity copyWith({
    String? title,
    String? iconPath,
    String? targetType,
    int? targetValue,
    String? frequency,
    List<int>? customDays,
    DateTime? notificationTime,
    int? difficulty,
    DateTime? lastCompletedAt,
    int? currentStreak,
    int? bestStreak,
    List<DateTime>? completions,
  }) {
    return HabitEntity(
      id: id,
      title: title ?? this.title,
      iconPath: iconPath ?? this.iconPath,
      targetType: targetType ?? this.targetType,
      targetValue: targetValue ?? this.targetValue,
      frequency: frequency ?? this.frequency,
      customDays: customDays ?? this.customDays,
      notificationTime: notificationTime ?? this.notificationTime,
      difficulty: difficulty ?? this.difficulty,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      completions: completions ?? this.completions,
    );
  }
}
