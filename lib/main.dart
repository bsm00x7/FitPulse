import 'package:firebase_auth/firebase_auth.dart';


import 'package:fitness/core/theme/light_theme.dart';

import 'package:fitness/service/preference_manager.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/features/button_navigation_bar/button_navigation_bar.dart';
import 'core/features/home/controller/home_controller.dart';
import 'core/features/onboarding/controller/navigator_controller.dart';
import 'core/features/onboarding/welcome_screen.dart';
import 'core/features/workout/controller/work_out_controller.dart';
import 'data/services/auth/auth_service.dart';
import 'data/services/store_user_information.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize PreferenceManager
  await PreferenceManager().init();

  // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkOutControllerProvider()),
        ChangeNotifierProvider(create: (_) => NavigatorController()),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FirestoreService()),
        ChangeNotifierProvider(create: (_) => HomeController())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fitness Application',
        theme: lightTheme,
        themeMode: ThemeMode.light,
        home: StreamBuilder<User?>(
          stream: AuthService().authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // If user is logged in, show ButtonNavigation; otherwise, show WelcomeScreen
            return snapshot.hasData ? const ButtonNavigation() : const WelcomeScreen();
          },
        ),
      ),
    );
  }
}