import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../service/auth_service.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child:  ElevatedButton(onPressed: (){
          AuthService().signOut(context);
        }, child: Text("SignOut")),
      ),
    );
  }
}
