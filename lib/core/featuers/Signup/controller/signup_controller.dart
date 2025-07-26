
import 'package:flutter/material.dart';

import '../../../../data/services/auth/auth_service.dart';
class SignupController extends ChangeNotifier {
  bool isPasswordVisible = true;
  bool isChecked = false;
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController firstname = TextEditingController();
  final TextEditingController lastname = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  bool? changeCheckbox(bool value) {
    isChecked = value;

    notifyListeners();
    return null;
  }

   void register ({ required BuildContext context}){

     AuthService().register(email: emailController.text.trim(), password: passwordController.text, context: context, username:firstname.text , lastname: lastname.text);
   }

}
