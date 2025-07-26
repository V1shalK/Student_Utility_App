import 'package:flutter/material.dart';
import 'Login_Signup.dart';

void main() {
  runApp(const CGPATrackerApp());
}

class CGPATrackerApp extends StatelessWidget {
  const CGPATrackerApp({super.key});

  final Color backgroundColor = const Color(0xFFf7f5ef);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CGPA Tracker App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        useMaterial3: true,
      ),
      // The app starts with the LoginPage
      home: const LoginPage(),
    );
  }
}