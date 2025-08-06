import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ActivityStatusWidget extends StatefulWidget {
  const ActivityStatusWidget({
    super.key,
    required this.size,
    required this.heartRateData,
    this.currentHeartRate,
    this.isLoading = false,
    this.onRefresh,
  });

  final Size size;
  final List<FlSpot> heartRateData;
  final double? currentHeartRate;
  final bool isLoading;
  final VoidCallback? onRefresh;

  @override
  State<ActivityStatusWidget> createState() => _ActivityStatusWidgetState();
}

class _ActivityStatusWidgetState extends State<ActivityStatusWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
          // Header with refresh button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Heart Rate',
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (widget.isLoading) ...[
                    const SizedBox(width: 8),
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ],
                ],
              ),
              Row(
                children: [
                  Text(
                    _getHeartRateDisplay(),
                    style: theme.textTheme.titleMedium!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _getHeartRateColor(theme),
                    ),
                  ),
                  if (widget.onRefresh != null) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: widget.onRefresh,
                      child: Icon(
                        Icons.refresh,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart
          Expanded(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation.value,
                  child: LineChart(
                    _buildLineChartData(theme),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getHeartRateDisplay() {
    if (widget.isLoading) return '...';
    if (widget.currentHeartRate == null) return '-- BPM';
    return '${widget.currentHeartRate!.round()} BPM';
  }

  Color _getHeartRateColor(ThemeData theme) {
    if (widget.currentHeartRate == null) return Colors.grey;

    final heartRate = widget.currentHeartRate!;
    if (heartRate < 60) {
      return Colors.blue; // Low
    } else if (heartRate > 100) {
      return Colors.orange; // High
    } else {
      return theme.colorScheme.primaryContainer; // Normal
    }
  }

  LineChartData _buildLineChartData(ThemeData theme) {
    // Calculate min/max Y values from data
    double minY = 60;
    double maxY = 100;

    if (widget.heartRateData.isNotEmpty) {
      final yValues = widget.heartRateData.map((spot) => spot.y).toList();
      minY = yValues.reduce((a, b) => a < b ? a : b) - 5;
      maxY = yValues.reduce((a, b) => a > b ? a : b) + 5;

      // Ensure reasonable bounds
      minY = minY.clamp(40, 80);
      maxY = maxY.clamp(80, 120);
    }

    return LineChartData(
      // Grid lines
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: (maxY - minY) / 3,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey[200],
            strokeWidth: 1,
          );
        },
      ),
      // Border configuration
      borderData: FlBorderData(show: false),
      // Titles for axes
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            maxIncluded: false,
            showTitles: true,
            reservedSize: 40,
            interval: (maxY - minY) / 3,
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
            interval: widget.heartRateData.isNotEmpty
                ? _calculateXInterval()
                : 4.0,
            getTitlesWidget: (value, meta) {
              return Text(
                _formatTimeLabel(value),
                style: theme.textTheme.bodySmall!.copyWith(
                  fontSize: 10,
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
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: widget.heartRateData.length <= 10, // Show dots only for fewer points
            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
              radius: 3,
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
          getTooltipColor: (_) => Colors.black87,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipBorderRadius: BorderRadius.circular(8),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              return LineTooltipItem(
                '${spot.y.toInt()} BPM',
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              );
            }).toList();
          },
        ),
      ),
      // Chart range
      minY: minY,
      maxY: maxY,
    );
  }
  double _calculateXInterval() {
    if (widget.heartRateData.isEmpty) return 4.0;
    final maxX = widget.heartRateData.map((e) => e.x).reduce((a, b) => a > b ? a : b);
    return (maxX / 6).ceilToDouble();
  }
  String _formatTimeLabel(double value) {
    final hours = value.toInt();
    if (hours == 0) return 'Now';
    if (hours == 1) return '1h';
    return '${hours}h';
  }
}