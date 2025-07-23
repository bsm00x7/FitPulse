import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Getters
  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }

  Future<bool> loginAuth({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      print("This is problem ${e.code}");
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is badly formatted.';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid email or password.';
          break;
        default:
          errorMessage = 'An unexpected error occurred. Please try again.';
      }


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } catch (e) {
      // Optional: handle other exceptions (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
    return false;
  }


  register({required String email , required String password , required BuildContext context})async {
   try{
     // Carate New user
     await _auth.createUserWithEmailAndPassword(email: email, password: password);
     // Navigator to Home Page
   }on FirebaseAuthException catch(e){
     final snackBar = SnackBar(content: Text(e.code));
     ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }

  }
}
