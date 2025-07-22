import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import '../../../model/signup_model.dart';
import '../../../service/auth_service.dart';
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
        final RegisterModel newUser = RegisterModel(
          firstname: firstname.value.text.trim(),
          lastname: lastname.value.text.trim(),
          email: emailController.value.text.trim(),
          password: passwordController.value.text.trim(),
        );
        final registerSuccess = await AuthService().register(context ,newUser);
        if (registerSuccess?.user != null) {
          _SnackBar(
            context,
            "Registration Success",
            "Registration Success ",
            ContentType.success,
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Complete()),
            (Route<dynamic> route) => false,
          );
        } else {
          _SnackBar(
            context,
            "Registration Failed",
            "We couldn't complete your registration. Please check your details and try again later.",
            ContentType.failure,
          );
        };

        // TO DO Register Account
        // If Success Navigator on  complete your profile
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
