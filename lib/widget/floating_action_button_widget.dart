

import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatelessWidget {
   const FloatingActionButtonWidget({super.key , required this.onPressed , required this.textLabel});
  final void Function() onPressed;
  final String? textLabel;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => onPressed(),
      backgroundColor: Colors.transparent, // Make FAB transparent to show gradient
      elevation: 0, // Optional: remove shadow for a flatter look
      label: Text(
          textLabel!,
          style: Theme.of(context).textTheme.displayMedium
      ),
    );
  }
}
