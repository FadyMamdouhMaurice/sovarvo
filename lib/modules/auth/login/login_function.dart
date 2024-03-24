import 'package:firebase_auth/firebase_auth.dart';

Future<String> loginUser(String email, String password) async {
  String errorMessage;
  try {
    errorMessage = '';
    UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Check if email is verified
    if (userCredential.user?.emailVerified ?? false) {
      // Email is verified, navigate to the next screen or perform any other action
      return errorMessage;
    } else {
      // Email is not verified, display a message to the user
      errorMessage = 'Please verify your email address.';
      return errorMessage;
    }
  } catch (e) {
    // Handle login errors and update the error message
    if (e is FirebaseAuthException) {
      errorMessage = 'Login failed. ${e.message}';
    } else {
      errorMessage = 'An unexpected error occurred. Please try again.';
    }
    return errorMessage;
  }
}