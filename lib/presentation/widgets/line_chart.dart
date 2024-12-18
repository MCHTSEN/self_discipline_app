import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class LineChartSample3 extends StatefulWidget {
  LineChartSample3({
    super.key,
    Color? lineColor,
    Color? indicatorLineColor,
    Color? indicatorTouchedLineColor,
    Color? indicatorSpotStrokeColor,
    Color? indicatorTouchedSpotStrokeColor,
    Color? bottomTextColor,
    Color? bottomTouchedTextColor,
    Color? averageLineColor,
    Color? tooltipBgColor,
    Color? tooltipTextColor,
  })  : lineColor = lineColor ?? ChartColors.contentColorBlue,
        indicatorLineColor = indicatorLineColor ??
            ChartColors.contentColorYellow.withOpacity(0.2),
        indicatorTouchedLineColor =
            indicatorTouchedLineColor ?? ChartColors.contentColorYellow,
        indicatorSpotStrokeColor = indicatorSpotStrokeColor ??
            ChartColors.contentColorYellow.withOpacity(0.5),
        indicatorTouchedSpotStrokeColor =
            indicatorTouchedSpotStrokeColor ?? ChartColors.contentColorYellow,
        bottomTextColor =
            bottomTextColor ?? ChartColors.contentColorYellow.withOpacity(0.2),
        bottomTouchedTextColor =
            bottomTouchedTextColor ?? ChartColors.contentColorYellow,
        averageLineColor =
            averageLineColor ?? ChartColors.contentColorGreen.withOpacity(0.8),
        tooltipBgColor = tooltipBgColor ?? ChartColors.contentColorGreen,
        tooltipTextColor = tooltipTextColor ?? Colors.black;

  final Color lineColor;
  final Color indicatorLineColor;
  final Color indicatorTouchedLineColor;
  final Color indicatorSpotStrokeColor;
  final Color indicatorTouchedSpotStrokeColor;
  final Color bottomTextColor;
  final Color bottomTouchedTextColor;
  final Color averageLineColor;
  final Color tooltipBgColor;
  final Color tooltipTextColor;

  @override
  State createState() => _LineChartSample3State();
}

class _LineChartSample3State extends State<LineChartSample3> {
  late double touchedValue;

  bool fitInsideBottomTitle = true;
  bool fitInsideLeftTitle = false;

  // Yeni Durum Değişkenleri
  String selectedTimeFrame = 'Year';

  // Farklı zaman dilimleri için veri setleri
  final Map<String, List<String>> timeFrameLabels = {
    'Week': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    'Month': List.generate(30, (index) => '${index + 1}'),
    'Year': [
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
    ],
  };

  final Map<String, List<double>> timeFrameValues = {
    'Week': [0.3, 0.6, 0.8, 0.5, 0.9, 0.7, 1.0],
    'Month': List.generate(30, (index) => (index % 10 + 1) / 10.0),
    'Year': [0.8, 0.7, 0.9, 1.0, 0.6, 0.8, 0.9, 1.1, 1.0, 0.9, 1.2, 1.3],
  };

  // Tahmin verisi için ayrı veri seti
  List<FlSpot> predictedYearSpots = [];

  @override
  void initState() {
    touchedValue = -1;
    super.initState();
    _generatePredictedData();
  }

  // Tahmin verisini oluşturma fonksiyonu
  void _generatePredictedData() {
    DateTime now = DateTime.now();
    if (selectedTimeFrame == 'Year') {
      int currentMonth = now.month; // 1 - 12
      if (currentMonth < 12) {
        // Önceki aylara bakarak kalan ayların verisini tahmin et
        List<double> yearValues = timeFrameValues['Year']!;
        double average = 0;
        for (int i = 0; i < currentMonth; i++) {
          average += yearValues[i];
        }
        average = average / currentMonth;
        // Kalan aylar için tahmin edilen değerler
        predictedYearSpots = [];
        for (int i = currentMonth; i < 12; i++) {
          double predictedValue =
              (average * 1.1).clamp(0.0, 1.5); // Örneğin, %110
          predictedYearSpots.add(FlSpot(i.toDouble(), predictedValue));
        }
      } else {
        predictedYearSpots = []; // Aralık ayındaysanız tahmin yok
      }
    }
  }

