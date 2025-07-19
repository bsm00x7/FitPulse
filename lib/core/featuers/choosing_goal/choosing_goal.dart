import 'package:fitness/core/featuers/choosing_goal/compoenent/CarsouelSlider.dart';
import 'package:flutter/material.dart';
class ChoosingGoal extends StatelessWidget {
   const ChoosingGoal({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CarouselSliderWidget(),
      ),
    );
  }
}