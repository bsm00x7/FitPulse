import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../../data/models/meal_model.dart';
import '../../../../../../data/models/water_intake_model.dart';
import '../../../../../../data/services/nutrition_service.dart';
import '../../../../../../data/services/store_user_information.dart';

class NutritionController extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final NutritionService _nutritionService = NutritionService();
  
  // Daily nutrition tracking
  List<Meal> _meals = [];
  double _dailyCalorieGoal = 2000;
  double _dailyProteinGoal = 150;
  double _dailyCarbsGoal = 250;
  double _dailyFatsGoal = 65;
  
  // Water intake tracking
  List<WaterIntake> _waterIntakes = [];
  double _dailyWaterGoal = 2000; // ml
  
  // Loading states
  bool _isLoading = false;
  
  // Getters
  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;
  double get dailyCalorieGoal => _dailyCalorieGoal;
  double get dailyProteinGoal => _dailyProteinGoal;
  double get dailyCarbsGoal => _dailyCarbsGoal;
  double get dailyFatsGoal => _dailyFatsGoal;
  double get dailyWaterGoal => _dailyWaterGoal;
  List<WaterIntake> get waterIntakes => _waterIntakes;
  
  // Calculated values
  double get totalCalories => _meals.fold(0, (sum, meal) => sum + meal.calories);
  double get totalProtein => _meals.fold(0, (sum, meal) => sum + meal.protein);
  double get totalCarbs => _meals.fold(0, (sum, meal) => sum + meal.carbs);
  double get totalFats => _meals.fold(0, (sum, meal) => sum + meal.fats);
  double get totalWater => _waterIntakes.fold(0, (sum, intake) => sum + intake.amount);
  
  // Progress percentages
  double get calorieProgress => (totalCalories / _dailyCalorieGoal * 100).clamp(0, 100);
  double get proteinProgress => (totalProtein / _dailyProteinGoal * 100).clamp(0, 100);
  double get carbsProgress => (totalCarbs / _dailyCarbsGoal * 100).clamp(0, 100);
  double get fatsProgress => (totalFats / _dailyFatsGoal * 100).clamp(0, 100);
  double get waterProgress => (totalWater / _dailyWaterGoal * 100).clamp(0, 100);
  
  // Get meals by type
  List<Meal> getMealsByType(MealType type) {
    return _meals.where((meal) => meal.mealType == type).toList();
  }
  
  // Initialize - load today's data
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      await loadMealsForToday();
      await loadWaterIntakeForToday();
    } catch (e) {
      debugPrint('Error initializing nutrition controller: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Load meals for today
  Future<void> loadMealsForToday() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;
      
      final today = DateTime.now();
      final mealsData = await _firestoreService.getMealsForDate(userId, today);
      
      _meals = mealsData.map((data) => Meal.fromMap(data)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading meals: $e');
    }
  }
  
  // Load water intake for today
  Future<void> loadWaterIntakeForToday() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;
      
      final today = WaterIntake.dateFromDateTime(DateTime.now());
      final intakesData = await _firestoreService.getWaterIntakeForDate(userId, today);
      
      _waterIntakes = intakesData.map((data) => WaterIntake.fromMap(data)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading water intake: $e');
    }
  }
  
  // Add a meal
  Future<void> addMeal(Meal meal) async {
    try {
      await _firestoreService.saveMeal(meal.toMap());
      _meals.add(meal);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding meal: $e');
      rethrow;
    }
  }
  
  // Delete a meal
  Future<void> deleteMeal(String mealId) async {
    try {
      await _firestoreService.deleteMeal(mealId);
      _meals.removeWhere((meal) => meal.id == mealId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting meal: $e');
    }
  }
  
  // Add water intake
  Future<void> addWaterIntake(double amount) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) return;
      
      final intake = WaterIntake(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        amount: amount,
        timestamp: DateTime.now(),
        date: WaterIntake.dateFromDateTime(DateTime.now()),
      );
      
      await _firestoreService.saveWaterIntake(intake.toMap());
      _waterIntakes.add(intake);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding water intake: $e');
      rethrow;
    }
  }
  
  // Search food by barcode
  Future<FoodProduct?> searchFoodByBarcode(String barcode) async {
    return await _nutritionService.searchFoodByBarcode(barcode);
  }
  
  // Search food by name
  Future<List<FoodProduct>> searchFoodByName(String query) async {
    return await _nutritionService.searchFoodByName(query);
  }
  
  // Set nutrition goals
  void setNutritionGoals({
    double? calories,
    double? protein,
    double? carbs,
    double? fats,
    double? water,
  }) {
    if (calories != null) _dailyCalorieGoal = calories;
    if (protein != null) _dailyProteinGoal = protein;
    if (carbs != null) _dailyCarbsGoal = carbs;
    if (fats != null) _dailyFatsGoal = fats;
    if (water != null) _dailyWaterGoal = water;
    notifyListeners();
  }
}
