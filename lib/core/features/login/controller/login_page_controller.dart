import 'package:flutter/material.dart';
import '../../../../data/services/auth/auth_service.dart';
import '../../choosing_goal/choosing_goal.dart';

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

  void loginUser(BuildContext context) async {
    AuthService auth = AuthService();
    if (await auth.loginAuth(
          email: emailController.text,
          password: passwordController.text,
          context: context,
        ) !=
        false) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ChoosingGoal()), (Route<dynamic> route) => false
      );

    }

    notifyListeners();
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
