import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController resetPasswordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  Future<void> login() async {
    if (key.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 2));
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendResetLink() async {
    if (key.currentState!.validate()) {
      isLoading = true;
      notifyListeners();
      // Simulate sending reset link (replace with actual logic)
      await Future.delayed(const Duration(seconds: 2));
      isLoading = false;

      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    resetPasswordController.dispose();
    super.dispose();
  }
}