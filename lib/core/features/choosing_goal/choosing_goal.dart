
import 'package:flutter/material.dart';

import 'compoenent/CarouselSlider.dart';
class ChoosingGoal extends StatelessWidget {
   const ChoosingGoal({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CarouselSliderWidget(update: false,),
      ),
    );
  }
}