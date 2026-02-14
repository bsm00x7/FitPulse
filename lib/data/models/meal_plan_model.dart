class MealPlan {
  final String id;
  final String userId;
  final DateTime weekStartDate;
  final Map<String, Map<String, PlannedMeal>>
  meals; // {day: {mealType: PlannedMeal}}
  final List<GroceryItem> groceryList;

  MealPlan({
    required this.id,
    required this.userId,
    required this.weekStartDate,
    required this.meals,
    required this.groceryList,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'weekStartDate': weekStartDate.toIso8601String(),
      'meals': meals.map(
        (day, mealTypes) => MapEntry(
          day,
          mealTypes.map((type, meal) => MapEntry(type, meal.toMap())),
        ),
      ),
      'groceryList': groceryList.map((item) => item.toMap()).toList(),
    };
  }

  // Create from Firestore Map
  factory MealPlan.fromMap(Map<String, dynamic> map) {
    return MealPlan(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      weekStartDate: DateTime.parse(map['weekStartDate']),
      meals: (map['meals'] as Map<String, dynamic>).map(
        (day, mealTypes) => MapEntry(
          day,
          (mealTypes as Map<String, dynamic>).map(
            (type, meal) => MapEntry(type, PlannedMeal.fromMap(meal)),
          ),
        ),
      ),
      groceryList: (map['groceryList'] as List)
          .map((item) => GroceryItem.fromMap(item))
          .toList(),
    );
  }

  // Get week end date
  DateTime get weekEndDate => weekStartDate.add(const Duration(days: 6));

  // Get meals for a specific day
  Map<String, PlannedMeal>? getMealsForDay(String day) {
    return meals[day];
  }
}

class PlannedMeal {
  final String recipeId;
  final String recipeName;
  final String
  mealTime; // e.g., "breakfast", "lunch", "dinner", "pre-workout", "post-workout"
  final String? notes;

  PlannedMeal({
    required this.recipeId,
    required this.recipeName,
    required this.mealTime,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'recipeId': recipeId,
      'recipeName': recipeName,
      'mealTime': mealTime,
      'notes': notes,
    };
  }

  factory PlannedMeal.fromMap(Map<String, dynamic> map) {
    return PlannedMeal(
      recipeId: map['recipeId'] ?? '',
      recipeName: map['recipeName'] ?? '',
      mealTime: map['mealTime'] ?? '',
      notes: map['notes'],
    );
  }
}

class GroceryItem {
  final String name;
  final String quantity;
  final String category; // e.g., "Produce", "Meat", "Dairy", "Grains"
  final bool isChecked;

  GroceryItem({
    required this.name,
    required this.quantity,
    required this.category,
    this.isChecked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'category': category,
      'isChecked': isChecked,
    };
  }

  factory GroceryItem.fromMap(Map<String, dynamic> map) {
    return GroceryItem(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? '',
      category: map['category'] ?? 'Other',
      isChecked: map['isChecked'] ?? false,
    );
  }

  // Copy with method for toggling checked state
  GroceryItem copyWith({
    String? name,
    String? quantity,
    String? category,
    bool? isChecked,
  }) {
    return GroceryItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isChecked: isChecked ?? this.isChecked,
    );
  }
}
