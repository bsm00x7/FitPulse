import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../services_ads_storage_local/preference_manager.dart';
import '../../../constant/storage_key.dart';

class WalkingControllerProvider with ChangeNotifier {
  // Private variables
  int _stepsWalking = 0;
  int _baselineSteps = 0; // Store the baseline from device
  String _status = 'Initializing...';
  bool _isInitialized = false;
  final int _targetsSteps =
      PreferenceManager().getInt(StorageKey.steps) ?? 2500;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  // Weekly history tracking
  Map<String, int> _weeklySteps = {};
  int _currentStreak = 0;
  final Set<double> _achievedMilestones = {};
  String _lastResetDate = '';

  // Constructor
  WalkingControllerProvider() {
    _loadLastResetDate();
    _checkDailyReset();
    _loadWeeklyHistory();
    _loadStreak();
    initPlatformState();
  }

  // Getters
  int get steps => _stepsWalking;
  String get status => _status;
  bool get isInitialized => _isInitialized;
  Map<String, int> get weeklySteps => _weeklySteps;
  int get currentStreak => _currentStreak;
  int get targetsSteps => _targetsSteps > 0 ? _targetsSteps : 2500;

  // Calculated properties
  double get calories => _stepsWalking * 0.05;
  double get distance => (_stepsWalking * 0.78) / 1000;
  double get progressPercentage =>
      (_stepsWalking / targetsSteps).clamp(0.0, 2.0);

  // Get weekly step data for chart (last 7 days)
  List<Map<String, dynamic>> get weeklyChartData {
    final List<Map<String, dynamic>> chartData = [];
    final DateTime now = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey = _getDateKey(date);
      final steps = _weeklySteps[dateKey] ?? 0;

      chartData.add({
        'date': dateKey,
        'day': _getDayLabel(date),
        'steps': steps,
        'goalMet': steps >= targetsSteps,
      });
    }

