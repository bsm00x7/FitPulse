import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:provider/provider.dart';

import 'controller/work_out_controller.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60),
            SizedBox(
              height: 38,
              child: Consumer<WorkOutControllerProvider>(
                builder: (context, provider, child) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return  InkWell(
                        onTap:(){
                         provider.randomExercice(nameMuscle: provider.bodyFocus[index]);
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              provider.bodyFocus[index],
                              style: theme.textTheme.displaySmall!.copyWith(
                                fontSize: 18,
                                color: Colors.black54,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount :provider.bodyFocus.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 6);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 60),
            SizedBox(
              height: 250,
              child: Consumer<WorkOutControllerProvider>(
                builder: (context, provider, child) {
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Gif(image: AssetImage('https://static.exercisedb.dev/media/K1vlode.gif'))
                        ],
                      );
                    },
                    itemCount :provider.random.length,
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 6);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
