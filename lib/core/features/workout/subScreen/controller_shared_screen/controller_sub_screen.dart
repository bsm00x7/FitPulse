import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../../../data/models/exercise_model.dart';
import '../../../../../services_ads_storage_local/preference_manager.dart';
import '../../../../constant/storage_key.dart';

class ControllerSubScreen with ChangeNotifier {
  List<Exercise> exercises = [];
  bool isLoading = false; // Track loading state
  String? errorMessage; // Track errors
  int get completedExercises => exercises.where((e) => e.isCompleted).length;

  int get totalCalories =>
      exercises.fold(0, (sum, e) => sum + (e.calories));
  int get completedCalories => exercises
      .where((e) => e.isCompleted)
      .fold(0, (sum, e) => sum + (e.calories));

  double get progressPercentage =>
      exercises.isEmpty ? 0.0 : completedExercises / exercises.length;
  void saveHistoryExercise({required Exercise exercise}) {
    try {
      if (exercise.name.isEmpty) {
        throw Exception('Exercise name cannot be empty');
      }

      final lastHistory = PreferenceManager().getString(StorageKey.lastActivity);
      final historyList = lastHistory?.split('||') ?? [];

      // Avoid duplicates and limit history size (e.g., max 50 entries)
      if (!historyList.contains(exercise.name)) {
        historyList.add(exercise.name);
        if (historyList.length > 50) {
          historyList.removeAt(0); // Remove oldest entry
        }
        PreferenceManager().setString(StorageKey.lastActivity, historyList.join('||'));
      }
    } catch (e) {
      debugPrint('Error saving exercise history: $e');
      // Optionally notify the caller or log to analytics
    }
  }
  void toggleExercise(int index) {
    exercises[index].isCompleted = !exercises[index].isCompleted;
    saveHistoryExercise(exercise: exercises[index]);
    final double? last = PreferenceManager().getDouble(StorageKey.calories);
    if (last==0 || last ==null){
      PreferenceManager().setDouble(StorageKey.calories, exercises[index].calories.toDouble());
    }else if (last +exercises[index].calories <=1000.0){
      PreferenceManager().setDouble(StorageKey.calories, last+ exercises[index].calories);
    }
    notifyListeners();
  }

  List<String> switchTarget(String targetFilter) {
    switch (targetFilter) {
      case 'Full Body Workout':
        return ['cardio', 'chest', 'back', 'upper arms', 'legs', 'shoulders'];
      case 'Lower Body Workout':
        return ['upper legs', 'lower legs'];
      case 'AB Workout':
        return ['waist', 'back'];
      case 'Upper Body Workout':
        return ['chest', 'shoulders', 'neck', 'upper arms', 'lower arms'];
      default:
        return ['cardio'];
    }
  }

  Future<void> getExercisesWithTarget({required String targetFilter}) async {
    isLoading = true;
    errorMessage = null;
    exercises.clear();
    List<String> targetParts = switchTarget(targetFilter);
    notifyListeners();
    try {
      List<Exercise> allExercises = [];
      for (String bodyPart in targetParts) {
        final apiUrl = 'https://www.exercisedb.dev/api/v1/bodyparts/$bodyPart/exercises?offset=0&limit=10';
        final response = await http.get(Uri.parse(apiUrl));
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body)['data'];
          Set<Exercise> bodyPartExercises = data
              .map((e) => Exercise.fromMap(e))
              .toSet();
          allExercises.addAll(bodyPartExercises.toList());
        } else {}
        await Future.delayed(const Duration(milliseconds: 200));
      }

      if (allExercises.isEmpty) {
        errorMessage = 'No exercises found for the selected workout type';
      } else {
        // Remove duplicates based on exercise name or ID
        exercises = removeDuplicateExercises(allExercises);
      }
    } catch (e) {
      errorMessage = 'Network error: $e';

    }

    isLoading = false;
    notifyListeners();
  }

  // Helper method to remove duplicate exercises
  List<Exercise> removeDuplicateExercises(List<Exercise> exerciseList) {
    final seen = <String>{};
    return exerciseList.where((exercise) {
      final exerciseName = exercise.name.toLowerCase();
      if (seen.contains(exerciseName)) {
        return false;
      }
      seen.add(exerciseName);
      return true;
    }).toList();
  }
}
