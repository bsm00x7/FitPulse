import 'package:flutter/cupertino.dart';

import '../../../../../service/preference_manager.dart';
import '../../../../constant/storeg_key.dart';


class AddTargetControllerProvider with ChangeNotifier {
  double waterSize = PreferenceManager().getDouble(StorageKey.waterSize) ?? 4.0;
  int steps = PreferenceManager().getInt(StorageKey.steps) ?? 2500;

  void incrementWater() {
    if (waterSize < 10) {
      waterSize += 0.5;
      notifyListeners();
    }
  }

  void decrementWater() {
    if (waterSize > 0) {
      waterSize -= 0.5;
      notifyListeners();
    }
  }

  void incrementStep() {
    if (steps < 10000) {
      steps += 500;
      notifyListeners();
    }
  }

  void decrementStep() {
    if (steps > 500) { // Set minimum step goal to 500
      steps -= 500;
      notifyListeners();
    }
  }

  Future<void> save() async {
    await PreferenceManager().setDouble(StorageKey.waterSize, waterSize);
    await PreferenceManager().setInt(StorageKey.steps, steps);
    notifyListeners(); // Notify listeners after saving to ensure UI updates
  }
}