  // Dinamik haftalar, aylar ve yıllar için etiketler
  List<String> get currentLabels => timeFrameLabels[selectedTimeFrame] ?? [];

  List<double> get currentValues => timeFrameValues[selectedTimeFrame] ?? [];

  // Y ekseni için dinamik etiketler
  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value % 0.2 != 0) {
      return Container();
    }
    final style = TextStyle(
      color: ChartColors.mainTextColor1.withOpacity(0.5),
      fontSize: 10,
    );
    String text = '${(value * 100).toInt()}%';

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6,
      fitInside: fitInsideLeftTitle
          ? SideTitleFitInsideData.fromTitleMeta(meta)
          : SideTitleFitInsideData.disable(),
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }

  // X ekseni için dinamik etiketler
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final isTouched = value == touchedValue;
    final style = TextStyle(
      color: isTouched ? widget.bottomTouchedTextColor : widget.bottomTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    if (value < 0 || value.toInt() >= currentLabels.length) {
      return Container();
    }
    return SideTitleWidget(
      space: 4,
      axisSide: meta.axisSide,
      fitInside: fitInsideBottomTitle
          ? SideTitleFitInsideData.fromTitleMeta(meta, distanceFromEdge: 0)
          : SideTitleFitInsideData.disable(),
      child: Text(
        currentLabels[value.toInt()],
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Tahmin verisini güncelle
    _generatePredictedData();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Zaman Dilimi Seçimi
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: DropdownButton<String>(
            value: selectedTimeFrame,
            items: ['Week', 'Month', 'Year'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedTimeFrame = newValue!;
                touchedValue =
                    -1; // Seçim değiştiğinde dokunulan değeri sıfırla
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Average Line',
              style: TextStyle(
                color: widget.averageLineColor.withOpacity(1),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Text(
              ' and ',
              style: TextStyle(
                color: ChartColors.mainTextColor1,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'Indicators',
              style: TextStyle(
                color: widget.indicatorLineColor.withOpacity(1),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 18,
        ),
        AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 12),
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((spotIndex) {
                      final spot = barData.spots[spotIndex];
                      if (spot.x < 0 || spot.x >= currentValues.length) {
                        return null;
                      }
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: widget.indicatorTouchedLineColor,
                          strokeWidth: 4,
                        ),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 8,
                              color: Colors.white,
                              strokeWidth: 5,
                              strokeColor:
                                  widget.indicatorTouchedSpotStrokeColor,
                            );
                          },
                        ),
                      );
                    }).toList();
                  },
                  touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        if (flSpot.x < 0 || flSpot.x >= currentValues.length) {
                          return null;
                        }

                        TextAlign textAlign = TextAlign.center;

                        return LineTooltipItem(
                          '${currentLabels[flSpot.x.toInt()]}\n',
                          TextStyle(
                            color: widget.tooltipTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: '${(flSpot.y * 100).toInt()}%',
                              style: TextStyle(
                                color: widget.tooltipTextColor,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const TextSpan(
                              text: ' Progress',
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                          textAlign: textAlign,
                        );
                      }).toList();
                    },
                  ),
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? lineTouch) {
                    if (!event.isInterestedForInteractions ||
                        lineTouch == null ||
                        lineTouch.lineBarSpots == null) {
                      setState(() {
                        touchedValue = -1;
                      });
                      return;
                    }
                    final value = lineTouch.lineBarSpots![0].x;

                    if (value < 0 || value >= currentValues.length) {
                      setState(() {
                        touchedValue = -1;
                      });
                      return;
                    }

                    setState(() {
                      touchedValue = value;
                    });
                  },
                ),
                extraLinesData: ExtraLinesData(
                  horizontalLines: [
                    HorizontalLine(
                      y: currentValues.reduce((a, b) => a + b) /
                          currentValues.length,
                      color: widget.averageLineColor,
                      strokeWidth: 3,
                      dashArray: [20, 10],
                    ),
                  ],
                ),
                lineBarsData: _buildLineBarsData(),
                minY: 0,
                maxY: 1.5, // İlerleme %150'ye kadar olabilir
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: ChartColors.borderColor,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  checkToShowHorizontalLine: (value) => value % 0.2 == 0,
                  checkToShowVerticalLine: (value) => value % 1 == 0,
                  getDrawingHorizontalLine: (value) {
                    if (value == 0) {
                      return const FlLine(
                        color: ChartColors.contentColorOrange,
                        strokeWidth: 2,
                      );
                    } else {
                      return FlLine(
                        color: ChartColors.mainGridLineColor.withOpacity(0.5),
                        strokeWidth: 0.5,
                      );
                    }
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: ChartColors.mainGridLineColor.withOpacity(0.5),
                      strokeWidth: 0.5,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: leftTitleWidgets,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // İsteğe bağlı: Fit Inside Title Option Bölümü
        /*
        Column(
          children: [
            const Text('Fit Inside Title Option'),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Left Title'),
                Switch(
                  value: fitInsideLeftTitle,
                  onChanged: (value) => setState(() {
                    fitInsideLeftTitle = value;
                  }),
                ),
                const Text('Bottom Title'),
                Switch(
                  value: fitInsideBottomTitle,
                  onChanged: (value) => setState(() {
                    fitInsideBottomTitle = value;
                  }),
                )
              ],
            ),
          ],
        ),
        */
      ],
    );
  }

  // LineChartBarData oluşturma fonksiyonu
  List<LineChartBarData> _buildLineBarsData() {
    List<LineChartBarData> bars = [];

    // Gerçek veri çizgisi
    bars.add(
      LineChartBarData(
        isStepLineChart: true,
        spots: currentValues.asMap().entries.map((e) {
          return FlSpot(e.key.toDouble(), e.value);
        }).toList(),
        isCurved: false,
        barWidth: 4,
        color: widget.lineColor,
        belowBarData: BarAreaData(
          show: true,
          gradient: LinearGradient(
            colors: [
              widget.lineColor.withOpacity(0.5),
              widget.lineColor.withOpacity(0),
            ],
            stops: const [0.5, 1.0],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          spotsLine: BarAreaSpotsLine(
            show: true,
            flLineStyle: FlLine(
              color: widget.indicatorLineColor,
              strokeWidth: 2,
            ),
            checkToShowSpotLine: (spot) {
              return true;
            },
          ),
        ),
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) {
            return FlDotCirclePainter(
              radius: 6,
              color: Colors.white,
              strokeWidth: 3,
              strokeColor: widget.indicatorSpotStrokeColor,
            );
          },
          checkToShowDot: (spot, barData) {
            return true;
          },
        ),
      ),
    );

    // Tahmin veri çizgisi (sadece 'Year' zaman diliminde ve tahmin verisi mevcutsa)
    if (selectedTimeFrame == 'Year' && predictedYearSpots.isNotEmpty) {
      bars.add(
        LineChartBarData(
          isStepLineChart: true,
          spots: predictedYearSpots,
          isCurved: false,
          barWidth: 4,
          color: widget.lineColor.withOpacity(0.3), // Soluk renk
          belowBarData: BarAreaData(
            show: false,
          ),
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 6,
                color: Colors.white.withOpacity(0.5), // Soluk renk
                strokeWidth: 3,
                strokeColor: widget.indicatorSpotStrokeColor.withOpacity(0.5),
              );
            },
            checkToShowDot: (spot, barData) {
              return true;
            },
          ),
        ),
      );
    }

    return bars;
  }
}

class ChartColors {
  static const Color primary = contentColorCyan;
  static const Color menuBackground = Color(0xFF090912);
  static const Color itemsBackground = Color(0xFF1B2339);
  static const Color pageBackground = Color(0xFF282E45);
  static const Color mainTextColor1 = Colors.white;
  static const Color mainTextColor2 = Colors.white70;
  static const Color mainTextColor3 = Colors.white38;
  static const Color mainGridLineColor = Colors.white10;
  static const Color borderColor = Colors.white54;
  static const Color gridLinesColor = Color(0x11FFFFFF);

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
