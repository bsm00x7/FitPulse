import 'dart:convert';

import 'package:fitness/core/constant/storeg_key.dart';
import 'package:fitness/data/models/user_model.dart';
import 'package:fitness/data/services/auth/auth_service.dart';
import 'package:fitness/data/services/store_user_information.dart';
import 'package:fitness/service/preference_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../activity/model/activity_model.dart';

class HomeController with ChangeNotifier {
  String? type;
  double? bmi;
  double? weight;
  double? height;
  List<Map<String, dynamic>> intakeDataNew = [];
  double? startWater = 0;

  // Graph of Activity status
  final List<FlSpot> heartRateData = [
    FlSpot(0, 8),
    FlSpot(2, 1),
    FlSpot(3, 8),
    FlSpot(4, 1),
    FlSpot(5, 9),
    FlSpot(6, 1),
    FlSpot(7, 9),
    FlSpot(8, 1),
    FlSpot(9, 0),
  ];
  // Default intake data template
  final List<Map<String, dynamic>> intakeData = [
    {'time': '11am - 2pm', 'amount': 1000, 'isActive': false, 'value': 1.0},
    {'time': '4pm - now', 'amount': 900, 'isActive': false, 'value': (4 / 7)},
    {'time': '2pm - 4pm', 'amount': 700, 'isActive': false, 'value': 3 / 7},
    {'time': '6am - 8am', 'amount': 600, 'isActive': false, 'value': 2 / 7},
    {'time': '9am - 11am', 'amount': 500, 'isActive': false, 'value': 1 / 7},
  ];
  // Initialize controller
  Future<void> init() async {
    await loadIntakeData(); // Try to load existing data first
    // If no data was loaded, initialize with defaults
    await initDrinkWater();
    if (intakeDataNew.isEmpty) {
      intakeDataNew = List.from(intakeData.map((e) => Map<String, dynamic>.from(e)));
      await saveDateWater();
    }

    // Load user details from Firestore
    await getUserDetails();

    // Load user data from SharedPreferences and update weight/height if available
    final String? userData = PreferenceManager().getString('user');
    if (userData != null && userData.isNotEmpty) {
      final decodedData = jsonDecode(userData);

      final UserModel user = UserModel.fromJson(decodedData);
      weight = user.weight;
      height = user.height;
      calculateBmi();


    }

    notifyListeners();
  }

  // Initialize drink water tracking
  Future<void> initDrinkWater() async {
    final DateTime dataNow = DateTime.now();

    // Get the last reset date from preferences
    final String? lastResetDateStr = PreferenceManager().getString('lastResetDate');

    // Check if we need to reset water data
    bool shouldReset = false;

    if (lastResetDateStr == null) {
      // First time app is run, set today as reset date
      shouldReset = true;
    } else {
      try {
        final DateTime lastResetDate = DateTime.parse(lastResetDateStr);
        // Reset if it's a new day and after 5 AM
        if (dataNow.day != lastResetDate.day ||
            (dataNow.day == lastResetDate.day &&
                lastResetDate.hour < 5 &&
                dataNow.hour >= 5)) {
          shouldReset = true;
        }
      } catch (e) {
        debugPrint('Error parsing last reset date: $e');
        shouldReset = true;
      }
    }

    if (shouldReset) {
      // Reset water tracking data
      await PreferenceManager().remove('startWater');
      await PreferenceManager().remove('intakeData');

      // Update the last reset date
      await PreferenceManager().setString('lastResetDate', dataNow.toIso8601String());
    }
  }

  // Save intake data to preferences
  Future<void> saveDateWater() async {
    await PreferenceManager().setString('intakeData', jsonEncode(intakeDataNew));
    await PreferenceManager().setDouble('startWater', startWater ?? 0);
  }

  // Load intake data from preferences
  Future<void> loadIntakeData() async {
    final String? data = PreferenceManager().getString('intakeData');
    final double? lastDrinkWater = PreferenceManager().getDouble('startWater');
    if (data != null && data.isNotEmpty) {
      try {
        final decodedData = jsonDecode(data);
        if (decodedData is List) {
          intakeDataNew = decodedData
              .where((item) => item is Map<String, dynamic>)
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
          if (intakeDataNew.isEmpty) {
            intakeDataNew =
                List.from(intakeData.map((e) => Map<String, dynamic>.from(e)));
          }
          startWater = lastDrinkWater ?? 0;
          notifyListeners();
        } else {
          intakeDataNew =
              List.from(intakeData.map((e) => Map<String, dynamic>.from(e)));
          startWater = 0;
          notifyListeners();
        }
      } catch (e) {
        debugPrint('Error loading intake data: $e');
        intakeDataNew = List.from(intakeData.map((e) => Map<String, dynamic>.from(e)));
        startWater = 0;
        notifyListeners();
      }
    } else {
      startWater = 0;
    }
  }

