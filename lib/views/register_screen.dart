import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/TextField.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final AuthService authService = AuthService();

  final Color orangeColor = Color(0xFFF5A623);

  void validatePassword(String password) {
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mật khẩu phải có ít nhất 6 ký tự")),
      );
    }
    else if (password != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mật khẩu không khớp")),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Đăng ký thành công")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Đăng ký",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold,color: orangeColor),
                ),
                SizedBox(height: 8),
                Text(
                  "Tạo tài khoản mới để tiếp tục",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 44),
                MyTextField(
                  Controller: nameController,
                  label: "Tên",
                  obscureText: false,
                ),
                SizedBox(height: 16),
                MyTextField(
                  Controller: emailController,
                  label: "Email",
                  obscureText: false,
                ),
                SizedBox(height: 16),
                MyTextField(
                  Controller: passwordController,
                  label: "Mật khẩu",
                  obscureText: true,
                ),
                SizedBox(height: 16),
                MyTextField(
                  Controller: confirmPasswordController,
                  label: "Vui lòng xác nhận mật khẩu",
                  obscureText: true,
                ),
                SizedBox(height: 32),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      await authService.signUpWithEmail(
                        emailController.text,
                        passwordController.text,
                        nameController.text,
                      );
                      validatePassword(passwordController.text);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFF2C392),
                            Color(0xFFCC5A3F),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "ĐĂNG KÝ",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24,),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Đã có tài khoản",
                        style: TextStyle(color : Colors.black),
                        children: [
                          TextSpan(
                            text: " Đăng nhập",
                            style: TextStyle(color: Colors.orange)
                          )
                        ]
                      )
                    )
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}