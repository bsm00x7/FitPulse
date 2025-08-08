import 'dart:convert';

import 'package:fitness/core/constant/storage_Key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/user_model.dart';
import '../../../../data/services/auth/auth_service.dart';
import '../../../../data/services/store_user_information.dart';
import '../../../../service/preference_manager.dart';
import '../../onboarding/welcome_screen.dart';

class ProfileController with ChangeNotifier {
  String? userName;
  double? height;
  double? weight;
  int? brith;

  String? get userGoal =>
      PreferenceManager().getString(StorageKey.userGoal) ?? 'Unknown';
  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  ProfileController() {
    init();
  }

  void init() {
    getUserInformation();
  }

  void getUserInformation() {
    try {
      final String? userdata = PreferenceManager().getString(StorageKey.user);
      if (userdata != null) {
        final String decodedData = jsonDecode(userdata);
        final UserModel user = UserModel.fromJson(decodedData);
        userName = user.firstName;
        height = user.height;
        weight = user.weight;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  notifyListeners();

// Sign Out
  void signOut(BuildContext context) async {
    await AuthService().signOut();
    PreferenceManager().clear();
    notifyListeners();
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => WelcomeScreen(),), (
        Route<dynamic> route) => false);

  } // Notify  void updates
  void updateUserInformation({required BuildContext context}) async {
    final docId = AuthService().getUser();
    await FirestoreService().updateUserName(
        newUserName: usernameController.text.trim(), docId: docId!);
    getUserInformation();
    notifyListeners();
    Navigator.pop(context);
  }
}