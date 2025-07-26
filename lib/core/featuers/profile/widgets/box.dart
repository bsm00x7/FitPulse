import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  const Box({super.key, required this.title, required this.subtitle});
  final String title ;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        padding: EdgeInsets.only(top: 12),
        width: 95,
        height: 70,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              blurRadius: 6,

            )
          ],

      
        ),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall,),
            Text(subtitle, style: Theme.of(context).textTheme.displaySmall,)
          ],
        ),
      ),
    );
  }
}
