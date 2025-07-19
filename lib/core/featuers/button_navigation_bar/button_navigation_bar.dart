import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../activity/activity.dart';
import '../home/home.dart';
import '../profile/profile.dart';
import '../search/search.dart';

class ButtonNavigation extends StatefulWidget {
  const ButtonNavigation({super.key});

  @override
  State<ButtonNavigation> createState() => _ButtonNavigationState();
}

class _ButtonNavigationState extends State<ButtonNavigation> {
  final List<Widget> pages = const [Home(), Activity(), Search(), Profile()];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: pages[_currentIndex],
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
              "lib/assets/button_navigation/Home.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 0 ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "lib/assets/button_navigation/Activity.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 1 ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "lib/assets/button_navigation/Search.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 2 ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface.withOpacity(0.6),
                BlendMode.srcIn,
              ),
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "lib/assets/button_navigation/Profile.svg",
              colorFilter: ColorFilter.mode(
                _currentIndex == 3 ? theme.colorScheme.onSecondary : theme.colorScheme.onSurface.withOpacity(0.6),
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