import 'package:fl_chart/fl_chart.dart';
import 'package:health/health.dart';
class HealthService {
  static final HealthService _instance = HealthService._internal();
  factory HealthService() => _instance;
  HealthService._internal();

  final Health _health = Health();

  /// Request permissions for health data access
  Future<bool> requestPermissions() async {
    try {
      // Define the health data types we want to access
      final types = [
        HealthDataType.HEART_RATE,
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.SLEEP_ASLEEP,
        HealthDataType.SLEEP_AWAKE,
        HealthDataType.SLEEP_DEEP,
        HealthDataType.SLEEP_REM,
      ];

      // Define permissions (READ access for all types)
      final permissions = types.map((type) => HealthDataAccess.READ).toList();

      // Request authorization
      bool? hasPermissions = await _health.requestAuthorization(
        types,
        permissions: permissions,
      );

      return hasPermissions ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Check if we have permissions for specific health data types
  Future<bool> hasPermissions() async {
    try {
      final types = [HealthDataType.HEART_RATE];
      return await _health.hasPermissions(
        types,
        permissions: [HealthDataAccess.READ],
      ) ??
          false;
    } catch (e) {
      return false;
    }
  }

  /// Get heart rate data points from Health app
  Future<List<HealthDataPoint>> getHeartRateData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      // Check permissions first
      final hasPermission = await hasPermissions();
      if (!hasPermission) {
        return [];
      }

      final types = [HealthDataType.HEART_RATE];

      // Default to last 24 hours if no dates provided
      startDate ??= DateTime.now().subtract(const Duration(days: 1));
      endDate ??= DateTime.now();


      final healthData = await _health.getHealthDataFromTypes(
        types: types,
        startTime: startDate,
        endTime: endDate,
      );

      // Filter and sort the data
      final heartRateData = healthData
          .where((point) => point.type == HealthDataType.HEART_RATE)
          .where((point) => point.value is num) // Ensure valid numeric value
          .toList();

      // Sort by date
      heartRateData.sort((a, b) => a.dateFrom.compareTo(b.dateFrom));

;
      return heartRateData;
    } catch (e) {

      return [];
    }
  }

  /// Convert heart rate data to chart points for fl_chart
  Future<List<FlSpot>> getHeartRateChartPoints({
    DateTime? startDate,
    DateTime? endDate,
    int maxPoints = 20, // Limit points for better chart performance
  }) async {
    try {
      final dataPoints = await getHeartRateData(
        startDate: startDate,
        endDate: endDate,
      );

      if (dataPoints.isEmpty) {
        return _getDefaultHeartRatePoints();
      }

      // Convert to FlSpot points
      List<FlSpot> spots = [];
      final startTime = startDate ?? DateTime.now().subtract(const Duration(days: 1));

      for (int i = 0; i < dataPoints.length; i++) {
        final dataPoint = dataPoints[i];
        final heartRate = _extractHeartRateValue(dataPoint.value);

        if (heartRate != null && heartRate > 0 && heartRate < 300) {
          // Valid heart rate range
          // Calculate hours since start time
          final hoursSinceStart = dataPoint.dateFrom.difference(startTime).inMinutes / 60.0;
          spots.add(FlSpot(hoursSinceStart, heartRate.toDouble()));
        }
      }

      // Limit number of points and ensure they're evenly distributed
      if (spots.length > maxPoints) {
        spots = _downsampleData(spots, maxPoints);
      }

      // Ensure we have at least some data points
      if (spots.isEmpty) {
        return _getDefaultHeartRatePoints();
      }

      // Sort by x-axis (time)
      spots.sort((a, b) => a.x.compareTo(b.x));

      return spots;
    } catch (e) {
      return _getDefaultHeartRatePoints();
    }
  }

