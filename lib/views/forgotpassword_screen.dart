
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/forgot_password.dart';

class ForgotPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordViewModel(),
      child: Scaffold(
        appBar: AppBar(title: Text('Quên mật khẩu')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<ForgotPasswordViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                children: [
                  TextField(
                    controller: viewModel.emailController,
                    decoration: InputDecoration(labelText: 'Nhập email'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await viewModel.resetPassword();
                      final message = result ?? 'Đã gửi email khôi phục mật khẩu';

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    },
                    child: Text('Gửi mã khôi phục'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
