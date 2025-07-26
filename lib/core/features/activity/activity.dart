import 'package:fitness/core/features/activity/widgets/bar_chart_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../widget/header_bar.dart';

class Activity extends StatelessWidget {
  Activity({super.key});

  final List<String> items = [
    'Item1',
    'Item2',
    'Item3',
    'Item4',
    'Item5',
    'Item6',
    'Item7',
    'Item8',
  ];
  final calcProgress = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            HeaderBar(
              svgIcon1: 'assets/home/arrowbutton.svg',
              svgIcon2: 'assets/home/optionAppBar.svg',
              title: 'Activity Tracker',
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 180,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                      begin: Alignment.centerRight,
                      end: Alignment.centerLeft,
                      colors: [
                        theme.colorScheme.primaryContainer,
                        const Color(0xff9AC1FE),
                        const Color(0xff9DCEFF),
                      ],
                      stops: [0.0, 0.7, 1.0]
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 14,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Today Target',
                            style: theme.textTheme.headlineMedium!.copyWith(
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.onSecondary,
                                padding: EdgeInsets.zero,
                                shape: const CircleBorder(),
                              ),
                              onPressed: () {},
                              child: const Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _boxInsideTargets(theme: theme,
                            source: 'assets/activity/water.svg',
                            target: '4L',
                            subtitle: 'Water Intake',),
                          _boxInsideTargets(theme: theme,
                            source: 'assets/activity/boots 1.svg',
                            target: '2400',
                            subtitle: 'Foot Steps',)
                        ],
                      ),

                    ],

                  ),
                ),
              ),
            ),

            SizedBox(height: 50,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Activity Progress',
                style: theme.textTheme.titleMedium!.copyWith(fontSize: 18),),
            ),


            SizedBox(height: 12,),

            BarChartProgress(),
            Align(alignment: Alignment.centerLeft,
                child: Text('Last Activity',
                  style: theme.textTheme.titleMedium!.copyWith(fontSize: 18),)),
            SizedBox(height: 13,),
            Column(
              children: [
                DecoratedBox(

                  decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 7, horizontal: 7),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: CircleAvatar(
                              child: SvgPicture.asset(
                                  'assets/activity/drinkWater.svg'),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Drinking 300ml Water',
                                style: theme.textTheme.titleMedium!.copyWith(
                                    fontSize: 18),),
                              Text('Sub title',
                                style: theme.textTheme.displaySmall!.copyWith(
                                    fontSize: 15),),
                            ],
                          ),
                          Icon(Icons.delete)
                        ]
                    ),
                  ),
                ),
                const Divider(
                  color: Colors.white,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 7, horizontal: 7),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: CircleAvatar(
                              child: SvgPicture.asset(
                                  'assets/activity/drinkWater.svg'),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Drinking 300ml Water',
                                style: theme.textTheme.titleMedium!.copyWith(
                                    fontSize: 18),),
                              Text('Sub title',
                                style: theme.textTheme.displaySmall!.copyWith(
                                    fontSize: 15),),
                            ],
                          ),
                          Icon(Icons.delete)
                        ]
                    ),
                  ),
                )
              ],
            )

          ],
        ),
      ),
    );
  }

  Container _boxInsideTargets(
      {required ThemeData theme, required String source, required String target, required String subtitle}) {
    return Container(
      height: 60,
      width: 130,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SvgPicture.asset(source, width: 34, height: 25,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(target, style: theme.textTheme.headlineSmall,),
              Text(subtitle,
                style: theme.textTheme.titleSmall!.copyWith(fontSize: 12),)
            ],
          )
        ],
      ),
    );
  }

}