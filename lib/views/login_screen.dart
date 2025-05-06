import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quanlicongviec/widgets/TextField.dart';
import '../services/auth_service.dart';
import 'forgotpassword_screen.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  final Color orangeColor = Color(0xFFF5A623);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Text(
                "Đăng nhập",
                style: TextStyle(
                  fontSize: 55,
                  fontWeight: FontWeight.bold,
                  color: Colors.orangeAccent,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Vui lòng đăng nhập để tiếp tục",
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 111),
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
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                }, child: Text("Quên mật khẩu?"),
                ),
              ),
              Center(
                child: TextButton(
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
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đăng nhập thất bại")),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
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
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 33, vertical: 14),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ĐĂNG NHẬP',
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
              SizedBox(height: 60),
              Center(
                child: Text(
                      "Hoặc đăng nhập bằng",
                      style: TextStyle(color: Colors.grey[600]),
                ),),
              SizedBox(height: 20,),
              Center(
                child: ElevatedButton(
                    onPressed: () async {
                      User? user = await authService.signInWithGoogle();
                      if (user!= null) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Đăng nhập thất bại")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Image.asset('assets/images/google-icon.png', height: 55, width: 44),
                  ),
              ),

              SizedBox(height: 33),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Chưa có tài khoản? ",
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Đăng ký",
                          style: TextStyle(color: orangeColor),
                        ),
                      ]
                    )
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
