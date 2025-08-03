import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:fitness/core/features/home/widgets/activity_status_widget.dart';
import 'package:fitness/core/features/home/widgets/app_bar.dart';
import 'package:fitness/core/features/home/widgets/bmi_widget.dart';
import 'package:fitness/core/features/home/widgets/target_today.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';
import 'activity/activity.dart';
import 'controller/home_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ValueNotifier<double> valueNotifier = ValueNotifier(0);
    final size = MediaQuery.of(context).size;
    final controller = context.read<HomeController>();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // * APP BAR  WELCOME , Name User And Notification
          AppBarWidget(theme: theme),
          SizedBox(height: 30),
          BmiWidget(size: size, theme: theme),
          SizedBox(height: 30),
          TodayTargetWidget(
            size: size,
            theme: theme,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Activity();
                  },
                ),
              );
              // Add this line to refresh the water size when returning from Activity screen
              context.read<HomeController>().refreshWaterSize();
            },
          ),
          SizedBox(height: 30),
          Text(
            'Activity Status',
            style: theme.textTheme.titleMedium!.copyWith(fontSize: 16),
          ),
          SizedBox(height: 30),
          // ********************* Activity Status ********************
          Consumer<HomeController>(
            builder: (BuildContext context, value, Widget? child) {
              return ActivityStatusWidget(
                size: size,
                heartRateData: value.heartRateData,
              );
            },
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Container(
                          height: 400,
                          width: size.width,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Water Intake',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Current water display
                              Consumer<HomeController>(
                                builder: (context, controller, child) {
                                  return Text(
                                    '${controller.currentWaterIntake.toInt()} ml',
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          color: Colors.lightBlue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  );
                                },
                              ),

                              const SizedBox(height: 20),

                              // Water glass icon
                              Icon(
                                FontAwesomeIcons.glassWater,
                                size: 60,
                                color: Colors.lightBlue,
                              ),

                              const SizedBox(height: 30),

                              // Control buttons row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // 250ml section
                                  Column(
                                    children: [
                                      Text(
                                        '250 ml',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              controller.decrementWater(250);
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.circleMinus,
                                            ),
                                            color: Colors.red,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              controller.incrementWater(250);
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.circlePlus,
                                            ),
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  // 500ml section
                                  Column(
                                    children: [
                                      Text(
                                        '500 ml',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              controller.decrementWater(500);
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.circleMinus,
                                            ),
                                            color: Colors.red,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              controller.incrementWater(500);
                                            },
                                            icon: Icon(
                                              FontAwesomeIcons.circlePlus,
                                            ),
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Close button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(120, 40),
                                ),
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Container(
                  height: 315,
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 2),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Consumer<HomeController>(
                      builder: (BuildContext context, value, Widget? child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SimpleAnimationProgressBar(
                              height: size.height * 0.3,
                              width: size.width * 0.07,
                              backgroundColor: Color(0xffF7F8F8),
                              foregroundColor: Color(0xffB4C0FE),
                              ratio: value.startWater ?? 0.0,
                              direction: Axis.vertical,
                              curve: Curves.fastLinearToSlowEaseIn,
                              duration: const Duration(seconds: 3),
                              borderRadius: BorderRadius.circular(17),
                              gradientColor: const LinearGradient(
                                colors: [Color(0xffB4C0FE), Color(0xffB4C0FE)],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Water Intake',
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                Selector<HomeController, double?>(
                                  selector: (context, provider) =>
                                      provider.targetWaterToday,
                                  builder: (context, targetValue, child) {
                                    return Text(
                                      '$targetValue Liters',
                                      style: theme.textTheme.titleMedium!
                                          .copyWith(
                                            color: theme
                                                .colorScheme
                                                .primaryContainer,
                                            fontSize: 21,
                                          ),
                                    );
                                  },
                                ),

                                // Show current progress
                                Text(
                                  'Real time updates',
                                  style: theme.textTheme.titleSmall!.copyWith(
                                    fontSize: 13,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: value.intakeDataNew.map((obj) {
                                      final isActive = obj['isActive'];
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 6.0,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 10,
                                              height: 10,
                                              decoration: BoxDecoration(
                                                color: isActive
                                                    ? Colors.purple
                                                    : Colors.grey,
                                                shape: BoxShape.circle,
                                              ),
                                              margin: const EdgeInsets.only(
                                                right: 8.0,
                                                top: 2.0,
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${obj["time"] ?? 'N/A'}",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Text(
                                                  "${obj["amount"] ?? 0}ml",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: isActive
                                                        ? Colors.purple
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 2),
                      ],

                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Sleep',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff1D1617),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '8h 20m',
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontSize: 20,
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                          SvgPicture.asset('assets/home/Sleep-Graph.svg'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 2),
                      ],

                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 4,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Calories',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff1D1617),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '1000 kCal',
                            style: theme.textTheme.titleMedium!.copyWith(
                              fontSize: 20,
                              color: theme.colorScheme.onSecondary,
                            ),
                          ),
                          Consumer<HomeController>(
                            builder: (context, provider, child) {
                              return Expanded(
                                child: DashedCircularProgressBar.aspectRatio(
                                  aspectRatio: 1.6,

                                  valueNotifier: ValueNotifier(600),
                                  progress: provider.calories,
                                  maxProgress: 1000,
                                  corners: StrokeCap.round,
                                  foregroundColor: Color(0xffB4C0FE),
                                  backgroundColor: Color(0xffF7F8F8),
                                  foregroundStrokeWidth: 12,
                                  backgroundStrokeWidth: 12,
                                  animation: true,
                                  child: Center(
                                    child: ValueListenableBuilder(
                                      valueListenable: valueNotifier,
                                      builder: (_, double value, __) => Text(
                                        '${1000 - value.toInt()}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
