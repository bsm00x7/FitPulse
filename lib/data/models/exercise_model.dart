import 'package:flutter/cupertino.dart';

class Exercise {
  final String name;
  final String? duration; // Made optional since not in JSON
  final IconData? icon; // Made optional since not in JSON
  final String equipment;
   int? calories; // Made optional since not in JSON
  final String bodyPart;
  final String gifUrl;
  final int id;
  final String target;
  final List<Map<String, String>> videos;
  bool isCompleted;

  Exercise({
    required this.name,
    this.duration,
    this.icon,
    required this.equipment,
    this.calories,
    required this.bodyPart,
    required this.gifUrl,
    required this.id,
    required this.target,
    required this.videos, // Added to match JSON
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'duration': duration,
      'icon': icon?.codePoint, // Store IconData's codePoint if needed
      'equipment': equipment,
      'calories': calories,
      'bodyPart': bodyPart,
      'gifUrl': gifUrl,
      'id': id,
      'target': target,
      'videos': videos,
      'isCompleted': isCompleted,
    };
  }

  factory Exercise.fromMap(Map<String, dynamic> map) {
    return Exercise(
      name: map['name'] as String,
      duration: map['duration'] as String?, // Nullable
      icon: map['icon'] != null
          ? IconData(map['icon'] as int, fontFamily: 'CupertinoIcons')
          : null, // Handle IconData if provided
      equipment: map['equipment'] as String,
      calories: map['calories'] as int?, // Nullable
      bodyPart: map['bodyPart'] as String,
      gifUrl: map['gifUrl'] as String,
      id: map['id'] as int,
      target: map['target'] as String,
      videos: (map['videos'] as List<dynamic>)
          .map((v) => Map<String, String>.from(v))
          .toList(),
      isCompleted: map['isCompleted'] as bool? ?? false,
    );
  }

  Exercise copyWith({
    String? name,
    String? duration,
    IconData? icon,
    String? equipment,
    int? calories,
    String? bodyPart,
    String? gifUrl,
    int? id,
    String? target,
    List<Map<String, String>>? videos,
    bool? isCompleted,
  }) {
    return Exercise(
      name: name ?? this.name,
      duration: duration ?? this.duration,
      icon: icon ?? this.icon,
      equipment: equipment ?? this.equipment,
      calories: calories ?? this.calories,
      bodyPart: bodyPart ?? this.bodyPart,
      gifUrl: gifUrl ?? this.gifUrl,
      id: id ?? this.id,
      target: target ?? this.target,
      videos: videos ?? this.videos,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}