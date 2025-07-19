// onboarding.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'component/main_screen_widgets.dart';
import 'controller/navigator_controller.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

final List<Map<String, String>> listpage = [
  {
    "Title": "Track Your Goal",
    "Description":
    "Don't worry if you have trouble determining your goals, We can help you determine your goals and track your goals",
    "ImageSource": "lib/assets/onboarding_image/page2.svg",
  },
  {
    "Title": "Get Burn",
    "Description":
    "Let’s keep burning, to achieve your goals, it hurts only temporarily, if you give up now you will be in pain forever",
    "ImageSource": "lib/assets/onboarding_image/runner_2_.svg",
  },
  {
    "Title": "Eat Well",
    "Description":
    "Let's start a healthy lifestyle with us, we can determine your diet every day. healthy eating is fun",
    "ImageSource": "lib/assets/onboarding_image/EatWell.svg",
  },
  {
    "Title": "Improve Sleep Quality",
    "Description":
    "Improve the quality of your sleep with us, good quality sleep can bring a good mood in the morning",
    "ImageSource":
    "lib/assets/onboarding_image/sleeping-square-svgrepo-com.svg",
  },
];

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    print("Build");
    return SafeArea(
      child: Scaffold(
        floatingActionButton: Stack(
          alignment: Alignment.center,
          children: [
            Selector<NavigatorController , int>(
                selector: (BuildContext , NavigatorController) {
                  return NavigatorController.currentPage;
                },
                builder: (BuildContext context,  value, Widget? child) {
                  return Transform.rotate(
                    angle: 0,
                    child: SizedBox(
                      width: 64.0,
                      height: 64.0,
                      child: CircularProgressIndicator(
                        strokeWidth: 8.0,
                        value: value== 0
                            ? 0.25
                            : value / 4 + 0.25,
                        color: Theme.of(context).colorScheme.secondary,
                        backgroundColor:
                        Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
                      ),
                    ),
                  );
                },
            ),
            Selector<NavigatorController, NavigatorController>(
              selector: (BuildContext context, controller) {
                return controller;
              },
              builder: (BuildContext context, value, Widget? child) {
                return FloatingActionButton(
                  elevation: 1,
                  onPressed: () {
                    if (value.currentPage < listpage.length - 1) {
                      value.nextPage();
                      value.jumpPage();
                    } else {
                      value.navigatorSignupPage(context);
                    }
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Icon(Icons.navigate_next),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Selector<NavigatorController,NavigatorController>(
                selector: (BuildContext , controller ) =>controller,
                builder: (BuildContext context, value, Widget? child) {
                  return  PageView.builder(
                    controller:value.pageController,
                    itemCount: listpage.length,
                    onPageChanged: (int index) {
                      value.movePageWithIndex(index);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return MainScreen(mapScreen: listpage[index]);
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
