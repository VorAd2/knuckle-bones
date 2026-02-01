import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorMapper {
  static String getMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          return 'Invalid email or password.';
        case 'user-disabled':
          return 'This user has been disabled.';

        case 'email-already-in-use':
          return 'This email is already registered.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'invalid-email':
          return 'Please enter a valid email.';

        case 'network-request-failed':
          return 'No internet connection.';
        case 'too-many-requests':
          return 'Too many attempts. Try again later.';
        default:
          return 'Authentication error: ${error.message}';
      }
    }
    if (error is Exception) {
      return error.toString().replaceAll('Exception:', '').trim();
    }
    return 'An unknown error occurred.';
  }
}
