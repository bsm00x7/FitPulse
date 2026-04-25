import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../home/controller/home_controller.dart';
import '../home/home.dart';
import '../profile/profile.dart';
import '../walking/walking_screen.dart';
import '../workout/work_out.dart';
import '../nutrition/nutrition_screen.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({super.key});
  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
  final List<Widget> pages = [
    Home(),
    WorkoutScreen(),
    NutritionScreen(),
    WalkingScreen(),
    Profile(),
  ];
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    // Initialize the HomeController when the navigation bar is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeController>(context, listen: false).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: pages[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 10),
        currentIndex: _currentIndex,
        onTap: (int value) {
          setState(() {
            _currentIndex = value;
          });
        },
        selectedItemColor: theme.colorScheme.onSecondary,
        unselectedItemColor: theme.colorScheme.onSurface.withValues(alpha: .6),
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/button_navigation/Home.svg',
              height: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/button_navigation/Activity.svg',
              height: 24,
            ),
            label: 'Work Out',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant, size: 24),
            label: 'Nutrition',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/button_navigation/walking.svg',
              height: 28,
            ),
            label: 'Walking',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/button_navigation/Profile.svg',
              height: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
