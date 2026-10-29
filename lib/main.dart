import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

// Variable global para controlar el Modo Oscuro desde
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'GymBook',
          debugShowCheckedModeBanner: false,

          // TEMA CLARO
          theme: ThemeData(
            brightness: Brightness.light,
          ),

          // TEMA OSCURO
          darkTheme: ThemeData(
            brightness: Brightness.dark,
          ),

          // Conectamos el modo de la app con la variable global
          themeMode: currentMode,

          home: const WelcomeScreen(),
        );
      },
    );
  }
}