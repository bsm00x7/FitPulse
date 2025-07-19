


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widget/TextFormFild.dart';
import '../controller/login_page_controller.dart';

class ForgotYourPassword extends StatelessWidget {
  const ForgotYourPassword({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 30,
            right: 30,
            top: 40,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Reset Password",
                style: theme.textTheme.titleMedium
              ),
              const SizedBox(height: 20),
              Consumer<LoginController>(
                builder: (context, controller, _) => Column(
                  children: [
                    TextFormFieldWidget(
                      source: 'lib/assets/login/email.svg',
                      hint: "Email",
                      controller: controller.resetPasswordController,
                      errorValidator: "Please enter a valid email",
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
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
                      onPressed:(){
                        controller.sendResetLink;

                      },
                      child: controller.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        "Send Reset Link",
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
