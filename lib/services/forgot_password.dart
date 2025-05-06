
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();

  Future<String?> resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      return 'Vui lòng nhập email.';
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null; // null tức là không có lỗi
    } catch (e) {
      return 'Lỗi: ${e.toString()}';
    }
  }

  void disposeController() {
    emailController.dispose();
  }
}