    return chartData;
  }

  // Load last reset date
  void _loadLastResetDate() {
    _lastResetDate = PreferenceManager().getString('last_reset_date') ?? '';
  }

  // Check if we need to reset steps for a new day
  void _checkDailyReset() {
    final today = _getDateKey(DateTime.now());

    if (_lastResetDate != today) {
      // NEW DAY - Reset everything
      if (kDebugMode) {
        print('🔄 NEW DAY DETECTED!');
        print('📅 Last Reset: $_lastResetDate');
        print('📅 Today: $today');
        print('🔢 Previous Steps: $_stepsWalking');
      }

      // Save yesterday's steps to history before resetting
      if (_lastResetDate.isNotEmpty && _stepsWalking > 0) {
        _weeklySteps[_lastResetDate] = _stepsWalking;
        _saveWeeklyHistory();
      }

      // Reset for new day
      _stepsWalking = 0;
      _baselineSteps = 0;
      _achievedMilestones.clear();

      // Save reset state
      PreferenceManager().setInt(StorageKey.walkingStepsTrakcer, 0);
      PreferenceManager().setInt('baseline_steps', 0);
      PreferenceManager().setString('last_reset_date', today);
      _lastResetDate = today;

      if (kDebugMode) {
        print('✅ Steps reset to 0 for new day: $today');
        print('🎯 Target: $targetsSteps steps');
      }
    } else {
      // Same day - load existing steps
      _stepsWalking =
          PreferenceManager().getInt(StorageKey.walkingStepsTrakcer) ?? 0;
      _baselineSteps = PreferenceManager().getInt('baseline_steps') ?? 0;

      if (kDebugMode) {
        print('📊 Same day - Loading saved steps: $_stepsWalking');
        print('📍 Baseline: $_baselineSteps');
      }
    }
  }

  void _saveSteps() {
    PreferenceManager().setInt(StorageKey.walkingStepsTrakcer, _stepsWalking);
    PreferenceManager().setInt('baseline_steps', _baselineSteps);
    _saveCalories();
    _updateDailySteps();
  }

  // Handle step count updates from the pedometer stream
  void onStepCount(StepCount event) {
    final today = _getDateKey(DateTime.now());

    // Check if day has changed during runtime
    if (_lastResetDate != today) {
      if (kDebugMode) {
        print('🔄 Day changed during runtime! Resetting...');
      }
      _checkDailyReset();
      _baselineSteps = event.steps;
      PreferenceManager().setInt('baseline_steps', _baselineSteps);
    }

    // Set baseline on first reading of the day
    if (_baselineSteps == 0) {
      _baselineSteps = event.steps;
      PreferenceManager().setInt('baseline_steps', _baselineSteps);

      if (kDebugMode) {
        print('🎯 Setting baseline steps: $_baselineSteps');
      }
    }

    // Calculate today's steps (device steps - baseline)
    final previousSteps = _stepsWalking;
    _stepsWalking = (event.steps - _baselineSteps)
        .clamp(0, double.infinity)
        .toInt();

    if (kDebugMode && _stepsWalking % 100 == 0 && _stepsWalking > 0) {
      print('👣 Steps Update:');
      print('   Device Total: ${event.steps}');
      print('   Baseline: $_baselineSteps');
      print('   Today: $_stepsWalking');
      print('   Progress: ${(progressPercentage * 100).toInt()}%');
    }

    // Check for milestone achievements
    _checkMilestoneAchievement(previousSteps, _stepsWalking);

    _saveSteps();
    notifyListeners();
  }

  // Handle pedestrian status changes
  void onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
    notifyListeners();
  }

  // Handle errors
  void onPedestrianStatusError(error) {
    _status = 'Status unavailable';
    if (kDebugMode) {
      print('⚠️ Pedestrian status error: $error');
    }
    notifyListeners();
  }

  void onStepCountError(error) {
    _status = 'Steps unavailable';
    if (kDebugMode) {
      print('⚠️ Step count error: $error');
    }
    notifyListeners();
  }

  Future<void> initPlatformState() async {
    if (kDebugMode) {
      print('🚀 Initializing pedometer...');
    }

    if (await Permission.activityRecognition.request().isGranted) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);

      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);

      _status = 'Listening';

      if (kDebugMode) {
        print('✅ Pedometer initialized successfully');
        print('📅 Current Date: ${_getDateKey(DateTime.now())}');
        print('🎯 Daily Target: $targetsSteps steps');
      }
    } else {
      _status = 'Permission Denied';
      if (kDebugMode) {
        print('❌ Activity recognition permission denied');
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  void _saveCalories() {
    PreferenceManager().setDouble(StorageKey.calories, calories);
  }

  // Load weekly history from storage
  Future<void> _loadWeeklyHistory() async {
    final String? historyJson = PreferenceManager().getString(
      'weekly_steps_history',
    );
    if (historyJson != null && historyJson.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(historyJson);
        _weeklySteps = decoded.map((key, value) => MapEntry(key, value as int));

        if (kDebugMode) {
          print('📊 Loaded weekly history: ${_weeklySteps.length} days');
        }
      } catch (e) {
        _weeklySteps = {};
        if (kDebugMode) {
          print('⚠️ Error loading weekly history: $e');
        }
      }
    }
  }

  // Save weekly history to storage
  Future<void> _saveWeeklyHistory() async {
    await PreferenceManager().setString(
      'weekly_steps_history',
      jsonEncode(_weeklySteps),
    );
  }

  // Update daily steps count
  void _updateDailySteps() {
    final String today = _getDateKey(DateTime.now());
    _weeklySteps[today] = _stepsWalking;
    _saveWeeklyHistory();
    _updateStreak();
  }

  // Get date key in format YYYY-MM-DD
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Get day label (Mon, Tue, etc.)
  String _getDayLabel(DateTime date) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }

  // Load streak data
  Future<void> _loadStreak() async {
    _currentStreak = PreferenceManager().getInt('walking_streak') ?? 0;

    if (kDebugMode && _currentStreak > 0) {
      print('🔥 Current Streak: $_currentStreak days');
    }
  }

  // Update streak based on consecutive days meeting goal
  void _updateStreak() {
    final DateTime now = DateTime.now();
    int streak = 0;

    // Check backwards from today
    for (int i = 0; i < 365; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey = _getDateKey(date);
      final steps = _weeklySteps[dateKey] ?? 0;

      if (steps >= targetsSteps) {
        streak++;
      } else {
        break;
      }
    }

    if (streak != _currentStreak) {
      _currentStreak = streak;
      PreferenceManager().setInt('walking_streak', _currentStreak);

      if (kDebugMode) {
        print('🔥 Streak updated: $_currentStreak days');
      }
    }

    notifyListeners();
  }

  // Check milestone achievement and trigger haptic feedback
  void _checkMilestoneAchievement(int previousSteps, int currentSteps) {
    final previousProgress = (previousSteps / targetsSteps).clamp(0.0, 2.0);
    final currentProgress = (currentSteps / targetsSteps).clamp(0.0, 2.0);

    // Milestones: 25%, 50%, 75%, 100%, 150%
    final milestones = [0.25, 0.5, 0.75, 1.0, 1.5];

    for (final milestone in milestones) {
      if (previousProgress < milestone && currentProgress >= milestone) {
        if (!_achievedMilestones.contains(milestone)) {
          _achievedMilestones.add(milestone);
          _triggerHapticFeedback(milestone);

          if (kDebugMode) {
            print('🎯 Milestone achieved: ${(milestone * 100).toInt()}%');
          }
        }
      }
    }
  }

  // Trigger haptic feedback based on milestone
  void _triggerHapticFeedback(double milestone) {
    if (milestone >= 1.0) {
      HapticFeedback.heavyImpact();
    } else if (milestone >= 0.75) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
  }

  // Refresh data (for pull-to-refresh)
  Future<void> refresh() async {
    if (kDebugMode) {
      print('🔄 Refreshing data...');
    }

    _checkDailyReset();
    await _loadWeeklyHistory();
    await _loadStreak();
    notifyListeners();

    if (kDebugMode) {
      print('✅ Refresh complete');
    }
  }

  // Manual reset for testing (optional - can be called from a debug button)
  void debugReset() {
    if (kDebugMode) {
      print('🔧 DEBUG: Manual reset triggered');
    }

    _stepsWalking = 0;
    _baselineSteps = 0;
    _achievedMilestones.clear();

    PreferenceManager().setInt(StorageKey.walkingStepsTrakcer, 0);
    PreferenceManager().setInt('baseline_steps', 0);

    notifyListeners();
  }
}
