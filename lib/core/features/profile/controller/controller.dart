import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../data/models/user_model.dart';
import '../../../../data/services/auth/auth_service.dart';
import '../../../../data/services/store_user_information.dart';
import '../../../../service/preference_manager.dart';
import '../../../constant/storage_key.dart';
import '../../onboarding/welcome_screen.dart';


// !! Refactor save image for saving in diracatory

class ProfileController with ChangeNotifier {
  String? userName;
  double? height;
  double? weight;
  int? brith;
  String? imageSource; // ✅ Declare without reading immediately
  String?  userGoal ;
  bool _notificationsEnabled = true;


  final TextEditingController usernameController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  XFile? image;

  final picker = ImagePicker();
  
  // Notification getter
  bool get notificationsEnabled => _notificationsEnabled;

  ProfileController() {
    init();
  }

  void init() {
    getUserInformation();
    loadImage();
    loadUserGoal();
    loadNotificationSettings();
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
    imageSource = PreferenceManager().getString(StorageKey.image);
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

  onSubmit({required BuildContext context}) {
    loadUserGoal();
    if (usernameController.text.trim()!=''){
      updateUserInformation(
        context: context,
      );
    }else{

      Navigator.pop(context);
    }
  }

  void loadUserGoal() {
    userGoal =PreferenceManager().getString(StorageKey.userGoal) ?? 'Unknown';
  }
  
  // Load notification settings
  void loadNotificationSettings() {
    _notificationsEnabled = PreferenceManager().getbool('notifications_enabled') ?? true;
    notifyListeners();
  }
  
  // Toggle notifications
  Future<void> toggleNotifications(bool value) async {
    _notificationsEnabled = value;
    await PreferenceManager().setBool('notifications_enabled', value);
    notifyListeners();
  }
}
