import 'dart:async';
import 'dart:convert';

import 'package:fitness/service/preferanceManger.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeController with ChangeNotifier {
  String? type;
  double? bmi;
  double? weight = 18; // kg
  double? height = 199; // meters
  // Working intake data that gets saved/loaded
  List<Map<String, dynamic>> intakeDataNew = [];

  // Initial water level
  double? startWater = 0;
  // graph of Activity status
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
    {"time": "11am - 2pm", "amount": 1000, "isActive": false, "value": 1.0},
    {"time": "4pm - now", "amount": 900, "isActive": false, "value": 4 / 5},
    {"time": "2pm - 4pm", "amount": 700, "isActive": false, "value": 3 / 4},
    {"time": "6am - 8am", "amount": 600, "isActive": false, "value": 2 / 5},
    {"time": "9am - 11am", "amount": 500, "isActive": false, "value": 1 / 5},
  ];

  initDrinkWater()async{
    DateTime dataNow = DateTime.now();
    if(dataNow.hour>=5){
      await PreferenceManager().remove("startWater");
      await PreferenceManager().remove("intakeData");

    }
  }
  // Initialize controller
  Future<void> init() async {
    await loadIntakeDate(); // Try to load existing data first
    // If no data was loaded, initialize with defaults
    await initDrinkWater();
    if (intakeDataNew.isEmpty) {
      intakeDataNew = List.from(intakeData.map((e) => Map<String, dynamic>.from(e)));
      await saveDateWater();
    }

    notifyListeners();
  }

  // Save intake data to preferences
  Future<void> saveDateWater() async {
    await PreferenceManager().setString("intakeData", jsonEncode(intakeDataNew));
    await PreferenceManager().setDouble("startWater", startWater?? 0);
  }

  // Load intake data from preferences
  Future<void> loadIntakeDate() async {
    final String? data = PreferenceManager().getString("intakeData");
    final double? lastDrinkWater = PreferenceManager().getDouble("startWater") ?? 0;
    if (data != null && data.isNotEmpty ) {
      try {
        final decodedData = jsonDecode(data);
        if (decodedData is List) {
          intakeDataNew = List<Map<String, dynamic>>.from(
              decodedData.map((item) => Map<String, dynamic>.from(item))
          );
        }
      } catch (e) {
        print("Error loading intake data: $e");
        // Fallback to default data if loading fails
        intakeDataNew = List.from(intakeData.map((e) => Map<String, dynamic>.from(e)));
      }
    }
    if (lastDrinkWater!=null){
      startWater = lastDrinkWater;
    }
    notifyListeners();
  }

  // Calculate BMI
  void calculateBmi() {
    if (weight == null || height == null || weight! <= 0 || height! <= 0) {
      type = "Invalid Input";
      bmi = null;
    } else {
      bmi = weight! / (height! * height!);
      if (bmi! < 18.5) {
        type = "Underweight";
      } else if (bmi! >= 18.5 && bmi! <= 24.9) {
        type = "Normal Weight";
      } else if (bmi! >= 25 && bmi! <= 29.9) {
        type = "Overweight";
      } else {
        type = "Obese";
      }
    }
    notifyListeners();
  }

  // Update water intake status
  void updateWater(int size) {
    // Reset all active states
    for (var item in intakeDataNew) {
      item["isActive"] = false;
    }

    // Set active states based on size
    if (size == 500) {
      intakeDataNew[4]["isActive"] = true;
      startWater = intakeDataNew[4]["value"];
    } else if (size == 600) {
      intakeDataNew[4]["isActive"] = true;
      intakeDataNew[3]["isActive"] = true;
      startWater = intakeDataNew[3]["value"];
    } else if (size == 700) {
      intakeDataNew[4]["isActive"] = true;
      intakeDataNew[3]["isActive"] = true;
      intakeDataNew[2]["isActive"] = true;
      startWater = intakeDataNew[2]["value"];
    } else if (size == 900) {
      intakeDataNew[4]["isActive"] = true;
      intakeDataNew[3]["isActive"] = true;
      intakeDataNew[2]["isActive"] = true;
      intakeDataNew[1]["isActive"] = true;
      startWater = intakeDataNew[1]["value"];
    } else if (size == 1000) {
      for (var item in intakeDataNew) {
        item["isActive"] = true;
      }
      startWater = intakeDataNew[0]["value"];
    }
    saveDateWater(); // Persist changes
    notifyListeners();
  }

  // Reset to default intake data
  Future<void> resetIntakeData() async {
    intakeDataNew = List.from(intakeData.map((e) => Map<String, dynamic>.from(e)));
    await saveDateWater();
    notifyListeners();
  }
}