import 'package:fitness/core/constant/storage_Key.dart';
import 'package:fitness/service/preference_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';



class WalkingControllerProvider with ChangeNotifier {
  // Private variables
  int _stepsWalking = 0;
  String _status = 'Initializing...';
  bool _isInitialized = false;
  final int _targetsSteps = PreferenceManager().getInt(StorageKey.steps)??2500 ;
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  // Constructor
  WalkingControllerProvider() {
    initPlatformState();
  }
  // Getters
  int get steps => _stepsWalking;
  String get status => _status;
  bool get isInitialized => _isInitialized;

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

  void _saveSteps() {
    PreferenceManager().setInt(StorageKey.walkingStepsTrakcer, _stepsWalking);
    _saveCalories();
  }

  // Handle step count updates from the pedometer stream
  void onStepCount(StepCount event) {

    _stepsWalking = event.steps;
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
}
