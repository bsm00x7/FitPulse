import 'package:fitness/widget/floating_action_button_widget.dart';
import 'package:flutter/material.dart';

import 'onboarding.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xff92A3FD), Color(0xff9DCEFF)],
            ),
            borderRadius: BorderRadius.circular(100), // Rounded corners
          ),
          child: FloatingActionButtonWidget(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
              return OnBoarding();
            }));
          }, textlabel:  'Get Started'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text('Fitnest' , style: Theme.of(context).textTheme.titleLarge,),
                SizedBox(width: 4,),
               Text('Extra' , style: TextStyle(
                 fontSize: 20,
                 color: Colors.blueAccent,
                 fontWeight: FontWeight.bold
               ),)
              ],
            ),

            Text('Everybody  Can   Train',style:  Theme.of(context).textTheme.titleSmall,)
          ],
        ),
      ), // Placeholder content

    );
  }
}