import 'package:firebase_auth/firebase_auth.dart';

Future<String> registerUser(String email, String password) async {
  String errorMessage;
  try {
    errorMessage = '';
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final userVerfiy = FirebaseAuth.instance.currentUser;
    await userVerfiy?.sendEmailVerification();
    // Registration successful
  } catch (e) {
    // Handle registration errors and update the error message
    if (e is FirebaseAuthException) {
      if (e.code == 'invalid-email') {
        errorMessage = 'Invalid email address format. Please enter a valid email.';
      } else {
        errorMessage = 'Registration failed. ${e.message}';
      }
    } else {
      errorMessage = 'An unexpected error occurred. Please try again.';
  }
  }
  return errorMessage;
}
