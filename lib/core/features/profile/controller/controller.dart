import 'dart:convert';
import 'dart:io';

import 'package:fitness/core/constant/storage_Key.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  String? imageSource; // ✅ Declare without reading immediately
  String? get userGoal =>
      PreferenceManager().getString(StorageKey.userGoal) ?? 'Unknown';

  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  XFile? image;

  final picker = ImagePicker();

  ProfileController() {
    init();
  }

  void init() {
    getUserInformation();
    loadImage(); // ✅ Load image from preferences
  }

  void getUserInformation() {
    try {
      final String? userdata = PreferenceManager().getString(StorageKey.user);
      if (userdata != null) {
        final decodedData = jsonDecode(userdata);
        final UserModel user = UserModel.fromJson(decodedData);
        userName = user.firstName;
        height = user.height;
        weight = user.weight;
      }
    } catch (e) {
      rethrow;
    }
  }

  void loadImage() async {
    imageSource = await PreferenceManager().getString(StorageKey.image);
    notifyListeners(); // ✅ Make sure UI updates on load
  }

  // Sign Out
  void signOut(BuildContext context) async {
    await AuthService().signOut();
    PreferenceManager().clear();
    notifyListeners();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => WelcomeScreen()),
          (Route<dynamic> route) => false,
    );
  }

  void updateUserInformation({required BuildContext context}) async {
    final docId = AuthService().getUser();
    await FirestoreService().updateUserName(
      newUserName: usernameController.text.trim(),
      docId: docId!,
    );
    getUserInformation();
    notifyListeners();
    Navigator.pop(context);
  }

  void pickImageFromGallery() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && image!.path.isNotEmpty) {
      imageSource = image!.path;
      await PreferenceManager().setString(StorageKey.image, imageSource!);
      notifyListeners(); // ✅ UI updates immediately
    }
  }

  void pickImageFromCamera() async {
    image = await picker.pickImage(source: ImageSource.camera);
    if (image != null && image!.path.isNotEmpty) {
      imageSource = image!.path;
      await PreferenceManager().setString(StorageKey.image, imageSource!);
      notifyListeners(); // ✅ UI updates immediately
    }
  }
}
