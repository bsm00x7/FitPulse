import 'package:flutter/material.dart';

import '../../../../widget/TextFormField.dart';

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
                  style: Theme.of(context).textTheme.titleMedium,
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
              SizedBox(height: 200),
              ElevatedButton(
                onPressed: onPressed,
                child: Text('Submit Update'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
