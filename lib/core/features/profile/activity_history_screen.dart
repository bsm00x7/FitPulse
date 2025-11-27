import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fitness/widgets/native_ad_widget.dart';

import 'controller/activity_history_controller.dart';

class ActivityHistoryScreen extends StatelessWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) => ActivityHistoryController(),
      builder: (context, child) {
        final contextProvider = Provider.of<ActivityHistoryController>(context);
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            splashColor: Colors.deepPurpleAccent.withValues(alpha: 0.5),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Image.asset('assets/activity/broom.png', height: 80),
            onPressed: () {
              contextProvider.clear();
            },

          ),
          appBar: AppBar(
            title: Text('History', style: theme.textTheme.titleMedium),
          ),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(height: 40),
                  Expanded(
                    child: Consumer<ActivityHistoryController>(
                      builder: (context, provider, child) {
                        return provider.nameActivity.isEmpty? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history,size: 60,color: Colors.grey,),
                              SizedBox(height: 20,),
                              Text('D \'ont have any activity  ',maxLines: 1, overflow:TextOverflow.ellipsis,style: TextStyle(
                                fontSize: 25,
                                color: Colors.grey
                              ),),
                            ],
                          ),
                        ): ListView.builder(
                          itemCount: provider.nameActivity.length + (provider.nameActivity.length ~/ 5),
                          itemBuilder: (context, index) {
                            // Show ad every 5 items
                            if ((index + 1) % 6 == 0) {
                              return const NativeAdWidget();
                            }
                            
                            // Adjust index for actual activity items
                            final activityIndex = index - (index ~/ 6);
                            
                            return Column(
                              children: [
                                Container(
                                  height: 60,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Color(0xFF8B5CF6).withValues(alpha: 0.3),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 5,
                                      horizontal: 15,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(FontAwesomeIcons.dumbbell),
                                        SizedBox(width: 40),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width *
                                              0.67,
                                          child: Text(
                                            provider.nameActivity[activityIndex],
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
