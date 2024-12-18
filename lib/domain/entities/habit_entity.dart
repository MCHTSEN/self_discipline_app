class HabitEntity {
  final String id;
  final String title;
  final String iconPath;
  final int targetAmount;
  final String frequency; // daily, weekly vs.
  final Duration? targetDuration;
  final DateTime notificationTime;

  HabitEntity({
    required this.id,
    required this.title,
    required this.iconPath,
    required this.targetAmount,
    required this.frequency,
    this.targetDuration,
    required this.notificationTime,
  });
}