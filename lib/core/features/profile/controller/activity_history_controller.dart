import 'package:fitness/core/constant/storage_key.dart';
import 'package:flutter/foundation.dart';

import '../../../../services_ads_storage_local/preference_manager.dart';

class ActivityHistoryController extends ChangeNotifier {
  final List<String> nameActivity = [];

  ActivityHistoryController() {
    loadLastNameActivity();
  }

  void clear (){
    if (nameActivity.isNotEmpty){
      nameActivity.clear();
      PreferenceManager().remove(StorageKey.lastActivity);
      notifyListeners();
    }

  }
  void loadLastNameActivity() {
      final lastActivity = PreferenceManager().getString(StorageKey.lastActivity);
      if (lastActivity != null && lastActivity.isNotEmpty) {
        nameActivity.clear();
        nameActivity.addAll(lastActivity.split('||'));
        notifyListeners();
      }

  }
  List<String> get activities => List.unmodifiable(nameActivity);

}