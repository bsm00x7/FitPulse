import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';



class HeaderBar extends StatelessWidget {
  const HeaderBar({
    super.key,

    required this.title,
    this.onIcon2Tap,
    required this.onIcon1Tap, // Optional callback for second icon
  });

  final String title;
  final VoidCallback? onIcon2Tap;
  final VoidCallback? onIcon1Tap;

  // Callback for second icon tap

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32, // Slightly larger height for better touch targets
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
       IconButton(onPressed: onIcon1Tap, icon: Icon(FontAwesomeIcons.arrowLeft, size: 22)),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontSize: 20),
          ),
          GestureDetector(
            onTap: onIcon2Tap, // Optional tap handler for second icon
            child: FaIcon(FontAwesomeIcons.ellipsis, size: 22),
          ),
        ],
      ),
    );
  }
}
