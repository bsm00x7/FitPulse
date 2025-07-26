
import 'package:fitness/core/features/profile/widgets/box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'controlles/controller.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return ProfileController();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(
                    'assets/profile/user.svg',
                    height: 26,
                  ),
                ),
                SizedBox(width: 15),
                Consumer<ProfileController>(
                  builder: (BuildContext context, value, Widget? child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(value.username!),
                        Text(
                          'User connect',
                          style: theme.textTheme.titleSmall!.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Spacer(),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(minimumSize: Size(83, 30)),
                    child: Text(
                      'Edit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            Consumer<ProfileController>(
              builder: (BuildContext context, value, Widget? child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Box(title: '${value.height}cm', subtitle: 'Height'),
                    Box(title: '${value.weight}Kg', subtitle: 'Weight'),
                  ],
                );
              },
            ),
            const SizedBox(height: 50),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Account',
                style: theme.textTheme.titleMedium!.copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/profile/Icon-Profile.svg',
                    ),
                    title: Text('Personal Data'),
                    trailing: SvgPicture.asset('assets/profile/Icon-Arrow.svg'),
                  ),
                  Divider(color: Colors.grey.withValues(alpha: 0.2)),
                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/profile/Icon-Achievement.svg',
                    ),
                    title: Text('Achievement'),
                    trailing: SvgPicture.asset('assets/profile/Icon-Arrow.svg'),
                  ),
                  Divider(color: Colors.grey.withValues(alpha: 0.2)),
                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/profile/Icon-Activity.svg',
                    ),
                    title: Text('Activity History'),
                    trailing: SvgPicture.asset('assets/profile/Icon-Arrow.svg'),
                  ),
                  Divider(color: Colors.grey.withValues(alpha: 0.2)),
                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/profile/Icon-Workout.svg',
                    ),
                    title: Text('Workout Progress'),
                    trailing: SvgPicture.asset('assets/profile/Icon-Arrow.svg'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Notification',
                style: theme.textTheme.titleMedium!.copyWith(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                leading: SvgPicture.asset('assets/profile/Notification.svg'),
                title: Text('Pop-up Notification'),
                trailing: Switch.adaptive(
                    inactiveTrackColor: Colors.white,
                    trackOutlineColor: WidgetStateProperty.resolveWith((state){
                      if (state.contains(WidgetState.selected)){
                        return theme.colorScheme.onSecondary;
                        
                      }else{
                        return Colors.grey.withValues(alpha: 0.5);
                      }
                    }),
                    activeTrackColor: theme.colorScheme.onSecondary,
                    thumbColor: WidgetStateProperty.resolveWith((state){
                      if(state.contains(WidgetState.selected)){
                        return Colors.white;
                      }else{
                        return Colors.grey;
                      }
                    }),

                    value: true, onChanged: (value) {}),
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Other',
                style: theme.textTheme.titleMedium!.copyWith(fontSize: 18),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/profile/Message.svg',
                    ),
                    title: Text('Contact Us'),
                    trailing: SvgPicture.asset('assets/profile/Icon-Arrow.svg'),
                  ),
                  Divider(color: Colors.grey.withValues(alpha: 0.2)),
                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/profile/Setting.svg',
                    ),
                    title: Text('Settings'),
                    trailing: SvgPicture.asset('assets/profile/Icon-Arrow.svg'),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
