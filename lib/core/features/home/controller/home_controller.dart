import 'dart:convert';
import 'package:fitness/core/constant/storage_Key.dart';
import 'package:fitness/data/models/user_model.dart';
import 'package:fitness/data/services/auth/auth_service.dart';
import 'package:fitness/data/services/store_user_information.dart';
import 'package:fitness/service/preference_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../activity/model/activity_model.dart';
class HomeController with ChangeNotifier {
  String? type;
  double? bmi;
  double? weight;
  double? height;
  List<Map<String, dynamic>> intakeDataNew = [];
  double? startWater = 0;
  String? username;
  final double _calories = PreferenceManager().getDouble(StorageKey.calories) ?? 0.0;
  double currentWaterIntake = 0; // in ml
  double get calories => _calories;
  double? get targetWaterToday =>
      PreferenceManager().getDouble(StorageKey.waterSize) ?? 4.0;
  List<Map<String, dynamic>> get intakeData {
    return [
      {'time': '6am - 8am', 'amount': 0, 'isActive': false, 'value': 0.2},
      // 20%
      {'time': '8am - 10am', 'amount': 0, 'isActive': false, 'value': 0.4},
      // 40%
      {'time': '10am - 1pm', 'amount': 0, 'isActive': false, 'value': 0.6},
      // 60%
      {'time': '1pm - 4pm', 'amount': 0, 'isActive': false, 'value': 0.8},
      // 80%
      {'time': '4pm - 8pm', 'amount': 0, 'isActive': false, 'value': 1.0},
      // 100%
    ];
  }

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

  // Initialize controller
  Future<void> init() async {
    await loadIntakeData();
    await initDrinkWater();
    await getUsername();

    if (intakeDataNew.isEmpty) {
      updateIntakeDataAmounts();
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
    final String? lastResetDateStr = PreferenceManager().getString(
      'lastResetDate',
    );
    bool shouldReset = false;

    if (lastResetDateStr == null) {
      shouldReset = true;
    } else {
      try {
        final DateTime lastResetDate = DateTime.parse(lastResetDateStr);
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
      await PreferenceManager().remove('startWater');
      await PreferenceManager().remove('intakeData');
      await PreferenceManager().remove('currentWaterIntake');
      currentWaterIntake = 0;
      await PreferenceManager().setString(
        'lastResetDate',
        dataNow.toIso8601String(),
      );
    } else {
      // Load current water intake
      currentWaterIntake =
          PreferenceManager().getDouble('currentWaterIntake') ?? 0;
    }
  }

  // Save intake data to preferences
  Future<void> saveDateWater() async {
    await PreferenceManager().setString(
      'intakeData',
      jsonEncode(intakeDataNew),
    );
    await PreferenceManager().setDouble('startWater', startWater ?? 0);
    await PreferenceManager().setDouble(
      'currentWaterIntake',
      currentWaterIntake,
    );
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
              .whereType<Map<String, dynamic>>()
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
          if (intakeDataNew.isEmpty) {
            intakeDataNew = List.from(
              intakeData.map((e) => Map<String, dynamic>.from(e)),
            );
          }
          startWater = lastDrinkWater ?? 0;
          notifyListeners();
        } else {
          intakeDataNew = List.from(
            intakeData.map((e) => Map<String, dynamic>.from(e)),
          );
          startWater = 0;
          notifyListeners();
        }
      } catch (e) {

        intakeDataNew = List.from(
          intakeData.map((e) => Map<String, dynamic>.from(e)),
        );
        startWater = 0;
        notifyListeners();
      }
    } else {
      startWater = 0;
    }

