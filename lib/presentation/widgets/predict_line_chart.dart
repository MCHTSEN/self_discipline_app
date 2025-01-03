import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:self_discipline_app/core/theme/app_colors.dart';
import 'package:self_discipline_app/presentation/widgets/line_chart.dart';

class LineChartSample5 extends StatefulWidget {
  LineChartSample5({
    super.key,
    Color? gradientColor1,
    Color? gradientColor2,
    Color? indicatorStrokeColor,
  })  : gradientColor1 = gradientColor1 ?? Color.fromARGB(255, 79, 101, 117),
        gradientColor2 = gradientColor2 ?? Color.fromARGB(255, 151, 214, 223),
        indicatorStrokeColor =
            indicatorStrokeColor ?? ChartColors.mainTextColor1;

  final Color gradientColor1;
  final Color gradientColor2;
  final Color indicatorStrokeColor;

  @override
  State<LineChartSample5> createState() => _LineChartSample5State();
}

class _LineChartSample5State extends State<LineChartSample5> {
  List<FlSpot> get allSpots => const [
        FlSpot(0, 1),
        FlSpot(1, 2),
        FlSpot(2, 3),
        FlSpot(3, 3),
        FlSpot(4, 3.5),
        FlSpot(5, 5),
        FlSpot(6, 8),
        FlSpot(7, 4),
        FlSpot(8, 5),
        FlSpot(9, 6),
        FlSpot(10, 7),
        FlSpot(11, 9),
      ];

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final currentMonth = DateTime.now().month - 1; // 0-based index for months
    final style = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.black,
      fontFamily: 'Digital',
      fontSize: 18 * chartWidth / 500,
    );

    final monthIndex = value.toInt();

    // Only show text for January (0), December (11), and current month
    if (monthIndex == 0) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text('Jan', style: style),
      );
    } else if (monthIndex == currentMonth) {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(months[currentMonth], style: style),
      );
    } else if (monthIndex == 11) {
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text('Dec', style: style),
      );
    }

    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // final currentMonth = DateTime.now().month - 1; // 0-based index for months
    final currentMonth = 2; // 0-based index for months
    final stopAtCurrentMonth = currentMonth / 11; // Convert to 0-1 range
    final transitionStop =
        stopAtCurrentMonth + 0.1; // Slightly after current month

    final lineBarsData = [
      LineChartBarData(
        spots: allSpots,
        isCurved: true,
        barWidth: 1,
        shadow: const Shadow(
          blurRadius: 1,
        ),
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.gradientColor1.withOpacity(0.1),
              widget.gradientColor1.withOpacity(0.1),
              widget.gradientColor2.withOpacity(0.3),
              widget.gradientColor2.withOpacity(0.3),
            ],
            stops: [
              0.0,
              stopAtCurrentMonth,
              transitionStop,
              1.0,
            ],
          ),
        ),
        dotData: const FlDotData(show: false),
        gradient: LinearGradient(
          colors: [
            widget.gradientColor1,
            widget.gradientColor1,
            widget.gradientColor2,
            widget.gradientColor2,
          ],
          stops: [
            0.0,
            stopAtCurrentMonth,
            transitionStop,
            1.0,
          ],
        ),
      ),
    ];

    return AspectRatio(
      aspectRatio: 2.8,
      child: LayoutBuilder(builder: (context, constraints) {
        return LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              enabled: true,
              handleBuiltInTouches: false,
              mouseCursorResolver:
                  (FlTouchEvent event, LineTouchResponse? response) {
                if (response == null || response.lineBarSpots == null) {
                  return SystemMouseCursors.basic;
                }
                return SystemMouseCursors.click;
              },
              getTouchedSpotIndicator:
                  (LineChartBarData barData, List<int> spotIndexes) {
                return spotIndexes.map((index) {
                  return TouchedSpotIndicatorData(
                    const FlLine(
                      color: Colors.pink,
                    ),
                    FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(
                        radius: 8,
                        color: lerpGradient(
                          barData.gradient!.colors,
                          barData.gradient!.stops!,
                          percent / 100,
                        ),
                        strokeWidth: 2,
                        strokeColor: widget.indicatorStrokeColor,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
            lineBarsData: lineBarsData,
            minY: 0,
            titlesData: FlTitlesData(
              leftTitles: const AxisTitles(
                axisNameSize: 24,
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 0,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    return bottomTitleWidgets(
                      value,
                      meta,
                      constraints.maxWidth,
                    );
                  },
                  reservedSize: 0,
                ),
              ),
              rightTitles: const AxisTitles(
                axisNameWidget: Text(''),
                sideTitles: SideTitles(
                  
                  showTitles: false,
                  reservedSize: 0,
                ),
                axisNameSize: 0,
              ),
              topTitles: const AxisTitles(
                axisNameWidget: Text(
                  '',
                  textAlign: TextAlign.left,
                ),
                axisNameSize: 0,
                sideTitles: SideTitles(
                  showTitles: false,
                  reservedSize: 0,
                ),
              ),
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
          ),
        );
      }),
    );
  }
}

/// Lerps between a [LinearGradient] colors, based on [t]
Color lerpGradient(List<Color> colors, List<double> stops, double t) {
  if (colors.isEmpty) {
    throw ArgumentError('"colors" is empty.');
  } else if (colors.length == 1) {
    return colors[0];
  }

  if (stops.length != colors.length) {
    stops = [];

    /// provided gradientColorStops is invalid and we calculate it here
    colors.asMap().forEach((index, color) {
      final percent = 1.0 / (colors.length - 1);
      stops.add(percent * index);
    });
  }

  for (var s = 0; s < stops.length - 1; s++) {
    final leftStop = stops[s];
    final rightStop = stops[s + 1];
    final leftColor = colors[s];
    final rightColor = colors[s + 1];
    if (t <= leftStop) {
      return leftColor;
    } else if (t < rightStop) {
      final sectionT = (t - leftStop) / (rightStop - leftStop);
      return Color.lerp(leftColor, rightColor, sectionT)!;
    }
  }
  return colors.last;
}
