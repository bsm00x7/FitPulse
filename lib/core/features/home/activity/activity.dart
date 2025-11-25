import 'dart:math';
import 'package:fitness/core/features/home/activity/widgets/bar_chart_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../widget/header_bar.dart';
import 'add_new_target.dart';
import 'controller/ActivityControllerProvider.dart';
import 'controller/add_new_targets_controller.dart';
import '../../../../data/models/activity_model.dart';

class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ChangeNotifierProvider(
          create: (BuildContext context) => ActivityControllerProvider(),
          builder: (BuildContext context, Widget? child) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HeaderBar(
                      title: 'Activity Tracker',
                      onIcon1Tap: () async {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.colorScheme.primaryContainer,
                              const Color(0xff9AC1FE),
                              const Color(0xff9DCEFF),
                            ],
                            stops: [0.0, 0.7, 1.0],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Today Target',
                                    style: theme.textTheme.headlineMedium!
                                        .copyWith(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.onSecondary,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return ChangeNotifierProvider(
                                                  create: (BuildContext context) =>
                                                      AddTargetControllerProvider(),
                                                  child: AddNewTarget(),
                                                );
                                              },
                                            ),
                                          );
                                          context
                                              .read<ActivityControllerProvider>()
                                              .loadLastDataTarget();
                                        },
                                        borderRadius: BorderRadius.circular(25),
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Selector<ActivityControllerProvider, double?>(
                                    selector: (context, provider) =>
                                        provider.waterSize,
                                    builder: (context, value, child) {
                                      return _boxInsideTargets(
                                        theme: theme,
                                        source: 'assets/activity/water.svg',
                                        target: '$value L',
                                        subtitle: 'Water Intake',
                                      );
                                    },
                                  ),
                                  Consumer<ActivityControllerProvider>(
                                    builder: (context, provider, child) {
                                      return _boxInsideTargets(
                                        theme: theme,
                                        source: 'assets/activity/boots 1.svg',
                                        target: '${provider.steps}',
                                        subtitle: 'Foot Steps',
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 50),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Activity Progress',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ),

                    SizedBox(height: 12),

                    BarChartProgress(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Last Activity',
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 13),
                    Consumer<ActivityControllerProvider>(
                      builder: (context, valueProvider, child) {
                        return valueProvider.lastActivity.isEmpty
                            ? Container(
                                height: 200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.fitness_center,
                                        size: 64,
                                        color: Colors.grey[300],
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'No activities yet',
                                        style: theme.textTheme.titleMedium!.copyWith(
                                          color: Colors.grey[500],
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Start adding your daily targets',
                                        style: theme.textTheme.bodySmall!.copyWith(
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 400,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.separated(
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: min(
                                    3,
                                    valueProvider.lastActivity.length,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                        final activity = ActivityModel.fromMap(
                                          valueProvider.lastActivity[index],
                                        );
                                        return Dismissible(
                                          key: Key(activity.id),
                                          direction: DismissDirection.endToStart,
                                          background: Container(
                                            alignment: Alignment.centerRight,
                                            padding: EdgeInsets.only(right: 20),
                                            decoration: BoxDecoration(
                                              color: Colors.red.shade400,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.delete_sweep,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                          onDismissed: (direction) {
                                            valueProvider.lastActivity
                                                .removeAt(index);
                                            valueProvider
                                                .saveLastActivity(index);
                                          },
                                          child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                                  Colors.white,
                                                  Colors.grey.withValues(alpha: 0.08),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Colors.grey.withValues(alpha: 0.15),
                                                width: 1,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withValues(alpha: 0.05),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 12,
                                                horizontal: 12,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Center(
                                                      child: SvgPicture.asset(
                                                        activity.sourceImage,
                                                        width: 24,
                                                        height: 24,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          activity.title,
                                                          style: theme
                                                              .textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          valueProvider.convertDate(
                                                            activity.timestamp,
                                                          ),
                                                          style: theme
                                                              .textTheme
                                                              .displaySmall!
                                                              .copyWith(
                                                                fontSize: 13,
                                                                color: Colors.grey[600],
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.chevron_right,
                                                    color: Colors.grey[400],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                        return SizedBox(height: 12);
                                      },
                                ),
                              );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container _boxInsideTargets({
    required ThemeData theme,
    required String source,
    required String target,
    required String subtitle,
  }) {
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
          SvgPicture.asset(source, width: 34, height: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(target, style: theme.textTheme.headlineSmall),
              Text(
                subtitle,
                style: theme.textTheme.titleSmall!.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
