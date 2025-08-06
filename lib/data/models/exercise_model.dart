import 'package:flutter/material.dart';

class Exercise {
  final String exerciseId;
  final String name;
  final String gifUrl;
  final List<String> targetMuscles;
  final List<String> bodyParts;
  final List<String> equipments;
  final List<String> secondaryMuscles;
  final List<String> instructions;
  IconData icon;
  int calories;
  bool isCompleted;

  Exercise({
    required this.exerciseId,
    required this.name,
    required this.gifUrl,
    required this.targetMuscles,
    required this.bodyParts,
    required this.equipments,
    required this.instructions,
    required this.secondaryMuscles,
    this.isCompleted = false,
    this.icon = Icons.fitness_center,
    this.calories = 40,
  });

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'name': name,
      'gifUrl': gifUrl,
      'targetMuscles': targetMuscles,
      'bodyParts': bodyParts,
      'equipments': equipments,
      'secondaryMuscles': secondaryMuscles,
      'instructions': instructions,
      'icon': icon,
      'calories': calories,
      'isCompleted': isCompleted,
    };
  }

  /// The factory constructor now includes a helper function to estimate
  /// calories based on the primary body part targeted by the exercise.
  factory Exercise.fromMap(Map<String, dynamic> map) {
    int estimateCalories(List<String> bodyParts) {
      if (bodyParts.isEmpty) {
        return 40;
      }

      String primaryPart = bodyParts.first.toLowerCase();
      switch (primaryPart) {
        case 'cardio':
        case 'back':
        case 'chest':
        case 'upper legs':
          return 60;
        case 'shoulders':
        case 'upper arms':
        case 'waist':
          return 45;
        case 'lower legs':
        case 'lower arms':
        case 'neck':
          return 30;
        default:
          return 40;
      }
    }
    final bodyPartsList = List<String>.from(map['bodyParts'] as List? ?? []);
    return Exercise(
      exerciseId: map['exerciseId'] as String? ?? '',
      name: map['name'] as String? ?? 'Unnamed Exercise',
      gifUrl: map['gifUrl'] as String? ?? '',
      targetMuscles: List<String>.from(map['targetMuscles'] as List? ?? []),
      bodyParts: bodyPartsList,
      equipments: List<String>.from(map['equipments'] as List? ?? []),
      secondaryMuscles: List<String>.from(map['secondaryMuscles'] as List? ?? []),
      instructions: List<String>.from(map['instructions'] as List? ?? []),
      calories: estimateCalories(bodyPartsList),
      isCompleted: map['isCompleted'] as bool? ?? false,
      icon: map['icon'] as IconData? ?? Icons.fitness_center,
    );
  }
}