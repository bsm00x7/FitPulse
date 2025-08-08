import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../widget/TextFormField.dart';
import '../../choosing_goal/compoenent/CarouselSlider.dart';

Future<dynamic> buildShowModalBottomSheetWidget({
  required BuildContext context,
  required TextEditingController usernameController,
  required VoidCallback onPressed,
  required GlobalKey<FormState> key,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 41),
        child: Form(
          key: key,
          child: Column(
            children: [
          Center(
          child: Text(
          'Edit Profile',
            style: Theme
                .of(context)
                .textTheme
                .titleMedium,
          ),
        ),
        SizedBox(height: 20),
        TextFormFieldWidget(
          source: 'assets/profile/user.svg',
          controller: usernameController,
          hint: 'New name',
          obscureText: false,
          errorValidator: 'Please enter your name',
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 20),
        Divider(color: Colors.grey.withValues(alpha: 0.7),),
        InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Scaffold(
                body: SafeArea(child: CarouselSliderWidget(update: true,))
              );
            },));
          },
          child: Row(
            children: [
              Icon(FontAwesomeIcons.person, size: 35,),
              SizedBox(width: 15),
              Text('Update Gaol', style: Theme
                  .of(context)
                  .textTheme
                  .bodyMedium,) ],
              ),
        ),
            Spacer(),
            ElevatedButton(
              onPressed: onPressed,
              child: Text('Submit Update'),
            ),
          ],
        ),
      ),);
    },
  );
}
