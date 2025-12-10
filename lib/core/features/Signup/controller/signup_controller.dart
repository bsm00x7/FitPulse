import 'package:flutter/material.dart';
import '../../../../data/services/auth/auth_service.dart';
import '../../../../services_ads_storage_local/preference_manager.dart';
import '../../../constant/storage_key.dart';
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
    PreferenceManager().setString(StorageKey.firstName, firstname.text);
    PreferenceManager().setString(StorageKey.lastname, lastname.text);
     AuthService().register(email: emailController.text.trim(), password: passwordController.text, context: context, username:firstname.text , lastname: lastname.text);
   }

}
