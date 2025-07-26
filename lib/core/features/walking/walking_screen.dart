import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

class WalkingScreen extends StatefulWidget {
  const WalkingScreen({super.key});

  @override
  State<WalkingScreen> createState() => _WalkingScreenState();
}

class _WalkingScreenState extends State<WalkingScreen>
    with SingleTickerProviderStateMixin {
  bool isWalking = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Start or stop animation based on isWalking
    if (isWalking) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to toggle isWalking for testing
  void toggleWalking() {
    setState(() {
      isWalking = !isWalking;
      if (isWalking) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300, // Constrain the animation height
              child: Lottie.asset(
                'assets/lottis_json/Groovy Walk Cycle.json',
                fit: BoxFit.contain, // Maintain aspect ratio
                frameRate: FrameRate.max,
                controller: _controller,
                onLoaded: (composition) {
                  // Set the controller duration to match the Lottie animation
                  _controller.duration = composition.duration;
                  // Start animation if isWalking is true
                  if (isWalking) {
                    _controller.repeat();
                  }
                },
              ),
            ),
            const SizedBox(height: 90),
            Container(
              width: double.infinity,
              height: MediaQuery
                  .of(context)
                  .size
                  .height * 0.25,
              decoration: BoxDecoration(
                color: Colors.purpleAccent.withValues(alpha: 0.5),
                // Use withOpacity for clarity
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Day Target',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Colors.white, fontSize: 21),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SimpleCircularProgressBar(
                          valueNotifier: ValueNotifier(2900),
                          animationDuration: 4,
                          maxValue: 2500,
                          backColor: Colors.white,
                          progressStrokeWidth: 10,
                          backStrokeWidth: 10,
                        ),
                        Text('30999', style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium!.copyWith(fontSize: 20),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,textAlign: TextAlign.center,)
                      ],
                    ),

                    // Button to toggle isWalking for testing
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}