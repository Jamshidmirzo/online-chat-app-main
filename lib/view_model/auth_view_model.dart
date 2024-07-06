import 'package:chat_app/services/auth/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuthService.loginUser(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: $e');
      rethrow;
    } catch (e) {
      debugPrint('error: AuthController(): $e');
      rethrow;
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuthService.registerUser(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: $e');
      rethrow;
    } catch (e) {
      debugPrint('error: AuthController(): $e');
      rethrow;
    }
  }

  Future<void> logoutUser() async {
    try {
      await FirebaseAuthService.logoutUser();
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: $e');
      rethrow;
    } catch (e) {
      debugPrint('error: AuthController(): $e');
      rethrow;
    }
  }
}
