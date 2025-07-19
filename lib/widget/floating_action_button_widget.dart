

import 'package:flutter/material.dart';

class FloatingActionButtonWidget extends StatelessWidget {

   FloatingActionButtonWidget({super.key , required this.onPressed , required this.textlabel});
  Function onPressed;
  String? textlabel ;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => onPressed(),
      backgroundColor: Colors.transparent, // Make FAB transparent to show gradient
      elevation: 0, // Optional: remove shadow for a flatter look
      label: Text(
          textlabel!,
          style: Theme.of(context).textTheme.displayMedium
      ),
    );
  }
}
