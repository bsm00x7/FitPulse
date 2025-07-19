import 'package:fitness/core/featuers/choosing_goal/choosing_goal.dart';
import 'package:flutter/material.dart';

class CompleteController with ChangeNotifier {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController gender = TextEditingController();
  final TextEditingController birth = TextEditingController(); // Fixed typo in variable name
  final TextEditingController weight = TextEditingController();
  final TextEditingController height = TextEditingController();

  Future<void> pickDate(BuildContext context) async {
    // showDatePicker returns a Future<DateTime?>, so we need to await it
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1970, 9, 7),
      lastDate: DateTime.now(),
    );

    // Update the TextEditingController if a date is picked
    if (pickedDate != null) {
      birth.text = pickedDate.toString().split(' ')[0]; // Format date as needed
      notifyListeners(); // Notify listeners of the change
    }
  }

  // Optional: Clean up controllers when the controller is disposed
  @override
  void dispose() {
    gender.dispose();
    birth.dispose();
    super.dispose();
  }
  void nextComplete(BuildContext context) {
    if (key.currentState!.validate() ?? true ){
      // TO DO Save Data in local Storage
      // Navigator Page Choosing  Goal
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChoosingGoal()));
    }

  }
}