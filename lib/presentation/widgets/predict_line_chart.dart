import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:self_discipline_app/presentation/viewmodels/performance_stats_notifier.dart';
import 'dart:math' as math;

class LineChartSample5 extends ConsumerStatefulWidget {
  LineChartSample5({
    super.key,
    Color? pastDataColor,
    Color? predictedDataColor,
    Color? indicatorStrokeColor,
  })  : pastDataColor =
            pastDataColor ?? Color.fromARGB(255, 212, 73, 172), // Mavi
        predictedDataColor =
            predictedDataColor ?? Color.fromARGB(255, 249, 224, 80), // Yeşil
        indicatorStrokeColor = indicatorStrokeColor ?? Colors.pink;

  final Color pastDataColor;
  final Color predictedDataColor;
  final Color indicatorStrokeColor;

  @override
  ConsumerState<LineChartSample5> createState() => _LineChartSample5State();
}

class _LineChartSample5State extends ConsumerState<LineChartSample5> {
  List<FlSpot> getSpots(PerformanceStats stats) {
    final now = DateTime.now();
    final currentDay = now.day;
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    List<FlSpot> spots = [];

    // Geçmiş günler için gerçek veriler (0-currentDay)
    double pastProgress =
        (stats.currentConsistency * currentDay / daysInMonth) * 34;
    for (int day = 0; day <= currentDay; day++) {
      double progress = (stats.currentConsistency * day / daysInMonth) * 34;
      spots.add(FlSpot(day.toDouble(), progress));
    }

    // Gelecek günler için tahmin (currentDay-daysInMonth)
    if (currentDay < daysInMonth) {
      double targetValue = 34.0; // Hedef %34
      double remainingDays = daysInMonth - currentDay.toDouble();
      double dailyIncrease = (targetValue - pastProgress) / remainingDays;

      for (int day = currentDay + 1; day <= daysInMonth; day++) {
        pastProgress += dailyIncrease;
        spots.add(FlSpot(day.toDouble(), pastProgress));
      }
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(performanceStatsProvider);
    final spots = getSpots(stats);
    final now = DateTime.now();
    final currentDay = now.day;
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return AspectRatio(
      aspectRatio: 1.8,
      child: Padding(
        padding: const EdgeInsets.only(right: 8, left: 4),
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              touchTooltipData: LineTouchTooltipData(
                tooltipMargin: 8,
                tooltipRoundedRadius: 8,
                getTooltipItems: (List<LineBarSpot> touchedSpots) {
                  return touchedSpots.map((spot) {
                    final isFuture = spot.x > currentDay;
                    return LineTooltipItem(
                      '${spot.x.toInt()}. Gün\n%${spot.y.toStringAsFixed(1)}',
                      TextStyle(
                        color: isFuture
                            ? widget.predictedDataColor
                            : widget.pastDataColor,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }).toList();
                },
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              horizontalInterval: 10,
              verticalInterval: 5,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: const Color(0xff37434d).withOpacity(0.1),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: const Color(0xff37434d).withOpacity(0.1),
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 17,
                  interval: currentDay.toDouble(),
                  getTitlesWidget: (value, meta) {
                    const style =
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 8);
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(value.toInt().toString(), style: style),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 10,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: Text(
                        '%${value.toInt()}',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border:
                  Border.all(color: const Color(0xff37434d).withOpacity(0.1)),
            ),
            minX: 0,
            maxX: daysInMonth.toDouble(),
            minY: 0,
            maxY: 40,
            lineBarsData: [
              // Geçmiş veriler
              LineChartBarData(
                spots: spots.sublist(0, currentDay + 1),
                isCurved: true,
                color: widget.pastDataColor,
                barWidth: 3,
                isStrokeCapRound: true,
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 3,
                    color: widget.pastDataColor,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  ),
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: widget.pastDataColor.withOpacity(0.15),
                ),
              ),
              // Tahmin verileri
              if (currentDay < daysInMonth)
                LineChartBarData(
                  spots: spots.sublist(currentDay),
                  isCurved: true,
                  color: widget.predictedDataColor,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 3,
                      color: widget.predictedDataColor,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: widget.predictedDataColor.withOpacity(0.15),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
