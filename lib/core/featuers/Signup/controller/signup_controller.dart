import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import '../../complete/complete.dart';

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
  }

  Future<void> register(BuildContext context) async {
    if (key.currentState!.validate()) {
      if (isChecked == false) {
        _SnackBar(
          context,
          "warning",
          "Please Accept our Privacy Policy!",
          ContentType.failure,
        );
      } else {
        // TO DO Register Account
        // If Success Navigator on  complete your profile
        final bool _registersucces = true;
        _registersucces==true
            ? Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Complete()), (Route<dynamic> route) => false)

            : _SnackBar(
                context,
                "Registration Failed",
                "We couldn't complete your registration. Please check your details and try again later.",
                ContentType.failure,
              );
      }
    }
  }

  void _SnackBar(
    BuildContext context,
    String title,
    String message,
    contentType,
  ) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,

        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
        contentType: contentType,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
