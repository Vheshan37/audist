import 'package:audist/core/exception/login_exception.dart';
import 'package:audist/data/auth/models/login_response_model.dart';
import 'package:audist/data/auth/models/user_login_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

abstract class FirebaseAuthService {
  Future<LoginResponseModel> login(UserLoginModel params);
}

class FirebaseAuthServiceImpl extends FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<LoginResponseModel> login(UserLoginModel params) async {
    try {
      // Attempt sign-in
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      // Get the current Firebase user
      final user = credential.user;

      if (user != null) {
        debugPrint('User: $user');
        // Check if email is verified
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          return LoginResponseModel(
            statusCode: 403, // Forbidden
            message: "Account not verified. Please check your inbox.",
          );
        }

        // Success
        return LoginResponseModel(
          statusCode: 200, // OK
          message: "Login successful",
          userId: user.uid,
          email: user.email,
        );
      } else {
        return LoginResponseModel(
          statusCode: 404, // Not Found
          message: "User not found",
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      int statusCode;

      switch (e.code) {
        case 'user-not-found':
          message = "No user found for that email.";
          statusCode = 404; // Not Found
          break;
        case 'wrong-password':
          message = "Incorrect password. Try again.";
          statusCode = 401; // Unauthorized
          break;
        case 'invalid-email':
          message = "Email format is invalid.";
          statusCode = 400; // Bad Request
          break;
        case 'user-disabled':
          message = "This user account has been disabled.";
          statusCode = 403; // Forbidden
          break;
        default:
          message = "Login failed. Please try again later.";
          statusCode = 500; // Internal Server Error
      }

      return LoginResponseModel(statusCode: statusCode, message: message);
    } catch (e) {
      // Catch-all for non-Firebase errors
      return LoginResponseModel(
        statusCode: 500, // Internal Server Error
        message: "An unexpected error occurred: ${e.toString()}",
      );
    }
  }
}
