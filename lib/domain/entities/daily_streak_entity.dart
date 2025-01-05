class DailyStreakEntity {
  final DateTime date;
  final bool isCompleted;

  const DailyStreakEntity({
    required this.date,
    required this.isCompleted,
  });

  DailyStreakEntity copyWith({
    DateTime? date,
    bool? isCompleted,
  }) {
    return DailyStreakEntity(
      date: date ?? this.date,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyStreakEntity &&
        other.date.year == date.year &&
        other.date.month == date.month &&
        other.date.day == date.day &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => date.hashCode ^ isCompleted.hashCode;
}
