import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quanlicongviec/widgets/TextField.dart';
import '../services/auth_service.dart';
import '../themes/colors_themes.dart';
import 'forgotpassword_screen.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColor.backgroundOrange, Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60),
                Center(
                  child: Container(
                    width: 66,
                    height: 66,
                    child: Image.asset("assets/images/icon_for_task_list_with_orange.png"),
                  ),
                ),

                SizedBox(height: 40),

                // Title
                Text(
                  "Đăng Nhập",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColor.darkOrange,
                    letterSpacing: 0.5,
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  "Vui lòng đăng nhập để tiếp tục",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                SizedBox(height: 40),

                // Email field
                buildTextField(
                  controller: emailController,
                  label: "Email",
                  icon: Icons.email_outlined,
                  isPassword: false,
                ),

                SizedBox(height: 20),

                // Password field
                buildTextField(
                  controller: passwordController,
                  label: "Mật khẩu",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) => ForgotPasswordPage()));
                    },
                    child: Text(
                      "Quên mật khẩu?",
                      style: TextStyle(
                        color: AppColor.primaryOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 30),

                // Login button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      User? user = await authService.signInWithEmail(
                        emailController.text,
                        passwordController.text,
                      );
                      if (user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Đăng nhập thất bại"),
                            backgroundColor: AppColor.darkOrange,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryOrange,
                      foregroundColor: Colors.white,
                      elevation: 5,
                      shadowColor: AppColor.primaryOrange,
                      padding: EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "ĐĂNG NHẬP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Hoặc đăng nhập bằng",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 25),

                // Google sign in
                Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        User? user = await authService.signInWithGoogle();
                        if (user != null) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Đăng nhập thất bại"),
                              backgroundColor: AppColor.darkOrange,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black87,
                        backgroundColor: Colors.white,
                        elevation: 3,
                        shadowColor: Colors.grey.withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(color: Colors.grey.withOpacity(0.2)),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/google-icon.png',
                              height: 24, width: 24),
                          SizedBox(width: 12),
                          Text(
                            "Google",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Register link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            RegisterScreen()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Chưa có tài khoản? ",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                            text: "Đăng ký",
                            style: TextStyle(
                              color: AppColor.primaryOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}