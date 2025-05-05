import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quanlicongviec/view_models/navigation_provider.dart';
import 'package:quanlicongviec/view_models/task_provider.dart';
import 'package:quanlicongviec/views/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:quanlicongviec/views/login_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => NavigationViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return  HomeScreen(); // Nếu đã đăng nhập, vào màn hình chính
            }
            return  LoginScreen(); // Nếu chưa đăng nhập, hiển thị màn hình đăng nhập
          },
        ),
      ),
    );
  }
}