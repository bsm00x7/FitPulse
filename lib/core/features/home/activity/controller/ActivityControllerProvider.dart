import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fitness/core/constant/storeg_key.dart';
import 'package:fitness/service/preference_manager.dart';

class ActivityControllerProvider with ChangeNotifier {
  List<Map<String, dynamic>> lastActivity = [];
  double? waterSize ;
  int? steps ;
  ActivityControllerProvider() {
    loadLastFourActivities();
    loadLastDataTarget();
  }
  void loadLastDataTarget() async {
    double? loadedWater = PreferenceManager().getDouble(StorageKey.waterSize);
    int? loadedSteps = PreferenceManager().getInt(StorageKey.steps);
    waterSize = (loadedWater != null && loadedWater >= 0 && loadedWater <= 10) ? loadedWater : 4.0;
    steps = (loadedSteps != null && loadedSteps >= 500 && loadedSteps <= 10000) ? loadedSteps : 2500;
    notifyListeners();
  }
  Future<void> loadLastFourActivities() async {
    final data = PreferenceManager().getString(StorageKey.lastActivity);
    if (data != null) {
      try {
        final List<dynamic> decoded = jsonDecode(data);
        lastActivity = List<Map<String, dynamic>>.from(decoded);
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading last activities: $e');
      }
    }
  }

  String convertDate(DateTime timestamp) {
    return '${timestamp.year}-${timestamp.month}-${timestamp.day}-${timestamp.hour}:${timestamp.minute}:${timestamp.second} ';
  }

  void saveLastActivity(int index) {
    try {
      PreferenceManager().setString(
        StorageKey.lastActivity,
        jsonEncode(lastActivity),
      );
      loadLastFourActivities();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading last activities: $e');
    }
  }
}
