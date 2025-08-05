import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../../../../data/models/exercise_model.dart';

class ControllerSubScreen with ChangeNotifier {
  List<Exercise> exercises = [];
  bool isLoading = false; // Track loading state
  String? errorMessage; // Track errors
  static const String apiToken = '9456|tsTIYzKUkDQ53PWA94uViZYDvnOikgRE4Xk5VUG9';
  int get completedExercises =>
      exercises
          .where((e) => e.isCompleted)
          .length;

  int get totalCalories =>
      exercises.fold(0, (sum, e) => sum + (e.calories ?? 0));

  int get completedCalories =>
      exercises.where((e) => e.isCompleted).fold(
          0, (sum, e) => sum + (e.calories ?? 0));

  double get progressPercentage =>
      exercises.isEmpty ? 0.0 : completedExercises / exercises.length;

  void toggleExercise(int index) {
    exercises[index].isCompleted = !exercises[index].isCompleted;
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
Future<int>getCaloriesFromExercisesWithId({required String id})async{
    final apiUrl = 'https://zylalabs.com/api/7232/workout+routine+api/11447/calories+burned?age=24&gender=male&weight=80&exercise_id=$id';
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer$apiToken',
        'Content-Type': 'application/json',
      }
    );
     String data = '20';
    if (response.statusCode == 200) {
      data = jsonDecode(response.body)['calories_burned'];
      debugPrint(data.toString());

    }
    return int.parse(data);
}
  Future<void> getExercisesWithTarget({required String targetFilter}) async {
    isLoading = true;
    errorMessage = null;
    exercises.clear(); // Clear previous exercises
    List<String> targetParts = switchTarget(targetFilter);
    notifyListeners();
    try {
      List<Exercise> allExercises = [];
      for (String bodyPart in targetParts) {
        final apiUrl =
            'https://zylalabs.com/api/7232/workout+routine+api/11409/list+exercise+by+body+part?bodyPart=$bodyPart';
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $apiToken',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          Set<Exercise> bodyPartExercises = data.map((e) => Exercise.fromMap(e).copyWith(calories: 40)).toSet();
          allExercises.addAll(bodyPartExercises.toList());
        } else {
        }

        // Add a small delay between requests to avoid rate limiting
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
      debugPrint('Network Error: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Helper method to remove duplicate exercises
  List<Exercise> removeDuplicateExercises(List<Exercise> exerciseList) {
    final seen = <String>{};
    return exerciseList.where((exercise) {
      final exerciseName = exercise.name?.toLowerCase() ?? '';
      if (seen.contains(exerciseName)) {
        return false;
      }
      seen.add(exerciseName);
      return true;
    }).toList();
  }
}