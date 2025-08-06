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
}
