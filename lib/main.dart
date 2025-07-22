import 'package:firebase_core/firebase_core.dart';
import 'package:fitness/core/featuers/onboarding/welcom_screen.dart';
import 'package:fitness/core/theme/light_theme.dart';
import 'package:fitness/service/preferanceManger.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constant/StoregKey.dart';
import 'core/featuers/button_navigation_bar/button_navigation_bar.dart';
import 'core/featuers/onboarding/controller/navigator_controller.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceManager().init();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final bool FirstTime = PreferenceManager().getbool(StoregKey.FirstTime) ?? true;
  runApp(MyApp(FirstTime: FirstTime,));
}
class MyApp extends StatelessWidget {
  final bool FirstTime;
  const MyApp({super.key, required this.FirstTime});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return NavigatorController();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fitness Application',
        theme:lightTheme,
        themeMode: ThemeMode.light,
        home: FirstTime ? ButtonNavigation() :WelcomeScreen(),
      ),
    );
  }
}


