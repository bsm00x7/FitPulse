import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/core/theme/light_theme.dart';
import 'package:fitness/services_ads_storage_local/coin_service.dart';
import 'package:fitness/services_ads_storage_local/preference_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/features/button_navigation_bar/button_navigation_bar.dart';
import 'core/features/home/controller/home_controller.dart';
import 'core/features/onboarding/controller/navigator_controller.dart';
import 'core/features/onboarding/welcome_screen.dart';
import 'core/features/workout/subScreen/controller_shared_screen/controller_sub_screen.dart';
import 'core/features/nutrition/controller/nutrition_controller.dart';
import 'data/services/auth/auth_service.dart';
import 'data/services/store_user_information.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceManager().init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth.instance.setLanguageCode('en');
  await MobileAds.instance.initialize();
  await CoinService().initialize();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ControllerSubScreen()),
        ChangeNotifierProvider(create: (_) => NavigatorController()),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => FirestoreService()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => CoinService()),
        ChangeNotifierProvider(create: (_) => NutritionController()),
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
            return snapshot.hasData
                ? const ButtonNavigation()
                : const WelcomeScreen();
          },
        ),
      ),
    );
  }
}
