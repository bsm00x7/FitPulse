import 'package:fitness/core/featuers/Signup/signup.dart';
import 'package:fitness/core/featuers/login/forgotpassword/forgot_your_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../widget/TextFormFild.dart';
import 'controller/login_page_controller.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Center(
              child: Consumer<LoginController>(
                builder: (context, controller, _) {
                  return Form(
                    key: controller.key,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Hey there,",
                            style: theme.textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Welcome Back",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 30),
                          TextFormFieldWidget(
                            source: 'lib/assets/login/email.svg',
                            hint: 'Email',
                            controller: controller.emailController,
                            errorValidator: 'Please enter a valid email',
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                          ),
                          const SizedBox(height: 16),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              TextFormFieldWidget(
                                source: 'lib/assets/login/Lock.svg',
                                hint: 'Password',
                                controller: controller.passwordController,
                                errorValidator: 'Please enter your password',
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !controller.isPasswordVisible,
                              ),
                              Positioned(
                                top: 20,
                                right: 20,
                                child: GestureDetector(
                                  onTap: controller.togglePasswordVisibility,
                                  child: SvgPicture.asset(
                                    controller.isPasswordVisible
                                        ? 'lib/assets/login/Show-Password.svg'
                                        : 'lib/assets/login/Hide-Password.svg',
                                    width: 24,
                                    height: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ChangeNotifierProvider(
                                        create: (_) => LoginController(),
                                        child: ForgotYourPassword(),
                                      ),
                                ),
                              ),
                              child: Text(
                                "Forgot your password?",
                                style: theme.textTheme.headlineSmall!.copyWith(
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: controller.login,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'lib/assets/login/LoginDor.svg',
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Login",
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Color(0xFFDDDADA),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child: Text(
                                  "Or",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Color(0xFFDDDADA),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildSocialButton(
                                context,
                                asset: 'lib/assets/login/google-logo.svg',
                                onPressed: () {
                                  // Implement Google login
                                },
                              ),
                              const SizedBox(width: 20),
                              _buildSocialButton(
                                context,
                                asset: 'lib/assets/login/facebook 1.svg',
                                onPressed: () {
                                  // Implement Facebook login
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () => Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>Signup(),
                              ), (Route<dynamic> route) => false),

                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don’t have an account yet? ",
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 15,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "Register",
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required String asset,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFDDDADA), width: 1.6),
        ),
        minimumSize: const Size(60, 60),
        backgroundColor: theme.colorScheme.surface,
      ),
      onPressed: onPressed,
      child: SvgPicture.asset(asset, width: 24, height: 24),
    );
  }
}
