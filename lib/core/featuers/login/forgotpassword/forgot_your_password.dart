import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widget/TextFormFild.dart';
import '../controller/login_page_controller.dart';

class ForgotYourPassword extends StatelessWidget {
  const ForgotYourPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loginController = Provider.of<LoginController>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 30,
            right: 30,
            top: 40,
          ),
          child: Form(
            key: loginController.resetFormKey, // Bind to resetFormKey
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Reset Password",
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                TextFormFieldWidget(
                  source: 'lib/assets/login/email.svg',
                  hint: "Email",
                  controller: loginController.resetPasswordController,
                  errorValidator: "Please enter a valid email",
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () async {
                    final sendSuccess = await loginController.sendResetLink(context);
                    if (sendSuccess) {
                      // Navigate back to login screen on success
                      Navigator.pop(context);
                    }
                  },
                  child:  Text(
                    "Send Reset Link",
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}