import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../model/login.dart';
import '../../../service/auth_service.dart';
import '../../complete/complete.dart';

class LoginController extends ChangeNotifier {
  // Form keys for login and password reset forms
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();

  // Controllers for text input fields
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();

  // State for password visibility toggle
  bool _isPasswordVisible = false;

  // Getter for password visibility
  bool get isPasswordVisible => _isPasswordVisible;

  /// Toggles the visibility of the password field
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  /// Attempts to log in the user with the provided credentials
  Future<void> login(BuildContext context) async {
    if (loginFormKey.currentState?.validate() != true) {
      return; // Early return if form validation fails
    }

    try {
      final loginModel = LoginModel(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      final userCredential = await AuthService().login(context, loginModel);
      if (userCredential.user != null) {
        // Navigate to the Complete screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Complete()),
        );
      }
    } catch (e) {
      // Error handling is managed in AuthService (SnackBar shown there)
      debugPrint('Login failed: $e'); // Use debugPrint for logging
    }
  }

  /// Sends a password reset link to the provided email
  Future<bool> sendResetLink(BuildContext context) async {
    if (resetFormKey.currentState?.validate() != true) {
      return false; // Early return if form validation fails
    }

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
      debugPrint('Password reset failed: $e');
      return false;
    } finally {
      notifyListeners(); // Notify listeners only after operation completes
    }
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    resetPasswordController.dispose();
    super.dispose();
  }
}