
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Added for DateFormat
import 'package:provider/provider.dart'; // Added for Provider
import '../../../service/auth_service.dart';
import '../../../service/store_user_information.dart';
import '../../choosing_goal/choosing_goal.dart';


class CompleteController with ChangeNotifier {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController gender = TextEditingController();
  final TextEditingController birth = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController height = TextEditingController();

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
        SnackBar(content: Text('No user logged in')),
      );
      return;
    }

    if (key.currentState!.validate() && birth.text.isNotEmpty) {
      try {
        final firestoreService = Provider.of<FirestoreService>(context, listen: false);
        final birthDate = DateTime.parse(birth.text); // Parse string to DateTime
        final weightValue = double.parse(weight.text.trim()); // Parse string to double
        final heightValue = double.parse(height.text.trim()); // Parse string to double

        await firestoreService.saveUserDetails(
          user.uid,
          gender.text.trim(),
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
          SnackBar(content: Text('Failed to save details: $e')),
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
    gender.dispose();
    birth.dispose();
    weight.dispose();
    height.dispose();
    super.dispose();
  }
}