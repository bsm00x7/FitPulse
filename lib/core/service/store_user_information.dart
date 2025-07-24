import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Example: Fetch documents from a collection
  Future<List<Map<String, dynamic>>> getCollectionData(String collectionPath) async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      final data = snapshot.docs.map((doc) => doc.data()).toList();
      notifyListeners(); // Notify UI of data changes
      return data;
    } catch (e) {
      return [];
    }
  }
  // Example: Add a document to a collection
  Future<void> addDocument(String collectionPath, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).add(data);
      notifyListeners(); // Notify UI after adding
    } catch (e) {
    }
  }
  // SaveUser Details:
  Future<void> saveUserDetails(String userId, String gender, DateTime birth, double weight, double height) async {
    try {
      await _firestore.collection('users').doc(userId).set({
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
  Future<void> updateDocument(String collectionPath, String docId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).update(data);
      notifyListeners(); // Notify UI after updating
    } catch (e) {
    }
  }

  // Example: Delete a document
  Future<void> deleteDocument(String collectionPath, String docId) async {
    try {
      await _firestore.collection(collectionPath).doc(docId).delete();
      notifyListeners(); // Notify UI after deletion
    } catch (e) {
       }
  }
}