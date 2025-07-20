import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../featuers/complete/complete.dart';
import '../model/login.dart';
import '../model/signup_model.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // Getter for loading state
  bool get isLoading => _isLoading;

  // Getter for current user
  User? get currentUser => _auth.currentUser;

  // Stream for auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Display SnackBar with enhanced styling
  void _showSnackBar(
      BuildContext context,
      String title,
      String message,
      ContentType contentType,
      ) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  // Sign in user with email and password
  Future<UserCredential> login(BuildContext context, LoginModel log) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: log.email.trim(),
        password: log.password,
      );
      _showSnackBar(context, 'Success', 'Signed in successfully!', ContentType.success);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      ContentType contentType = ContentType.failure;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later.';
          break;
        default:
          errorMessage = e.message ?? 'Sign-in failed. Please try again.';
      }
      _showSnackBar(context, 'Error', errorMessage, contentType);
      throw Exception(errorMessage);
    } catch (e) {
      _showSnackBar(context, 'Error', 'An unexpected error occurred.', ContentType.failure);
      throw Exception('An unexpected error occurred: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Register new user with email verification
  Future<UserCredential?> register(BuildContext context, ResgisterModel register) async {
    try {
      // Input validation (unchanged)
      if (register.email.isEmpty || register.password.isEmpty) {
        _showSnackBar(context, 'Error', 'Email and password cannot be empty.', ContentType.failure);
        throw Exception('Email and password cannot be empty.');
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(register.email)) {
        _showSnackBar(context, 'Error', 'Invalid email format (e.g., example@domain.com).', ContentType.failure);
        throw Exception('Invalid email format.');
      }
      if (register.password.length < 8 ||
          !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&_]{8,}$').hasMatch(register.password)) {
        _showSnackBar(
          context,
          'Error',
          'Password must be at least 8 characters with letters and numbers.',
          ContentType.failure,
        );
        throw Exception('Weak password.');
      }
      if (register.firstname.isEmpty || register.lastname.isEmpty) {
        _showSnackBar(context, 'Error', 'First and last names are required.', ContentType.failure);
        throw Exception('First and last names are required.');
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: register.email.trim(),
        password: register.password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
        _showSnackBar(
          context,
          'Verification Email Sent',
          'Please check your email (and spam/junk folder) to verify your account.',
          ContentType.success,
        );

        // Schedule account deletion after 5 minutes if not verified
        _scheduleAccountDeletion(userCredential.user!, Duration(minutes: 5) , context );

        // Set up a listener for email verification
        _setupVerificationListener(context, userCredential.user!);
        await _auth.signOut();
        return userCredential;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      // Error handling (unchanged)
      String errorMessage;
      ContentType contentType = ContentType.failure;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          contentType = ContentType.warning;
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many requests. Please try again later.';
          break;
        default:
          errorMessage = e.message ?? 'Registration failed. Please try again.';
      }
      _showSnackBar(context, 'Error', errorMessage, contentType);
      throw Exception(errorMessage);
    } catch (e) {
      _showSnackBar(context, 'Error', 'An unexpected error occurred.', ContentType.failure);
      throw Exception('An unexpected error occurred: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  // Shedul Account deleting this Function if Not Confirm Email Enter for 5 min your email Accounet Deleting
  void _scheduleAccountDeletion(User user, Duration delay , BuildContext context) async {
    await Future.delayed(delay);
    // Reload the user to get the latest verification status
    await user.reload();
    user = _auth.currentUser!;
    if (!user.emailVerified) {
      _showSnackBar(context, "Delete Account", "Your Account Deleting Because not Confirm your email , \n Try Again an Confirm Your Account", ContentType.help);
    }
  }
  // This function stop deleting account if verified
  void _setupVerificationListener(BuildContext context, User user) {
    // Check verification status periodically
    Timer.periodic(Duration(seconds: 10), (timer) async {
      await user.reload();
      user = _auth.currentUser!;
      if (user.emailVerified) {
        timer.cancel(); // Stop checking once verified
        // Navigate to success page
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Complete()),
          );
        }
      }
    });
  }

  // Log out user
  Future<void> logOut(BuildContext context) async {
    if (_isLoading) return;
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signOut();
      _showSnackBar(context, 'Success', 'Logged out successfully!', ContentType.success);
    } catch (e) {
      _showSnackBar(context, 'Error', 'Failed to log out.', ContentType.failure);
      throw Exception('Failed to log out: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send password reset email
  Future<bool> forgetPassword({required BuildContext context, required String email}) async {
    if (_isLoading) return false;
    _isLoading = true;
    notifyListeners();
    try {
      final trimmedEmail = email.trim();
      await _auth.sendPasswordResetEmail(email: trimmedEmail);
      _showSnackBar(
        context,
        'Success',
        'Password reset email sent successfully! Please check your inbox.',
        ContentType.success,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      ContentType contentType = ContentType.failure;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many attempts. Please try again later.';
          break;
        default:
          errorMessage = 'Failed to send password reset email.';
      }
      _showSnackBar(context, 'Error', errorMessage, contentType);
      return false;
    } catch (e) {
      _showSnackBar(context, 'Error', 'An unexpected error occurred.', ContentType.failure);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}