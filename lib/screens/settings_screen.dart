import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymbook/main.dart';
import 'package:gymbook/screens/welcome_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gymbook/screens/profile_screen.dart';
import 'package:gymbook/services/user_service.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Alerta para confirmar antes de eliminar la cuenta
  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Eliminar cuenta?'),
        content: const Text('Se borrarán tu cuenta y tus rutinas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await eliminarCuenta();
                photoNotifier.value = '';
                if (context.mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                        (route) => false,
                  );
                }
              } catch (e) {
                // Firebase a veces pide volver a iniciar sesion para borrar la cuenta
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cierra sesión, vuelve a entrar e inténtalo de nuevo.')),
                  );
                }
              }
            },
            child: const Text('Sí, eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ajustes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Boton para ir a la pantalla de perfil
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text(
                      'Perfil',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Preferencias',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder<ThemeMode>(
                    valueListenable: themeNotifier,
                    builder: (context, currentMode, child) {
                      final isDark = currentMode == ThemeMode.dark;
                      return SwitchListTile(
                        title: const Text(
                          'Modo Oscuro',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        value: isDark,
                        activeColor: Colors.white,
                        activeTrackColor: Colors.grey[800],
                        onChanged: (value) {
                          themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // Botones de hasta abajo
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        await GoogleSignIn().signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const WelcomeScreen(),
                            ),
                                (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.white : Colors.black,
                        foregroundColor: isDarkMode ? Colors.black : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      // Pregunta antes de eliminar la cuenta
                      onPressed: () => _confirmarEliminar(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                        foregroundColor: isDarkMode ? Colors.white : Colors.black,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Eliminar cuenta',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}