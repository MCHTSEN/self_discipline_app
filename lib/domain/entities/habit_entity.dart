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
  final List<DateTime> completions; // Tüm tamamlanma tarihlerini tutar
  final int currentStreak;
  final int bestStreak;
  final DateTime createdAt;

  bool get isCompletedToday {
    final now = DateTime.now();
    return completions.any((date) =>
        date.year == now.year &&
        date.month == now.month &&
        date.day == now.day);
  }

  DateTime? get lastCompletedAt =>
      completions.isNotEmpty ? completions.last : null;

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
    this.completions = const [],
    this.currentStreak = 0,
    this.bestStreak = 0,
    required this.createdAt, DateTime? lastCompletedAt,
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
    List<DateTime>? completions,
    int? currentStreak,
    int? bestStreak,
    DateTime? createdAt,
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
      completions: completions ?? this.completions,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      createdAt: createdAt?? this.createdAt,
    );
  }
}
