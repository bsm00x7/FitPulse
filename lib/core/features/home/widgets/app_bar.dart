
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness/services/coin_service.dart';

import '../controller/home_controller.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key, required this.theme});

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
            Consumer<HomeController>(
              builder: (BuildContext context,  HomeController value, Widget? child) {
                return Text( value.username ?? 'No name found',
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 20),
                );
              },
            ),
          ],
        ),
        // ! Add sheet button[ draggable]
        /*InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_)=>Notifications()));

          },
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
        ),*/
        // Coin Display
        Consumer<CoinService>(
          builder: (context, coinService, child) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFFC107),
                    Color(0xFFFFD54F),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFC107).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${coinService.coins}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
