
import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  final Widget widget;
  const ContainerWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return    Container(
        decoration: BoxDecoration(

          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      child: widget,
        );
  }
}
