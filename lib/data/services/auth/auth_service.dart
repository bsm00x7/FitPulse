// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../../../core/features/complete/complete.dart';



class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Getters
  String? getUser() {
    return _auth.currentUser?.uid;
  }

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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
    } catch (e) {
      // Optional: handle other exceptions (e.g., network issues)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed. Please try again.')),
      );
    }
    return false;
  }

 Future <void> signOut() async{
    await _auth.signOut();
    notifyListeners();
  }

  register({
    required String username,
    required String lastname,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // Carate New user
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user.user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Complete()),
          (Route<dynamic> route) => false,
        );
      }
      // Navigator to Home Page
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.code));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
