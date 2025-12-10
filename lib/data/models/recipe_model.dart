class Recipe {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final int prepTime; // in minutes
  final int cookTime; // in minutes
  final int servings;
  final List<String> tags;
  final String? imageUrl;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.prepTime,
    required this.cookTime,
    required this.servings,
    required this.tags,
    this.imageUrl,
  });

  int get totalTime => prepTime + cookTime;

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'prepTime': prepTime,
      'cookTime': cookTime,
      'servings': servings,
      'tags': tags,
      'imageUrl': imageUrl,
    };
  }

  // Create from Firestore Map
  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      ingredients: List<String>.from(map['ingredients'] ?? []),
      instructions: List<String>.from(map['instructions'] ?? []),
      calories: (map['calories'] ?? 0).toDouble(),
      protein: (map['protein'] ?? 0).toDouble(),
      carbs: (map['carbs'] ?? 0).toDouble(),
      fats: (map['fats'] ?? 0).toDouble(),
      prepTime: map['prepTime'] ?? 0,
      cookTime: map['cookTime'] ?? 0,
      servings: map['servings'] ?? 1,
      tags: List<String>.from(map['tags'] ?? []),
      imageUrl: map['imageUrl'],
    );
  }

  // Check if recipe matches a specific tag
  bool hasTag(String tag) {
    return tags.contains(tag.toLowerCase());
  }

  // Calculate calories per serving
  double get caloriesPerServing => calories / servings;
}
