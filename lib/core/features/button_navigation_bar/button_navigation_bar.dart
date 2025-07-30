
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../activity/activity.dart';
import '../home/controller/home_controller.dart';
import '../home/home.dart';
import '../profile/profile.dart';
import '../walking/walking_screen.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({super.key});

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}
class _ButtonNavigationState extends State<ButtonNavigation> {
  final List<Widget> pages = [
    Home(),
    Activity(),

    WalkingScreen(),
    Profile()
  ];
  int _currentIndex = 3;
  
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
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30 , vertical: 10),
        child: pages[_currentIndex],
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        selectedLabelStyle : TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600
        ),
        currentIndex: _currentIndex,
        onTap: (int value) {
          setState(() {
            _currentIndex = value;
          });
        },
        selectedItemColor: theme.colorScheme.onSecondary, // Color for selected item (label and icon)
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/button_navigation/Home.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/button_navigation/Activity.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/button_navigation/walking.svg' ,height: 28,
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Walking',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/button_navigation/Profile.svg',
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}