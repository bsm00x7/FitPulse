import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text('Welcome Back,', style: theme.textTheme.displaySmall),
            // ! TO DO GET USER NAME OF DATE BASE [ LOCAL , SERVER]
            Text(
              'Bassem Naser',
              style: theme.textTheme.titleMedium!.copyWith(fontSize: 20),
            ),
          ],
        ),
        // ! Add sheet button[ draggable]
        InkWell(
          onTap: (){},
          child: Hero(
            tag: 'bell',
            child: CircleAvatar(
              backgroundColor: Color(0xffF7F8F8),
              //! Checking this icon is correct or no
              child: SvgPicture.asset(
                'assets/home/Bell-Icon.svg',
                width: 18,
                height: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}