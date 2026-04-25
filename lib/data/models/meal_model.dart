class Meal {
  final String id;
  final String userId;
  final String name;
  final MealType mealType;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double fiber;
  final String servingSize;
  final DateTime timestamp;
  final String? barcode;
  final String? imageUrl;

  Meal({
    required this.id,
    required this.userId,
    required this.name,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
    required this.servingSize,
    required this.timestamp,
    this.barcode,
    this.imageUrl,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'mealType': mealType.toString().split('.').last,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'fiber': fiber,
      'servingSize': servingSize,
      'timestamp': timestamp.toIso8601String(),
      'barcode': barcode,
      'imageUrl': imageUrl,
    };
  }

  // Create from Firestore Map
  factory Meal.fromMap(Map<String, dynamic> map) {
    double convert(String value) {
      return double.parse(value);
    }

    return Meal(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      mealType: MealType.values.firstWhere(
        (e) => e.toString().split('.').last == map['mealType'],
        orElse: () => MealType.snack,
      ),
      calories: convert(map['calories'] ?? 0),
      protein: convert(map['protein'] ?? 0),
      carbs: convert(map['carbs'] ?? 0),
      fats: convert(map['fats'] ?? 0),
      fiber: convert(map['fiber'] ?? 0),
      servingSize: map['servingSize'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      barcode: map['barcode'],
      imageUrl: map['imageUrl'],
    );
  }
  Meal copyWith({
    String? id,
    String? userId,
    String? name,
    MealType? mealType,
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? fiber,
    String? servingSize,
    DateTime? timestamp,
    String? barcode,
    String? imageUrl,
  }) {
    return Meal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      mealType: mealType ?? this.mealType,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      fiber: fiber ?? this.fiber,
      servingSize: servingSize ?? this.servingSize,
      timestamp: timestamp ?? this.timestamp,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

enum MealType { breakfast, lunch, dinner, snack }
