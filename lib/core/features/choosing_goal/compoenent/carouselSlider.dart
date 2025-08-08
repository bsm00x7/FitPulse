// ignore: file_names
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../service/preference_manager.dart';
import '../../../constant/storage_Key.dart';
import '../../button_navigation_bar/button_navigation_bar.dart';

class CarouselSliderWidget extends StatefulWidget {
  final bool update;

  const CarouselSliderWidget({super.key, this.update = false});

  @override
  State<CarouselSliderWidget> createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  final List<Map<String, String>> views = [
    {
      'title': 'Improve Shape',
      'description':
      'I have a low amount of body fat and need / want to build more muscle',
      'image_source': 'assets/goal/Person1.svg',
    },
    {
      'title': 'Lean & Tone',
      'description':
      'I’m “skinny fat”. look thin but have no shape. I want to add learn muscle in the right way',
      'image_source': 'assets/goal/Person2.svg',
    },
    {
      'title': 'Lose',
      'description':
      'I have over 20 lbs to lose. I want to drop all this fat and gain muscle mass',
      'image_source': 'assets/goal/Person3.svg',
    },
  ];
  String goal = 'Improve Shape';

  final CarouselSliderController buttonCarouselController = CarouselSliderController();


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 40),
          Text(
            'Let’s complete your profile',
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'It will help us to know more about you!',
            style: theme.textTheme.displaySmall!.copyWith(fontSize: 15),
          ),
          SizedBox(height: 50),
          CarouselSlider(

            items: views
                .map(
                  (e) =>
                  Container(
                    margin: const EdgeInsets.all(4.0),
                    height: 800,
                    width: 400,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.secondary,
                          spreadRadius: 0.5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      // Added Column to display content
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          // Assuming you're using SVG images
                          e['image_source']!,
                          height: 260, // Adjust as needed
                        ),
                        const SizedBox(height: 20),
                        Text(e['title']!, style: theme.textTheme.labelSmall),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            e['description']!,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.labelSmall!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            )
                .toList(),
            carouselController: buttonCarouselController,
            options: CarouselOptions(
              onPageChanged: (index, reason) => goal = views[index]['title']!,
              autoPlay: false,
              enlargeCenterPage: true,
              viewportFraction: 0.75,
              enableInfiniteScroll: false,
              aspectRatio: 0.7,
              initialPage: 0,
              enlargeFactor: 0.4,
            ),
          ),
          const SizedBox(height: 15),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                PreferenceManager().setString(StorageKey.userGoal, goal);
                if (widget.update == false) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (BuildContext context) {
                        return ButtonNavigation();
                      }), (Route<dynamic> route) => false);
                }else{
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Confirm',
                style: theme.textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
