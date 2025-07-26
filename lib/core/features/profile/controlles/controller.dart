import 'dart:convert';
import 'package:flutter/cupertino.dart';
import '../../../../data/models/user_model.dart';
import '../../../../service/preference_manager.dart';

class ProfileController with ChangeNotifier {
  String? userName; // Made nullable to avoid late initialization issues
  String? userGoal;
  double? height;
  double? weight;
  int? brith;

  String? get username => PreferenceManager().getString('username') ?? 'Unknown';

  ProfileController() {
    init();
  }

  void init() {
    getUserInformation(); // Load user data on initialization
  }

  // Function to calculate age from DateTime
  // Load user information from preferences
  void getUserInformation() {
      final String? userdata = PreferenceManager().getString('user');
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
  notifyListeners(); // Notify UI of changes

}