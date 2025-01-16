import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';
import 'package:self_discipline_app/presentation/viewmodels/performance_stats_notifier.dart';

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
              padding: ProjectPaddingType.xSmallPadding.allPadding,
              child: Icon(icon, color: Colors.black, size: 13),
            ),
            Gap.extraLow,
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
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
    return switch (type) {
      PerformanceMetricType.improvement => (
          'Günlük %${(stats.compoundGrowthRate * 100).toStringAsFixed(1)} gelişimle ${stats.daysLeft} günde ${stats.potentialGrowth.toStringAsFixed(1)}x büyüme!',
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
