import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fitness/core/constant/storeg_key.dart';
import 'package:fitness/core/features/activity/model/activity_model.dart';
import 'package:fitness/service/preference_manager.dart';

class ActivityControllerProvider with ChangeNotifier {
  List<Map<String, dynamic>> lastActivity = [];

  ActivityControllerProvider() {
    loadLastFourActivities();
  }

  Future<void> loadLastFourActivities() async {
    final data = PreferenceManager().getString(StorageKey.lastActivity);
    if (data != null) {
      try {
        final List<dynamic> decoded = jsonDecode(data);
        lastActivity = decoded
            .map((e) => ActivityModel.fromMap(Map<String, dynamic>.from(e)).toMap())
            .toList();

        notifyListeners();
      } catch (e) {
        debugPrint('Error loading last activities: $e');
      }
    }
  }

  void saveActivities(List<Map<String, String>> activities) {
    lastActivity = activities;
    final encoded = jsonEncode(activities);
    PreferenceManager().setString(StorageKey.lastActivity, encoded);
    notifyListeners();
  }
}