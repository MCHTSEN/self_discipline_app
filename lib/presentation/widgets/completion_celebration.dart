import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:self_discipline_app/presentation/viewmodels/performance_stats_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

class CompletionCelebration extends ConsumerWidget {
  final VoidCallback onClose;

  const CompletionCelebration({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  final List<String> motivationalQuotes = const [
    "Every small win adds up to big success! 🌟",
    "You're building an unstoppable momentum! 🚀",
    "Consistency is your superpower! 💪",
    "Making progress every day! 🎯",
    "You're becoming unstoppable! 🔥",
  ];

  String getRandomQuote() {
    return motivationalQuotes[
        DateTime.now().millisecond % motivationalQuotes.length];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(performanceStatsProvider);
    final growth = stats.potentialGrowth;
    final consistency = stats.currentConsistency;

    return Stack(
      children: [
        Container(
          color: Colors.black87,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lotties/celebration.json',
                width: 200,
                height: 200,
                repeat: true,
              ),
              const SizedBox(height: 24),
              Text(
                'Amazing Work! 🎉',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                getRandomQuote(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 32),
              Container(
                height: 150,
                padding: const EdgeInsets.all(16),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: 30,
                    minY: 0,
                    maxY: math.max(growth, 2.0),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          const FlSpot(0, 1),
                          FlSpot(30, growth),
                        ],
                        isCurved: true,
                        color: Colors.greenAccent,
                        barWidth: 4,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.greenAccent.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Your consistency is ${(consistency * 100).toStringAsFixed(1)}% 🎯',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 32),
              TextButton(
                onPressed: onClose,
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
