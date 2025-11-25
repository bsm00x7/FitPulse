
import 'dart:convert';
import 'package:fitness/service/preference_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../constant/storage_key.dart';



class WalkingControllerProvider with ChangeNotifier {
  // Private variables
  int _stepsWalking = 0;
  String _status = 'Initializing...';
  bool _isInitialized = false;
  final int _targetsSteps = PreferenceManager().getInt(StorageKey.steps)??2500 ;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  
  // Weekly history tracking
  Map<String, int> _weeklySteps = {};
  int _currentStreak = 0;
  Set<double> _achievedMilestones = {};

  // Constructor
  WalkingControllerProvider() {
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

  // --- FIX 2: Ensure target steps is never zero to avoid errors ---
  int get targetsSteps => _targetsSteps > 0 ? _targetsSteps : 2500;

  // Calculated properties
  double get calories => _stepsWalking * 0.05;
  double get distance => (_stepsWalking * 0.78) / 1000;

  // --- NEW: A helper to calculate progress percentage safely ---
  double get progressPercentage {
    // Clamp the value between 0.0 and 1.0
    return (_stepsWalking / targetsSteps).clamp(0.0, 1.0);
  }
  
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

  void _saveSteps() {
    PreferenceManager().setInt(StorageKey.walkingStepsTrakcer, _stepsWalking);
    _saveCalories();
    _updateDailySteps();
  }

  // Handle step count updates from the pedometer stream
  void onStepCount(StepCount event) {
    final previousSteps = _stepsWalking;
    _stepsWalking = event.steps;
    
    // Check for milestone achievements and trigger haptic feedback
    _checkMilestoneAchievement(previousSteps, _stepsWalking);
    
    _saveSteps();
    notifyListeners();
  }

  // Handle pedestrian status changes (e.g., 'walking', 'stopped')
  void onPedestrianStatusChanged(PedestrianStatus event) {
    _status = event.status;
    notifyListeners();
  }

  // Handle errors
  void onPedestrianStatusError(error) {
    _status = 'Status unavailable';
    notifyListeners();
  }

  void onStepCountError(error) {
    _status = 'Steps unavailable';
    notifyListeners();
  }


  Future<void> initPlatformState() async {

    if (await Permission.activityRecognition.request().isGranted) {
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);
      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);

      _status = 'Listening';
    } else {
      _status = 'Permission Denied';
    }
    _isInitialized = true;
    notifyListeners();
  }

  void _saveCalories() {
    PreferenceManager().setDouble(StorageKey.calories, calories);
  }
  
  // Load weekly history from storage
  Future<void> _loadWeeklyHistory() async {
    final String? historyJson = PreferenceManager().getString('weekly_steps_history');
    if (historyJson != null && historyJson.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(historyJson);
        _weeklySteps = decoded.map((key, value) => MapEntry(key, value as int));
      } catch (e) {
        _weeklySteps = {};
      }
    }
  }
  
  // Save weekly history to storage
  Future<void> _saveWeeklyHistory() async {
    await PreferenceManager().setString('weekly_steps_history', jsonEncode(_weeklySteps));
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
    
    _currentStreak = streak;
    PreferenceManager().setInt('walking_streak', _currentStreak);
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
        }
      }
    }
  }
  
  // Trigger haptic feedback based on milestone
  void _triggerHapticFeedback(double milestone) {
    if (milestone >= 1.0) {
      // Strong feedback for 100% and above
      HapticFeedback.heavyImpact();
    } else if (milestone >= 0.75) {
      // Medium feedback for 75%
      HapticFeedback.mediumImpact();
    } else {
      // Light feedback for 25% and 50%
      HapticFeedback.lightImpact();
    }
  }
  
  // Refresh data (for pull-to-refresh)
  Future<void> refresh() async {
    await _loadWeeklyHistory();
    await _loadStreak();
    notifyListeners();
  }
}
