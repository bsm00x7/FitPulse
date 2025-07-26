import 'package:fitness/core/featuers/home/widgets/boxIcons.dart';
import 'package:flutter/material.dart';
import '../core/featuers/button_navigation_bar/button_navigation_bar.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    super.key,
    required this.svgIcon1,
    required this.svgIcon2,
    required this.title,
    this.onIcon2Tap, // Optional callback for second icon
  });

  final String svgIcon1;
  final String svgIcon2;
  final String title;
  final VoidCallback? onIcon2Tap; // Callback for second icon tap

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32, // Slightly larger height for better touch targets
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const ButtonNavigation()),
                  (Route<dynamic> route) => false,
            ),
            child: Boxicons(source: svgIcon1),
          ),
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .titleMedium ,
          ),
          GestureDetector(
            onTap: onIcon2Tap, // Optional tap handler for second icon
            child: Boxicons(source: svgIcon2),
          ),
        ],
      ),
    );
  }
}