import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';



class ActivityStatusWidget extends StatefulWidget {
  const ActivityStatusWidget({
    super.key,
    required this.size,
    required this.heartRateData,
  });

  final Size size;
  final List<FlSpot> heartRateData;

  @override
  State<ActivityStatusWidget> createState() => _ActivityStatusWidgetState();
}

class _ActivityStatusWidgetState extends State<ActivityStatusWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 200,
      width: widget.size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Heart Rate',
                style: theme.textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '78 BPM',
                style: theme.textTheme.titleMedium!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primaryContainer,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart
          Expanded(
            child: LineChart(
              _buildLineChartData(theme),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _buildLineChartData(ThemeData theme) {
    return LineChartData(
      // Grid lines for better readability
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[200],
            strokeWidth: 1,
          );
        },
      ),
      // Border configuration
      borderData: FlBorderData(
        show: false,
      ),
      // Titles for axes
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 2,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              );
            },
          ),
        ),
      ),
      // Line chart data
      lineBarsData: [
        LineChartBarData(
          spots: widget.heartRateData,
          isCurved: true,
          color: const Color(0xFF92A3FD),
          gradient: const LinearGradient(
            colors: [Color(0xFF92A3FD), Color(0xFF9DCEFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          barWidth: 3,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 4,
              color: Colors.white,
              strokeWidth: 2,
              strokeColor: const Color(0xFF92A3FD),
            ),
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                const Color(0xFF92A3FD).withValues(alpha: 0.3),
                const Color(0xFF9DCEFF).withValues(alpha: 0.1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      // Tooltip configuration
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (_) => Colors.white.withValues(alpha: 0.9),
          tooltipPadding: const EdgeInsets.all(8),
          tooltipBorderRadius: BorderRadius.circular(9),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toInt()} BPM',
                theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              );
            }).toList();
          },
        ),
      ),
      // Chart range
      minY: 0,
      maxY: 10,
    );
  }
}