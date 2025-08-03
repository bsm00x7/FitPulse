import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/work_out_controller.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return WorkOutControllerProvider();
      },
      child: SafeArea(
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
                      return InkWell(
                        onTap: (){
                          provider.bodyFocusItem();
                          debugPrint(provider.bodyFocus.length.toString());
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              '$index',
                              style: theme.textTheme.displaySmall!.copyWith(
                                fontSize: 18,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: 6);
                    },
                    itemCount: 20,
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