    // Load current water intake
    currentWaterIntake =
        PreferenceManager().getDouble('currentWaterIntake') ?? 0;
  }

  // Calculate BMI
  void calculateBmi() {
    if (weight == null || height == null || weight! <= 0 || height! <= 0) {
      type = 'Invalid Input';
      bmi = null;
    } else {
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

  // Update intake amounts based on waterSize
  void updateIntakeDataAmounts() {
    final waterTarget = targetWaterToday ?? 4.0;
    final totalMl = waterTarget * 1000;
    final part = (totalMl / 5).round();

    intakeDataNew = List.from(
      intakeData.map((e) {
        final newItem = Map<String, dynamic>.from(e);
        newItem['amount'] = part;
        return newItem;
      }),
    );

    notifyListeners();
  }

  // Refresh water size when it changes
  void refresh() {
    updateIntakeDataAmounts();
    saveDateWater();
    notifyListeners();

  }

  // Load user details from Firestore
  Future<void> getUserDetails() async {
    final String? userId = AuthService().getUser();
    if (userId != null) {
      final Map<String, dynamic>? userData = await FirestoreService()
          .getUserFromCollection(userId: userId);
      if (userData != null) {
        final user = UserModel(
          firstName: userData['username'],
          lastName: userData['lastname'],
          birthday: userData['birth'].toString(),
          height: userData['height'].toDouble(),
          weight: userData['weight'].toDouble(),
          gender: userData['gender'],
        );
        await PreferenceManager().setString('user', jsonEncode(user.toJson()));
      }
    }
  }

  Future<void> getUsername() async {
    try {
      String? docId = AuthService().getUser();
      if (docId != null) {
        username = await FirestoreService().getUserName(docId);
      }
    } catch (e) {
      rethrow;
    }
  }

  // Reset to default intake data
  Future<void> resetIntakeData() async {
    intakeDataNew = List.from(
      intakeData.map((e) => Map<String, dynamic>.from(e)),
    );
    startWater = 0;
    currentWaterIntake = 0;
    await saveDateWater();
    notifyListeners();
  }

  // Save last activity
  Future<void> saveLastActivity(double amount) async {
    try {
      final String? savedData = PreferenceManager().getString(
        StorageKey.lastActivity,
      );
      List<Map<String, dynamic>> activities = [];
      var uuid = Uuid();

      String actionText = amount > 0
          ? 'Added ${amount.toInt()}ml'
          : 'Removed ${(-amount).toInt()}ml';

      final newActivity = ActivityModel(
        sourceImage: 'assets/activity/drinkWater.svg',
        title: actionText,
        subTitle: 'just now',
        id: uuid.v4(),
      ).toMap();

      if (savedData != null && savedData.isNotEmpty) {
        final dynamic decoded = jsonDecode(savedData);
        if (decoded is List) {
          activities = List<Map<String, dynamic>>.from(decoded);
        } else if (decoded is Map) {
          activities = [Map<String, dynamic>.from(decoded)];
        }
      }

      activities.insert(0, newActivity);
      if (activities.length > 4) {
        activities = activities.sublist(0, 4);
      }

      await PreferenceManager().setString(
        StorageKey.lastActivity,
        jsonEncode(activities),
      );
      notifyListeners();
    } catch (e) {

      await PreferenceManager().remove(StorageKey.lastActivity);
    }
  }

  // Get current water intake percentage
  double get waterProgressPercentage {
    final totalTarget = (targetWaterToday ?? 4.0) * 1000;
    return (currentWaterIntake / totalTarget).clamp(0.0, 1.0);
  }

  // Get current water intake in liters as string
  String get currentWaterLiters {
    return (currentWaterIntake / 1000).toStringAsFixed(2);
  }




  void incrementWater(double amount) {
    currentWaterIntake += amount;
    // Ensure we don't go below 0
    if (currentWaterIntake < 0) {
      currentWaterIntake = 0;
    }

    updateWaterProgress();
    saveLastActivity(amount);
    saveDateWater();
    notifyListeners();
  }

  // NEW: Method to decrement water intake
  void decrementWater(double amount) {
    currentWaterIntake -= amount;
    // Ensure we don't go below 0
    if (currentWaterIntake < 0) {
      currentWaterIntake = 0;
    }

    updateWaterProgress();
    saveLastActivity(-amount);
    saveDateWater();
    notifyListeners();
  }

  // NEW: Update water progress based on current intake
  void updateWaterProgress() {
    // Reset all active states
    for (var item in intakeDataNew) {
      item['isActive'] = false;
    }

    // Get total water target in ml
    final totalTarget = (targetWaterToday ?? 4.0) * 1000;
    final percentage = currentWaterIntake / totalTarget;

    // Ensure we have data to work with
    if (intakeDataNew.isEmpty) return;

    // Calculate how many segments should be active based on percentage
    int activeSegments = 0;
    if (percentage > 0) {
      activeSegments = (percentage * 5).ceil(); // 5 segments total
      activeSegments = activeSegments.clamp(1, 5); // At least 1, max 5
    }

    // Activate segments from bottom to top (index 4 to 0)
    for (int i = 0; i < activeSegments && i < intakeDataNew.length; i++) {
      int segmentIndex = intakeDataNew.length - 1 - i; // Start from last index
      intakeDataNew[segmentIndex]['isActive'] = true;
    }

    // Update startWater for the progress bar
    if (activeSegments > 0) {
      startWater = percentage.clamp(0.0, 1.0);
    } else {
      startWater = 0.0;
    }

  }


}
