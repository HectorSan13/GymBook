import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';

void main() {
  runApp(const GymBookApp());
}

class GymBookApp extends StatelessWidget {
  const GymBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GymBook',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const WelcomeScreen(),
    );
  }
}
