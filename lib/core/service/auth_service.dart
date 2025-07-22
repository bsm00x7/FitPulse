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

  // Getters
  bool get isLoading => _isLoading;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Displays a styled SnackBar with the given title, message, and content type
  void _showSnackBar(
      BuildContext context,
      String title,
      String message,
      ContentType contentType,
      ) {
    if (!context.mounted) return; // Prevent SnackBar if context is unmounted
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

  /// Signs in a user with email and password
  Future<UserCredential> login(BuildContext context, LoginModel loginModel) async {
    _setLoading(true);
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: loginModel.email.trim(),
        password: loginModel.password,
      );
      if (context.mounted) {
        _showSnackBar(context, 'Success', 'Signed in successfully!', ContentType.success);
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapFirebaseAuthError(e);
      if (context.mounted) {
        _showSnackBar(context, 'Error', errorMessage, ContentType.failure);
      }
      throw Exception(errorMessage);
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Error', 'An unexpected error occurred.', ContentType.failure);
      }
      throw Exception('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Registers a new user and sends email verification
  Future<UserCredential?> register(BuildContext context, RegisterModel registerModel) async {
    _setLoading(true);
    try {
      // Validate input
      if (!_validateRegisterInput(context, registerModel)) {
        return null;
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: registerModel.email.trim(),
        password: registerModel.password,
      );

      if (userCredential.user != null) {
        await userCredential.user!.sendEmailVerification();
        if (context.mounted) {
          _showSnackBar(
            context,
            'Verification Email Sent',
            'Please check your email (and spam/junk folder) to verify your account.',
            ContentType.success,
          );
        }

        // Schedule account deletion if not verified within 5 minutes
        _scheduleAccountDeletion(userCredential.user!, const Duration(minutes: 5), context);

        // Set up email verification listener
        _setupVerificationListener(context, userCredential.user!);

        await _auth.signOut();
        return userCredential;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapFirebaseAuthError(e);
      if (context.mounted) {
        _showSnackBar(context, 'Error', errorMessage, e.code == 'email-already-in-use' ? ContentType.warning : ContentType.failure);
      }
      throw Exception(errorMessage);
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Error', 'An unexpected error occurred.', ContentType.failure);
      }
      throw Exception('An unexpected error occurred: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Validates registration input and shows error SnackBars if invalid
  bool _validateRegisterInput(BuildContext context, RegisterModel registerModel) {
    if (registerModel.email.isEmpty || registerModel.password.isEmpty) {
      _showSnackBar(context, 'Error', 'Email and password cannot be empty.', ContentType.failure);
      throw Exception('Email and password cannot be empty.');
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(registerModel.email)) {
      _showSnackBar(context, 'Error', 'Invalid email format (e.g., example@domain.com).', ContentType.failure);
      throw Exception('Invalid email format.');
    }
    if (registerModel.password.length < 8 ||
        !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&_]{8,}$').hasMatch(registerModel.password)) {
      _showSnackBar(
        context,
        'Error',
        'Password must be at least 8 characters with letters and numbers.',
        ContentType.failure,
      );
      throw Exception('Weak password.');
    }
    if (registerModel.firstname.isEmpty || registerModel.lastname.isEmpty) {
      _showSnackBar(context, 'Error', 'First and last names are required.', ContentType.failure);
      throw Exception('First and last names are required.');
    }
    return true;
  }

  /// Maps FirebaseAuthException codes to user-friendly error messages
  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      default:
        return e.message ?? 'An error occurred.';
    }
  }

  /// Schedules account deletion if the user doesn't verify their email within the specified delay
  void _scheduleAccountDeletion(User user, Duration delay, BuildContext context) {
    Timer(delay, () async {
      try {
        await user.reload();
        user = _auth.currentUser!;
        if (!user.emailVerified && user.uid == _auth.currentUser?.uid) {
          await user.delete();
          if (context.mounted) {
            _showSnackBar(
              context,
              'Account Deleted',
              'Your account was deleted because email verification was not completed.',
              ContentType.warning,
            );
          }
        }
      } catch (e) {
        debugPrint('Failed to delete unverified account: $e');
      }
    });
  }

  /// Sets up a listener to check for email verification and navigates on success
  void _setupVerificationListener(BuildContext context, User user) {
    final timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      try {
        await user.reload();
        user = _auth.currentUser!;
        if (user.emailVerified) {
          timer.cancel();
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Complete()),
            );
          }
        }
      } catch (e) {
        debugPrint('Error checking email verification: $e');
        timer.cancel(); // Cancel timer on persistent errors
      }
    });

    // Cancel timer when user is signed out or deleted
    _auth.authStateChanges().listen((currentUser) {
      if (currentUser == null) {
        timer.cancel();
      }
    });
  }

  /// Logs out the current user
  Future<void> logOut(BuildContext context) async {
    if (_isLoading) return;
    _setLoading(true);
    try {
      await _auth.signOut();
      if (context.mounted) {
        _showSnackBar(context, 'Success', 'Logged out successfully!', ContentType.success);
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Error', 'Failed to log out.', ContentType.failure);
      }
      throw Exception('Failed to log out: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Sends a password reset email
  Future<bool> forgetPassword({required BuildContext context, required String email}) async {
    if (_isLoading) return false;
    _setLoading(true);
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      if (context.mounted) {
        _showSnackBar(
          context,
          'Success',
          'Password reset email sent successfully! Please check your inbox.',
          ContentType.success,
        );
      }
      return true;
    } on FirebaseAuthException catch (e) {
      final errorMessage = _mapFirebaseAuthError(e);
      if (context.mounted) {
        _showSnackBar(context, 'Error', errorMessage, ContentType.failure);
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, 'Error', 'An unexpected error occurred.', ContentType.failure);
      }
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Updates the loading state and notifies listeners
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}