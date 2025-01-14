import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/presentation/viewmodels/performance_stats_notifier.dart';
import 'dart:math' as math;

/// Displays performance-related information with an icon and text
class PerformanceWidget extends ConsumerWidget {
  /// The type of performance metric to display
  final PerformanceMetricType type;

  /// Creates a performance widget that displays stats based on the metric type
  const PerformanceWidget({
    required this.type,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(performanceStatsProvider);
    final (text, icon) = _getMetricInfo(stats, type);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(86, 255, 83, 226),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(4),
              child: Icon(icon, color: Colors.black, size: 12.sp),
            ),
            Gap.extraLow,
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Colors.black, fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Gets the display text and icon based on the metric type and current stats
  (String, IconData) _getMetricInfo(
      PerformanceStats stats, PerformanceMetricType type) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1);
    final monthName = switch (lastMonth.month) {
      1 => "Ocak",
      2 => "Şubat",
      3 => "Mart",
      4 => "Nisan",
      5 => "Mayıs",
      6 => "Haziran",
      7 => "Temmuz",
      8 => "Ağustos",
      9 => "Eylül",
      10 => "Ekim",
      11 => "Kasım",
      12 => "Aralık",
      _ => "",
    };

    // Calculate year-end total growth
    final daysLeft = DateTime(now.year, 12, 31).difference(now).inDays + 1;
    final yearEndMultiplier = math.pow(1 + stats.compoundGrowthRate, daysLeft);

    return switch (type) {
      PerformanceMetricType.improvement => (
          '$monthName ayı başarı oranı: %${(stats.currentConsistency * 100).toStringAsFixed(0)}. Günlük %${(stats.compoundGrowthRate * 100).toStringAsFixed(1)} gelişimle yıl sonunda ${yearEndMultiplier.toStringAsFixed(1)}x büyüme!',
          Icons.rocket_launch_rounded,
        ),
      PerformanceMetricType.streak => (
          'Şu anki tutarlılık: %${(stats.currentConsistency * 100).toStringAsFixed(0)}, Hedef: ${stats.projectedStreak} gün',
          Icons.star,
        ),
    };
  }
}

/// Types of performance metrics that can be displayed
enum PerformanceMetricType {
  /// Shows potential improvement by year end
  improvement,

  /// Shows projected streak information
  streak,
}