  /// Extract numeric value from HealthValue
  double? _extractNumericValue(HealthValue healthValue) {
    try {
      // HealthValue has different types, handle each case
      if (healthValue is NumericHealthValue) {
        return healthValue.numericValue.toDouble();
      } else if (healthValue is WorkoutHealthValue) {
        // For workout data, extract total energy burned if available
        return healthValue.totalEnergyBurned?.toDouble();
      } else {
        // Try to parse from string representation as fallback
        final stringValue = healthValue.toString();
        final RegExp numRegex = RegExp(r'(\d+\.?\d*)');
        final match = numRegex.firstMatch(stringValue);
        if (match != null) {
          return double.tryParse(match.group(1) ?? '');
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Extract heart rate value specifically
  double? _extractHeartRateValue(HealthValue healthValue) {
    return _extractNumericValue(healthValue);
  }

  /// Downsample data to reduce number of points while preserving shape
  List<FlSpot> _downsampleData(List<FlSpot> spots, int targetCount) {
    if (spots.length <= targetCount) return spots;

    final step = spots.length / targetCount;
    final List<FlSpot> downsampled = [];

    for (int i = 0; i < targetCount; i++) {
      final index = (i * step).round();
      if (index < spots.length) {
        downsampled.add(spots[index]);
      }
    }

    return downsampled;
  }

  /// Generate default heart rate points when no real data is available
  List<FlSpot> _getDefaultHeartRatePoints() {
    return [
      const FlSpot(0, 72),
      const FlSpot(2, 75),
      const FlSpot(4, 78),
      const FlSpot(6, 74),
      const FlSpot(8, 71),
      const FlSpot(10, 76),
      const FlSpot(12, 80),
      const FlSpot(14, 77),
      const FlSpot(16, 73),
      const FlSpot(18, 75),
      const FlSpot(20, 72),
      const FlSpot(22, 70),
      const FlSpot(24, 71),
    ];
  }

  /// Get latest heart rate value
  Future<double?> getLatestHeartRate() async {
    try {
      final dataPoints = await getHeartRateData(
        startDate: DateTime.now().subtract(const Duration(hours: 1)),
        endDate: DateTime.now(),
      );

      if (dataPoints.isEmpty) return null;

      // Get the most recent data point
      final latest = dataPoints.last;
      return _extractHeartRateValue(latest.value);
    } catch (e) {
      return null;
    }
  }

  /// Get average heart rate for a given period
  Future<double?> getAverageHeartRate({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final dataPoints = await getHeartRateData(
        startDate: startDate,
        endDate: endDate,
      );

      if (dataPoints.isEmpty) return null;

      double total = 0;
      int validCount = 0;

      for (final point in dataPoints) {
        final value = _extractHeartRateValue(point.value);
        if (value != null && value > 0) {
          total += value;
          validCount++;
        }
      }

      return validCount > 0 ? total / validCount : null;
    } catch (e) {
      return null;
    }
  }

  /// Get steps data
  Future<List<HealthDataPoint>> getStepsData({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final types = [HealthDataType.STEPS];

      startDate ??= DateTime.now().subtract(const Duration(days: 1));
      endDate ??= DateTime.now();

      final healthData = await _health.getHealthDataFromTypes(
        types: types,
        startTime: startDate,
        endTime: endDate,
      );

      return healthData
          .where((point) => point.type == HealthDataType.STEPS)
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get total steps for today
  Future<int> getTodaySteps() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);

      final stepsData = await getStepsData(
        startDate: startOfDay,
        endDate: today,
      );

      int totalSteps = 0;
      for (final point in stepsData) {
        final value = _extractNumericValue(point.value);
        if (value != null) {
          totalSteps += value.toInt();
        }
      }

      return totalSteps;
    } catch (e) {
      return 0;
    }
  }

  /// Get calories burned data
  Future<double> getTodayCaloriesBurned() async {
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);

      final types = [HealthDataType.ACTIVE_ENERGY_BURNED];
      final healthData = await _health.getHealthDataFromTypes(
        types: types,
        startTime: startOfDay,
        endTime: today,
      );

      double totalCalories = 0;
      for (final point in healthData) {
        final value = _extractNumericValue(point.value);
        if (value != null) {
          totalCalories += value;
        }
      }

      return totalCalories;
    } catch (e) {
      return 0.0;
    }
  }
}