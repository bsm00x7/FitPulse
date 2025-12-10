import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/meal_model.dart';

class NutritionService {
  // Open Food Facts API base URL
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v2';

  // Search food by barcode
  Future<FoodProduct?> searchFoodByBarcode(String barcode) async {
    try {
      final url = Uri.parse('$_baseUrl/product/$barcode.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 1 && data['product'] != null) {
          return FoodProduct.fromOpenFoodFactsJson(data['product']);
        }
      }
      
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error searching food by barcode: $e');
      }
      return null;
    }
  }

  // Search food by name
  Future<List<FoodProduct>> searchFoodByName(String query) async {
    try {
      final url = Uri.parse('$_baseUrl/search').replace(queryParameters: {
        'search_terms': query,
        'page_size': '20',
        'json': '1',
      });
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['products'] != null) {
          final products = (data['products'] as List)
              .map((product) => FoodProduct.fromOpenFoodFactsJson(product))
              .toList();
          return products;
        }
      }
      
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error searching food by name: $e');
      }
      return [];
    }
  }

  // Get detailed nutritional info
  Future<FoodProduct?> getNutritionalInfo(String barcode) async {
    return searchFoodByBarcode(barcode);
  }

  // Convert FoodProduct to Meal
  Meal convertToMeal({
    required String userId,
    required FoodProduct food,
    required MealType mealType,
    double servingMultiplier = 1.0,
  }) {
    return Meal(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      name: food.name,
      mealType: mealType,
      calories: food.calories * servingMultiplier,
      protein: food.protein * servingMultiplier,
      carbs: food.carbs * servingMultiplier,
      fats: food.fats * servingMultiplier,
      fiber: food.fiber * servingMultiplier,
      servingSize: '${food.servingSize * servingMultiplier}g',
      timestamp: DateTime.now(),
      barcode: food.barcode,
      imageUrl: food.imageUrl,
    );
  }
}

// Food product model for API responses
class FoodProduct {
  final String name;
  final String barcode;
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double fiber;
  final double servingSize; // in grams
  final String? imageUrl;

  FoodProduct({
    required this.name,
    required this.barcode,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.fiber,
    required this.servingSize,
    this.imageUrl,
  });

  // Parse from Open Food Facts API response
  factory FoodProduct.fromOpenFoodFactsJson(Map<String, dynamic> json) {
    final nutriments = json['nutriments'] ?? {};
    
    // Get calories (in kcal per 100g)
    final double calories = (nutriments['energy-kcal_100g'] ?? 
                             nutriments['energy-kcal'] ?? 
                             0).toDouble();
    
    // Get macros (per 100g)
    final double protein = (nutriments['proteins_100g'] ?? 
                           nutriments['proteins'] ?? 
                           0).toDouble();
    
    final double carbs = (nutriments['carbohydrates_100g'] ?? 
                         nutriments['carbohydrates'] ?? 
                         0).toDouble();
    
    final double fats = (nutriments['fat_100g'] ?? 
                        nutriments['fat'] ?? 
                        0).toDouble();
    
    final double fiber = (nutriments['fiber_100g'] ?? 
                         nutriments['fiber'] ?? 
                         0).toDouble();
    
    // Get serving size (default to 100g if not specified)
    final double servingSize = (json['serving_quantity'] ?? 100).toDouble();
    
    // Get product name
    final String name = json['product_name'] ?? 
                       json['product_name_en'] ?? 
                       'Unknown Product';
    
    // Get barcode
    final String barcode = json['code'] ?? '';
    
    // Get image URL
    final String? imageUrl = json['image_url'] ?? 
                            json['image_front_url'];

    return FoodProduct(
      name: name,
      barcode: barcode,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fats: fats,
      fiber: fiber,
      servingSize: servingSize,
      imageUrl: imageUrl,
    );
  }
}
