import 'dart:async';
import 'dart:math';

import 'package:fitness/core/color/AppColors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartProgress extends StatefulWidget {
  const BarChartProgress({super.key});

  static const List<Color> availableColors = [
    AppColor.colorBlue,
    AppColor.colorPurple,
    Colors.green,
    Colors.orange,
  ];

  static const Color barBackgroundColor = Color(0x33666666);
  static const Color touchedBarColor = Color(0xCC3F51B5);

  @override
  State<BarChartProgress> createState() => _BarChartProgressState();
}

class _BarChartProgressState extends State<BarChartProgress> {
  final Duration animDuration = const Duration(milliseconds: 400);
  int touchedIndex = -1;
  bool isPlaying = false;
  Timer? _timer;
  List<double> weeklyData = [20, 6.5, 5, 7.5, 9, 11.5, 6.5];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Expanded(
                // Use RepaintBoundary to optimize rendering performance
                child: RepaintBoundary(
                  child: BarChart(
                    isPlaying ? randomData() : mainBarData(),
                    duration: animDuration,
                    curve: Curves.easeInOutCubic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color? barColor,
        double width = 20,
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 0.5 : y,
          color: isTouched ? BarChartProgress.touchedBarColor : barColor ?? AppColor.colorPurple,
          width: width,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: BarChartProgress.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: isTouched ? [0] : [],
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
    return makeGroupData(
      i,
      weeklyData[i],
      isTouched: i == touchedIndex,
      barColor: BarChartProgress.availableColors[i % BarChartProgress.availableColors.length],
    );
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(

          tooltipPadding: const EdgeInsets.all(8),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              '${_getWeekDay(group.x)}\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: '${rod.toY.toStringAsFixed(1)} kcal',
                  style: TextStyle(
                    color: BarChartProgress.touchedBarColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: _getTitles,
            reservedSize: 42,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 5,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      barGroups: showingGroups(),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 5,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withValues(alpha: 0.2),
            strokeWidth: 1,
          );
        },
      ),
      maxY: 20,
    );
  }

  // Memoize the random data to avoid unnecessary recalculations
  late final BarChartData _cachedRandomData = _generateRandomData();
  
  BarChartData _generateRandomData() {
    return BarChartData(
      barTouchData: const BarTouchData(enabled: false),
      titlesData: mainBarData().titlesData,
      borderData: FlBorderData(show: false),
      barGroups: List.generate(7, (i) {
        final randomValue = Random().nextInt(15).toDouble() + 6;
        weeklyData[i] = randomValue;
        return makeGroupData(
          i,
          randomValue,
          barColor: BarChartProgress.availableColors[i % BarChartProgress.availableColors.length],
        );
      }),
      gridData: mainBarData().gridData,
      maxY: 20,
    );
  }
  
  BarChartData randomData() {
    return _cachedRandomData;
  }

  // FIXED: The getTitlesWidget callback should return the widget directly.
  // The SideTitleWidget wrapper is no longer needed for this use case
  // in recent versions of fl_chart.
  Widget _getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: AppColor.colorBlue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    final text = Text(_getWeekDay(value.toInt()), style: style);

    return text;
  }

  String _getWeekDay(int index) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sa'];
    return days[index];
  }

}
