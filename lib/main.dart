import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const GymBookApp());
}

class GymBookApp extends StatelessWidget {
  const GymBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'GymBook',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(), // Muestra nuestra pantalla de bienvenida al abrir
    );
  }
}


