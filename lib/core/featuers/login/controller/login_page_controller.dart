import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../model/login.dart';
import '../../../service/auth_service.dart';
import '../../complete/complete.dart';

class LoginController extends ChangeNotifier {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetFormKey = GlobalKey<FormState>(); // Separate key for reset form
  bool isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();
  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }


  Future<void> login(BuildContext context) async {
    if (loginFormKey.currentState?.validate() ?? false) {
      notifyListeners();

      try {
        final user = LoginModel(
          email: emailController.text.trim(),
          password: passwordController.text,
        );
        final userCredential = await AuthService().login(context, user);
        if (userCredential.user != null) {
          // Delay for UI feedback (optional, as AuthService already shows SnackBar)
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => Complete()));
          // Navigate to the next screen (e.g., home screen)
          // Example: Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        // Error is already shown via SnackBar in AuthService
        print('Login failed: $e');
      } finally {
        notifyListeners();
      }
    } else {
      notifyListeners();
      // Optionally show a SnackBar for validation failure

    }
  }

  Future<bool> sendResetLink(BuildContext context) async {
    if (resetFormKey.currentState?.validate() ?? false) {
      try {
        final success = await AuthService().forgetPassword(
          context: context,
          email: resetPasswordController.text.trim(),
        );
        if (success) {
          resetPasswordController.clear();
        }
        return success;
      } catch (e) {
        return false;
      } finally {
        notifyListeners(); // Notify listeners once after operation
      }
    }
    return false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    resetPasswordController.dispose();
    super.dispose();
  }
}