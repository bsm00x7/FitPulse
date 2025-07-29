import 'dart:convert';
import 'package:fitness/core/constant/storeg_key.dart';
import 'package:flutter/cupertino.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/services/auth/auth_service.dart';
import '../../../../data/services/store_user_information.dart';
import '../../../../service/preference_manager.dart';

class ProfileController with ChangeNotifier {
  String? userName;
  double? height;
  double? weight;
  int? brith;
  String? get username => PreferenceManager().getString(StorageKey.firstName) ?? 'Unknown';
  String? get userGoal => PreferenceManager().getString(StorageKey.userGoal) ?? 'Unknown';
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  ProfileController() {
    init();
  }
  void init() {
    getUserInformation(); // Load user data on initialization
  }

  // Function to calculate age from DateTime
  // Load user information from preferences
  void getUserInformation() {
      final String? userdata = PreferenceManager().getString(StorageKey.user);
      if (userdata != null) {
        // jsonDecode returns Map<String, dynamic>, not String
        final String decodedData = jsonDecode(userdata);
        final UserModel user = UserModel.fromJson(decodedData);
        userName = user.firstName;
        height = user.height;
        weight = user.weight;
        // Parse birthday String to DateTime
        }
      }

    @override
  notifyListeners();
// Sign Out
  void signOut() async{
    await AuthService().signOut();
    notifyListeners();
  } // Notify  void updates
 void updateUserInformation ({required BuildContext context})async{
   final docId = AuthService().getUser();
   await FirestoreService().updateUserName(newUserName: usernameController.text.trim(), docId: docId!);
   getUserInformation();
   notifyListeners();

   Navigator.pop(context);

 }
}