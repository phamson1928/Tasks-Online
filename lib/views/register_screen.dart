import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../widgets/TextField.dart';
import 'package:quanlicongviec/themes/colors_themes.dart';
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

  void validatePassword(String password) {
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mật khẩu phải có ít nhất 6 ký tự"),
          backgroundColor: AppColor.darkOrange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    else if (password != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Mật khẩu không khớp"),
          backgroundColor: AppColor.darkOrange,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Đăng ký thành công"),
          backgroundColor: Colors.green[600],
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),

                  // Back button
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColor.primaryOrange,
                        size: 20,
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // Title
                  Text(
                    "Tạo Tài Khoản",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColor.darkOrange,
                      letterSpacing: 0.5,
                    ),
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Vui lòng điền thông tin của bạn",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Form fields with custom styling
                  buildTextField(
                    controller: nameController,
                    label: "Họ và tên",
                    icon: Icons.person_outline,
                    isPassword: false,
                  ),

                  SizedBox(height: 20),

                  buildTextField(
                    controller: emailController,
                    label: "Email",
                    icon: Icons.email_outlined,
                    isPassword: false,
                  ),

                  SizedBox(height: 20),

                  buildTextField(
                    controller: passwordController,
                    label: "Mật khẩu",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  SizedBox(height: 20),

                  buildTextField(
                    controller: confirmPasswordController,
                    label: "Xác nhận mật khẩu",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  SizedBox(height: 40),

                  // Register button
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        await authService.signUpWithEmail(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                        );
                        validatePassword(passwordController.text);
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
                            "ĐĂNG KÝ",
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}