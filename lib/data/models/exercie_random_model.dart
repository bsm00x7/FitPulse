
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

// Improved Exercise Model
class ExerciseModel {
  final String id;
  final String name;
  final String gifUrl;
  final String target;
  final String bodyPart;
  final String equipment;
  final List<String> secondaryMuscles;
  final List<String> instructions;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.gifUrl,
    required this.target,
    required this.bodyPart,
    required this.equipment,
    required this.secondaryMuscles,
    required this.instructions,
  });

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id']?.toString() ?? '',
      name: (map['name'] as String? ?? '').capitalize(),
      gifUrl: map['gifUrl'] as String? ?? '',
      target: (map['target'] as String? ?? '').capitalize(),
      bodyPart: (map['bodyPart'] as String? ?? '').capitalize(),
      equipment: (map['equipment'] as String? ?? '').capitalize(),
      secondaryMuscles: List<String>.from(map['secondaryMuscles'] ?? [])
          .map((e) => e.capitalize())
          .toList(),
      instructions: List<String>.from(map['instructions'] ?? []),
    );
  }
}