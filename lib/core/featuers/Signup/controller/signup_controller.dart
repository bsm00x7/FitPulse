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

   void register ({ required BuildContext context}){
     AuthService().register(email: emailController.text.trim(), password: passwordController.text, context: context);
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
