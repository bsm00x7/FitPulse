import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Example: Fetch documents from a collection
  Future<List<Map<String, dynamic>>> getCollectionData(
    String collectionPath,
  ) async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      final data = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners(); // Notify UI of data changes
      return data;
    } catch (e) {
      if (kDebugMode) {
        print('Error in getCollectionData: $e');
      }
      return [];
    }
  }

  /*
  final Map <String , dynamic> user ={
  "userid" : 
  
  }
  */
Future<Map<String, dynamic>?> getUserFromCollection({
  required String userId,
}) async {
  try {
    // Get the document snapshot
    final snapshot = await _firestore.collection('users').doc(userId).get();
    
    // Check if the document exists
    if (snapshot.exists) {
      // Return the document data as Map<String, dynamic>
      return snapshot.data() as Map<String, dynamic>;
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (e) {
    // Handle error appropriately

    return null;
  }
}

  // Example: Add a document to a collection
  Future<void> addDocument(
    String collectionPath,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collectionPath).add(data);
      notifyListeners(); // Notify UI after adding
    } catch (e) {
      if (kDebugMode) {
        print('Error in addDocument: $e');
      }
    }
  }

  // Save basic user info for Google Sign-In
  Future<void> saveBasicUserInfo(
    String userId,
    String email,
    String username,
    String lastName,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'username': username,
        'lastname': lastName,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Use merge to avoid overwriting existing data
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error in saveBasicUserInfo: $e');
      }
      rethrow;
    }
  }

  // SaveUser Details:
  Future<void> saveUserDetails(
    String userId,
    String username,
    String lastName,
    String gender,
    DateTime birth,
    double weight,
    double height,
  ) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'username': username,
        'lastname': lastName,
        'gender': gender,
        'birth': Timestamp.fromDate(birth),
        'weight': weight,
        'height': height,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Use merge to update existing document
      notifyListeners();
    } catch (e) {
      rethrow; // Let the caller handle the error
    }
  }

  // Example: Update a document
  Future<void> updateUserName({required String newUserName,
    required String docId,}
      ) async {
    try {
       final coll= _firestore.collection('users').doc(docId);
       coll.update({'username': newUserName});
      notifyListeners(); // Notify UI after updating
    } catch (e) {
      if (kDebugMode) {
        print('Error in updateUserName: $e');
      }
    }
  }
  Future<void> updateDocument(
    String collectionPath,
    String docId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
      notifyListeners(); // Notify UI after updating
    } catch (e) {
      if (kDebugMode) {
        print('Error in updateDocument: $e');
      }
    }
  }

  // Example: Delete a document
  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
      notifyListeners(); // Notify UI after deletion
    } catch (e) {
      if (kDebugMode) {
        print('Error in deleteDocument: $e');
      }
    }
  }
  Future<String?> getUserName(String docId)async{
  try{
   final data = await _firestore.collection('users').doc(docId).get();
   if (data.exists) {
     return data.data()?['username'];
   }
  }catch (e){
  rethrow;
  }
  return null;
  }

  // ============= NUTRITION TRACKING METHODS =============
  
  // Save a meal
  Future<void> saveMeal(Map<String, dynamic> mealData) async {
    try {
      await _firestore.collection('meals').doc(mealData['id']).set(mealData);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving meal: $e');
      }
      rethrow;
    }
  }

  // Get meals for a specific date
  Future<List<Map<String, dynamic>>> getMealsForDate(String userId, DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

      final snapshot = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('timestamp', isLessThanOrEqualTo: endOfDay.toIso8601String())
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting meals for date: $e');
      }
      return [];
    }
  }

  // Delete a meal
  Future<void> deleteMeal(String mealId) async {
    try {
      await _firestore.collection('meals').doc(mealId).delete();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting meal: $e');
      }
    }
  }

  // Save water intake
  Future<void> saveWaterIntake(Map<String, dynamic> waterIntakeData) async {
    try {
      await _firestore
          .collection('water_intake')
          .doc(waterIntakeData['id'])
          .set(waterIntakeData);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving water intake: $e');
      }
      rethrow;
    }
  }

  // Get water intake for a specific date
  Future<List<Map<String, dynamic>>> getWaterIntakeForDate(
    String userId,
    String date, // Format: YYYY-MM-DD
  ) async {
    try {
      final snapshot = await _firestore
          .collection('water_intake')
          .where('userId', isEqualTo: userId)
          .where('date', isEqualTo: date)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting water intake: $e');
      }
      return [];
    }
  }

  // Save meal plan
  Future<void> saveMealPlan(Map<String, dynamic> mealPlanData) async {
    try {
      await _firestore
          .collection('meal_plans')
          .doc(mealPlanData['id'])
          .set(mealPlanData);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving meal plan: $e');
      }
      rethrow;
    }
  }

  // Get meal plan for a specific week
  Future<Map<String, dynamic>?> getMealPlan(String userId, DateTime weekStart) async {
    try {
      final snapshot = await _firestore
          .collection('meal_plans')
          .where('userId', isEqualTo: userId)
          .where('weekStartDate', isEqualTo: weekStart.toIso8601String())
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting meal plan: $e');
      }
      return null;
    }
  }

  // Save recipe
  Future<void> saveRecipe(Map<String, dynamic> recipeData) async {
    try {
      await _firestore
          .collection('recipes')
          .doc(recipeData['id'])
          .set(recipeData);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error saving recipe: $e');
      }
      rethrow;
    }
  }

  // Get all recipes
  Future<List<Map<String, dynamic>>> getRecipes() async {
    try {
      final snapshot = await _firestore.collection('recipes').get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting recipes: $e');
      }
      return [];
    }
  }

  // Get recipes by tag
  Future<List<Map<String, dynamic>>> getRecipesByTag(String tag) async {
    try {
      final snapshot = await _firestore
          .collection('recipes')
          .where('tags', arrayContains: tag)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting recipes by tag: $e');
      }
      return [];
    }
  }
}
