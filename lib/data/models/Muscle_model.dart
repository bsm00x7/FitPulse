class MuscleGroup {
  final int id;
  final String name;

  MuscleGroup({required this.id, required this.name});

  factory MuscleGroup.fromJson(Map<String, dynamic> json) {
    return MuscleGroup(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Exercise {
  final String name;
  final String description;

  Exercise({required this.name, required this.description});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }
}