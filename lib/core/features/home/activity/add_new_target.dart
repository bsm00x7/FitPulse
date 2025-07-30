import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../widget/header_bar.dart';
import 'controller/add_new_targets_controller.dart';

class AddNewTarget extends StatelessWidget {
  const AddNewTarget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.read<AddTargetControllerProvider>();
    return Scaffold(
      floatingActionButton: SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width * 0.90,
        child: FloatingActionButton(
          onPressed:(){
            controller.save();
            Navigator.pop(context);
          },
          child: Text(
            'Save',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeaderBar(title: 'Add New Target', onIcon1Tap: () {Navigator.pop(context);  },),
                SizedBox(height: 40),
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF78B9B5).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              FontAwesomeIcons.glassWater,
                              color: Colors.blueAccent,
                              size: 60,
                            ),
                            Selector<AddTargetControllerProvider, double>(
                              selector: (context, provider) =>
                                  provider.waterSize,
                              builder: (context, value, child) {
                                return Text(
                                  '$value L',
                                  style: theme.textTheme.titleMedium,
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(FontAwesomeIcons.circlePlus),
                              onPressed: controller.incrementWater,
                            ),
                            SizedBox(width: 10),
                            SizedBox(
                              height: 40,
                              width: 100,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary.withValues(
                                    alpha: 0.6,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Center(
                                  child: Text(
                                    '500 ml',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              onPressed: controller.decrementWater,
                              icon: Icon(FontAwesomeIcons.circleMinus),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF78B9B5).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              'assets/activity/boots 1.svg',
                              width: 60,
                              height: 60,
                            ),
                            Selector<AddTargetControllerProvider, int>(
                              selector: (context, provider) => provider.steps,
                              builder: (context, value, child) {
                                return Text(
                                  '$value',
                                  style: theme.textTheme.titleMedium,
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: controller.incrementStep,
                              icon: Icon(FontAwesomeIcons.circlePlus),
                            ),
                            SizedBox(width: 20),
                            SizedBox(
                              height: 40,
                              width: 100,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary.withValues(
                                    alpha: 0.6,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  shape: BoxShape.rectangle,
                                ),
                                child: Center(
                                  child: Text(
                                    '500 step',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            IconButton(
                              onPressed: controller.decrementStep,
                              icon: Icon(FontAwesomeIcons.circleMinus),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
