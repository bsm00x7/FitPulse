import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:fitness/core/constant/storeg_key.dart';
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
        lastActivity = List<Map<String, dynamic>>.from(decoded);
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading last activities: $e');
      }
    }
  }

  String convertDate (DateTime timestamp){

    return '${timestamp.year}-${timestamp.month}-${timestamp.day}-${timestamp.hour}:${timestamp.minute}:${timestamp.second} ';

  }

  void saveLastActivity(int index) {

      try {
        PreferenceManager().setString(StorageKey.lastActivity , jsonEncode(lastActivity));
        loadLastFourActivities();
        notifyListeners();
      } catch (e) {
        debugPrint('Error loading last activities: $e');
      }
    }

  }

