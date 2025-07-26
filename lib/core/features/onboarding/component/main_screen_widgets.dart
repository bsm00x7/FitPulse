import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.mapScreen});

  final Map<String, String> mapScreen;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: size.height * 0.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.elliptical(100, 200),
                ),
              ),
            ),
            SvgPicture.asset(
              mapScreen['ImageSource']!,
              height: 300,
            ),
          ],
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            mapScreen['Title']!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            mapScreen['Description']!,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}