  // Calculate BMI
  void calculateBmi() {
    if (weight == null || height == null || weight! <= 0 || height! <= 0) {
      type = 'Invalid Input';
      bmi = null;
    } else {
      // Convert height from cm to meters before calculating BMI
      final double heightInMeters = height! / 100;
      bmi = weight! / (heightInMeters * heightInMeters);
      if (bmi! < 18.5) {
        type = 'Underweight';
      } else if (bmi! >= 18.5 && bmi! <= 24.9) {
        type = 'Normal Weight';
      } else if (bmi! >= 25 && bmi! <= 29.9) {
        type = 'Overweight';
      } else {
        type = 'Obese';
      }
    }
    notifyListeners();
  }

  // Update water intake status
  void updateWater(int size) {
    // Reset all active states
    for (var item in intakeDataNew) {
      item['isActive'] = false;
    }

    // Set active states based on size
    if (size == 500) {
      intakeDataNew[4]['isActive'] = true;
      startWater = intakeDataNew[4]['value'];
    } else if (size == 600) {
      intakeDataNew[4]['isActive'] = true;
      intakeDataNew[3]['isActive'] = true;
      startWater = intakeDataNew[3]['value'];
    } else if (size == 700) {
      intakeDataNew[4]['isActive'] = true;
      intakeDataNew[3]['isActive'] = true;
      intakeDataNew[2]['isActive'] = true;
      startWater = intakeDataNew[2]['value'];
    } else if (size == 900) {
      intakeDataNew[4]['isActive'] = true;
      intakeDataNew[3]['isActive'] = true;
      intakeDataNew[2]['isActive'] = true;
      intakeDataNew[1]['isActive'] = true;
      startWater = intakeDataNew[1]['value'];
    } else if (size == 1000) {
      for (var item in intakeDataNew) {
        item['isActive'] = true;
      }
      startWater = intakeDataNew[0]['value'];
    }
    saveDateWater(); // Persist changes
    notifyListeners();
  }

  // Load user details from Firestore
  Future<void> getUserDetails() async {
    final String? userId = AuthService().getUser();
    if (userId != null) {
      final Map<String, dynamic>? userData =
      await FirestoreService().getUserFromCollection(userId: userId);
      if (userData != null) {
        await PreferenceManager().setString(StorageKey.firstName,userData['username']);
        await PreferenceManager().setString(StorageKey.lastname,userData['lastname']);
        final user = UserModel(
          firstName: userData['username'],
          lastName: userData['lastname'],
          birthday: userData['birth'].toString(),
          height: userData['height']?.toDouble(),
          weight: userData['weight']?.toDouble(),
          gender: userData['gender'],
        );
        // Store in SharedPreferences
        await PreferenceManager().setString('user', jsonEncode(user.toJson()));
      }
    }
  }
  String? get username => PreferenceManager().getString(StorageKey.firstName) ?? 'Gust';

  // Reset to default intake data
  Future<void> resetIntakeData() async {
    intakeDataNew = List.from(intakeData.map((e) => Map<String, dynamic>.from(e)));
    startWater = 0;
    await saveDateWater();
    notifyListeners();
  }

  // Save last activity
  Future<void> saveLastActivity(int size) async {
    try {
      final String? savedData = PreferenceManager().getString(StorageKey.lastActivity);
      List<Map<String, dynamic>> activities = [];
      var uuid = Uuid();
      // Create new activity
      final newActivity = ActivityModel(
        sourceImage: 'assets/activity/drinkWater.svg',
        title: 'Drink $size Water',
        subTitle: 'just 1 s',
        id: uuid.v4(),
      ).toMap();

      // Handle existing data (could be List or Map)
      if (savedData != null && savedData.isNotEmpty) {
        final dynamic decoded = jsonDecode(savedData);

        if (decoded is List) {
          // Existing data is a List
          activities = List<Map<String, dynamic>>.from(decoded);
        } else if (decoded is Map) {
          // Existing data is a single Map (old format)
          activities = [Map<String, dynamic>.from(decoded)];
        }
      }

      // Add new activity at beginning
      activities.insert(0, newActivity);

      // Keep only last 4 activities
      if (activities.length > 4) {
        activities = activities.sublist(0, 4);
      }

      // Save as JSON array
      await PreferenceManager().setString(
        StorageKey.lastActivity,
        jsonEncode(activities),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving last activity: $e');
      // Optional: Clear corrupt data
      await PreferenceManager().remove(StorageKey.lastActivity);
    }
  }

    //await PreferenceManager().setString(StorageKey.lastActivity, -)
  }
