import 'package:fitness/core/featuers/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../widget/TextFormFild.dart';
import 'controller/signup_controller.dart';
class Signup extends StatelessWidget {
  Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) => SignupController(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Consumer<SignupController>(
              builder: (BuildContext context, value, Widget? child) => Form(
                key: value.key,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hey there,',
                        style: theme.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Create an Account',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormFieldWidget(
                        source: 'assets/signup/Profile.svg',
                        hint: 'First Name',
                        controller: value.firstname,
                        errorValidator: 'Please enter Your First Name',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                      ),
                      const SizedBox(height: 16),
                      TextFormFieldWidget(
                        source: 'assets/signup/Profile.svg',
                        hint: 'Last Name',
                        controller: value.lastname,
                        errorValidator: 'Please enter Your Last Name',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                      ),
                      const SizedBox(height: 16),
                      TextFormFieldWidget(
                        source: 'assets/login/email.svg',
                        hint: 'Email',
                        controller: value.emailController,
                        errorValidator: 'Please enter a valid email',
                        keyboardType: TextInputType.emailAddress,
                        obscureText: false,
                      ),
                      const SizedBox(height: 16),
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextFormFieldWidget(
                            source: 'assets/login/Lock.svg',
                            hint: 'Password',
                            controller: value.passwordController,
                            errorValidator: 'Please enter your password',
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: value.isPasswordVisible,
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: GestureDetector(
                              onTap: value.togglePasswordVisibility,
                              child: SvgPicture.asset(
                                value.isPasswordVisible
                                    ? 'assets/login/Show-Password.svg'
                                    : 'assets/login/Hide-Password.svg',
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Consumer<SignupController>(
                            builder: (BuildContext context, checked, Widget? child)=> Checkbox(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(
                                color: Color(0xffADA4A5),
                                width: 1.2,
                              ),
                              value: checked.isChecked,
                              activeColor: Colors.red,
                              onChanged: (value) {
                                if (value!=null){
                                  checked.changeCheckbox(value);
                                }
                               },
                            ),
                          ),
                          Text(
                            'By continuing you accept our Privacy Policy and \nTerm of Use',
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.displaySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: (){ context.read<SignupController>().register( context: context);},
                        child: Text(
                          'Register',
                          style: theme.textTheme.headlineSmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              thickness: 1.1,
                              color: Color(0xFFDDDADA),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Or',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(

                              thickness: 1.1,
                              color: Color(0xFFDDDADA),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialButton(
                            context,
                            asset: 'assets/login/google-logo.svg',
                            onPressed: () {
                              // Implement Google login
                            },
                          ),
                          const SizedBox(width: 20),
                          _buildSocialButton(
                            context,
                            asset: 'assets/login/facebook 1.svg',
                            onPressed: () {
                              // Implement Facebook login
                            },
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Login())),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 15,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              TextSpan(
                                text: 'Login',
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
