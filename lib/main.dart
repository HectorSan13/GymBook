import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:gymbook/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'package:gymbook/services/progress_service.dart';
import 'package:gymbook/services/active_workout_service.dart';

// Notificador global para controlar el tema en toda la app
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);
// Datos del perfil de mientras lo pasamos a firebase
final ValueNotifier<String> nicknameNotifier = ValueNotifier('');
final ValueNotifier<String> photoNotifier = ValueNotifier('');


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    // Provider los servicios quedan disponibles en toda la app
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ProgressService.instance),
        ChangeNotifierProvider.value(value: ActiveWorkoutService.instance),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'GymBook',
          themeMode: currentMode,
          // Tema Claro
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
          ),
          // Tema Oscuro
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
          ),
          home: const WelcomeScreen(),
        );
      },
    );
  }
}