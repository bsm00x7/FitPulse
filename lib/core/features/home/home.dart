import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:fitness/core/features/home/widgets/activity_status_widget.dart';
import 'package:fitness/core/features/home/widgets/app_bar.dart';
import 'package:fitness/core/features/home/widgets/bmi_widget.dart';
import 'package:fitness/core/features/home/widgets/target_today.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

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
          // * Banner
          //! To do doit after make backend
          /*
          To calculate BMI (Body Mass Index), use the following formula:

              BMI = weight (kg) / [height (m)]²

              Steps:
                      Measure your weight in kilograms (kg).
                Measure your height in meters (m).
              Square your height (multiply height by itself).
                  Divide your weight by the squared height.
                Example:
            Weight = 70 kg
          Height = 1.75 m
          BMI = 70 / (1.75 × 1.75) = 70 / 3.0625 ≈ 22.86
          Categories (for reference):
            Below 18.5: Underweight
             18.5–24.9: Normal weight
             25–29.9: Overweight
             30 and above: Obesity
             Let me know if you need help with specific values!



           */
          BmiWidget(size: size, theme: theme),

          SizedBox(height: 30),
          // ! Check button [go to page Target To day]
          TodayTargetWidget(size: size, theme: theme),
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
                        child: SizedBox(
                          height: 300,
                          width: size.width,

                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildWater(
                                  source:
                                      'assets/home/water-glass-color-icon.svg',
                                  height: 90,
                                  width: 90,
                                  size: 1000,
                                  controller: controller,
                                  context: context,
                                ),
                                _buildWater(
                                  source:
                                      'assets/home/water-glass-color-icon.svg',
                                  height: 70,
                                  context: context,
                                  width: 70,
                                  size: 900,
                                  controller: controller,
                                ),
                                _buildWater(
                                  context: context,
                                  source:
                                      'assets/home/water-glass-color-icon.svg',
                                  height: 50,
                                  width: 50,
                                  size: 700,
                                  controller: controller,
                                ),
                                _buildWater(
                                  context: context,
                                  source:
                                      'assets/home/water-glass-color-icon.svg',
                                  height: 40,
                                  width: 40,
                                  controller: controller,
                                  size: 600,
                                ),
                                _buildWater(
                                  context: context,
                                  source:
                                      'assets/home/water-glass-color-icon.svg',
                                  height: 30,
                                  width: 30,
                                  size: 500,
                                  controller: controller,
                                ),
                              ],
                            ),
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
                      builder: (BuildContext context, value, Widget? child) { return Row(
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
                              colors: [
                                Color(0xffB4C0FE),
                                Color(0xffB4C0FE),
                              ],
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
                              Text(
                                '4 Liters',
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: theme.colorScheme.primaryContainer,
                                  fontSize: 21,
                                ),
                              ),
                              Text(
                                'Real time updates',
                                style: theme.textTheme.titleSmall!.copyWith(
                                  fontSize: 13,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: controller.intakeDataNew.map((obj) {
                                    final isActive =
                                    obj['isActive']; // Default to false if not present
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
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
                      ); },

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
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Sleep' ,style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff1D1617),
                            fontWeight: FontWeight.w600
                          ),),
                          Text('8h 20m', style: theme.textTheme.titleMedium!.copyWith(fontSize: 20 , color: theme.colorScheme.onSecondary),),
                          SvgPicture.asset('assets/home/Sleep-Graph.svg')
                        ],
                      ),
                    ),
                  ),
                 SizedBox(height: 15,),
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
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('Calories' ,style: TextStyle(
                              fontSize: 18,
                              color: Color(0xff1D1617),
                              fontWeight: FontWeight.w600
                          ),),
                          Text('760 kCal', style: theme.textTheme.titleMedium!.copyWith(fontSize: 20 , color: theme.colorScheme.onSecondary),),
                          Expanded(
                            child: DashedCircularProgressBar.aspectRatio(
                              aspectRatio: 1.6, // width ÷ height
                              valueNotifier: valueNotifier,
                              progress: 1000-240,
                              maxProgress: 1000,
                              corners: StrokeCap.round,
                              foregroundColor: Color(0xffB4C0FE) ,
                              backgroundColor:  Color(0xffF7F8F8),
                              foregroundStrokeWidth: 12,
                              backgroundStrokeWidth: 12,
                              animation: true,
                              child: Center(
                                child: ValueListenableBuilder(
                                  valueListenable: valueNotifier,
                                  builder: (_, double value, __) => Text(
                                    '${1000- value.toInt()}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
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

  Widget _buildWater({
    required String? source,
    required double height,
    required double width,
    required int size,
    required HomeController controller,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: () {
         controller.updateWater(size);
        controller.saveLastActivity(size);
        Navigator.pop(context);
      },
      child: SvgPicture.asset(
        source!,
        width: width,
        colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
      ),
    );
  }
}
