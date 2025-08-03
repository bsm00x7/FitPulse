// ignore_for_file: use_build_context_synchronously

import 'package:fitness/core/constant/storage_Key.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Added for DateFormat
import 'package:provider/provider.dart'; // Added for Provider
import '../../../../data/services/auth/auth_service.dart';
import '../../../../data/services/store_user_information.dart';
import '../../../../service/preference_manager.dart';
import '../../choosing_goal/choosing_goal.dart';

class CompleteController with ChangeNotifier {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String? selectedGender;
  final TextEditingController birth = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController height = TextEditingController();
  
  void setGender(String gender) {
    selectedGender = gender;
    notifyListeners();
  }

  Future<void> pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1970, 9, 7),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      birth.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      notifyListeners();
    }
  }
  Future<void> nextComplete(BuildContext context) async {
    final user = Provider.of<AuthService>(context, listen: false).getUser();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user logged in'))
      );
      return;
    }

    if (key.currentState!.validate() &&
        birth.text.isNotEmpty &&
        selectedGender != null) {
      try {
        final firestoreService = Provider.of<FirestoreService>(
          context,
          listen: false,
        );

        final birthDate = DateTime.parse(birth.text);
        final weightValue = double.parse(weight.text.trim());
        final heightValue = double.parse(height.text.trim());

        // Get user details with null checking
        final String? userName = PreferenceManager().getString(StorageKey.firstName);
        final String? lastName = PreferenceManager().getString(StorageKey.lastname);

        // Check if userName and lastName are not null
        if (userName == null || lastName == null) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User name information is missing'))
          );
          return;
        }

        await firestoreService.saveUserDetails(
          user,
          userName, // Now safe to use without !
          lastName, // Now safe to use without !
          selectedGender!,
          birthDate,
          weightValue,
          heightValue,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChoosingGoal()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save details: $e'))
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields correctly')),
      );
    }
  }
  @override
  void dispose() {
    birth.dispose();
    weight.dispose();
    height.dispose();
    super.dispose();
  }
}
