import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymbook/models/routine.dart';
import 'package:gymbook/widgets/daily_progress_rings.dart';
import 'package:gymbook/widgets/active_workout_mini_bar.dart';
import 'package:gymbook/screens/settings_screen.dart';
import 'package:gymbook/widgets/routine_item.dart';
import 'package:gymbook/screens/exercises_list_screen.dart';
import 'package:gymbook/screens/progress_screen.dart';
import 'package:gymbook/screens/profile_screen.dart';
import 'package:gymbook/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymbook/screens/create_routine_screen.dart';
import 'package:gymbook/services/routines_service.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  int currentPageIndex = 0;
  List<Routine> _misRutinas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarRutinas();
  }

  // Cargar rutinas desde Cloud Firestore
  Future<void> _cargarRutinas() async {
    setState(() => _isLoading = true);
    try {
      final rutinas = await RoutinesService.instance.fetchRoutines();
      if (mounted) {
        setState(() {
          _misRutinas = rutinas;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // CREAR (Create)
  Future<void> _agregarRutina() async {
    final nuevaRutina = await Navigator.push<Routine>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateRoutineScreen(),
      ),
    );

    if (nuevaRutina != null) {
      await RoutinesService.instance.createRoutine(
        title: nuevaRutina.title,
        exercises: nuevaRutina.exercises,
      );
      await _cargarRutinas();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rutina "${nuevaRutina.title}" guardada en Firebase.')),
        );
      }
    }
  }

  // EDITAR (Update)
  Future<void> _editarRutina(Routine rutina) async {
    final rutinaEditada = await Navigator.push<Routine>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateRoutineScreen(routineToEdit: rutina),
      ),
    );

    if (rutinaEditada != null) {
      await RoutinesService.instance.updateRoutine(rutinaEditada);
      await _cargarRutinas();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rutina "${rutinaEditada.title}" actualizada.')),
        );
      }
    }
  }

  // ELIMINAR (Delete)
  Future<void> _eliminarRutina(Routine rutina) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: const Text('¿Eliminar rutina?'),
        content: Text('Se eliminará "${rutina.title}" de tu cuenta permanentemente.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancelar',
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await RoutinesService.instance.deleteRoutine(rutina.id);
      await _cargarRutinas();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rutina "${rutina.title}" eliminada.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          currentPageIndex == 1
              ? 'Ejercicios'
              : currentPageIndex == 2
                  ? 'Progreso'
                  : 'Mis rutinas',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // Foto de perfil
        leading: ValueListenableBuilder<String>(
          valueListenable: photoNotifier,
          builder: (context, photo, child) {
            return IconButton(
              icon: photo == ''
                  ? const Icon(Icons.person)
                  : CircleAvatar(radius: 16, backgroundImage: FileImage(File(photo))),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      // Pestañas: 0 = Rutinas, 1 = Ejercicios, 2 = Progreso
      body: currentPageIndex == 1
          ? const ExercisesListScreen()
          : currentPageIndex == 2
              ? const ProgressScreen()
              : RefreshIndicator(
                  // PULL TO REFRESH / SWIPE DOWN
                  onRefresh: _cargarRutinas,
                  color: isDarkMode ? Colors.white : Colors.black,
                  backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    children: [
                      // FILA PRINCIPAL: Saludo + Anillos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: nicknameNotifier,
                            builder: (context, nickname, child) {
                              final nombre = FirebaseAuth.instance.currentUser?.displayName ?? '';
                              return Text(
                                nickname == '' ? nombre : nickname,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                          // CÍRCULOS DE PROGRESO DIARIO (KCAL Y TIEMPO)
                          const DailyProgressRings(),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Botón gigante para agregar rutina
                      Center(
                        child: ElevatedButton(
                          onPressed: _agregarRutina,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDarkMode ? Colors.white : Colors.black,
                            foregroundColor: isDarkMode ? Colors.black : Colors.white,
                            padding: const EdgeInsets.all(20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Icon(Icons.add, size: 50),
                        ),
                      ),

                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            _misRutinas.isEmpty
                                ? 'Toca + para crear tu primera rutina.'
                                : 'Tus rutinas guardadas (Desliza abajo para recargar):',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // LISTA DE RUTINAS CON CRUD
                      if (_isLoading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(24.0),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_misRutinas.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Text(
                              'Aún no tienes rutinas registradas.',
                              style: TextStyle(color: isDarkMode ? Colors.white54 : Colors.black54),
                            ),
                          ),
                        )
                      else
                        ..._misRutinas.map(
                          (rutina) => RoutineItem(
                            routine: rutina,
                            onEdit: () => _editarRutina(rutina),
                            onDelete: () => _eliminarRutina(rutina),
                          ),
                        ),
                    ],
                  ),
                ),

      // BARRA INFERIOR CON MINI-NAVBAR FLOTANTE DE ENTRENAMIENTO ACTIVO
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ActiveWorkoutMiniBar(),
          NavigationBarTheme(
            data: NavigationBarThemeData(
              labelTextStyle: WidgetStateProperty.all(
                TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                  fontSize: 12,
                ),
              ),
              iconTheme: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return IconThemeData(color: isDarkMode ? Colors.white : Colors.black);
                }
                return IconThemeData(color: isDarkMode ? Colors.black : Colors.white);
              }),
            ),
            child: NavigationBar(
              backgroundColor: isDarkMode ? Colors.white : Colors.black,
              indicatorColor: isDarkMode ? Colors.black : Colors.white,
              selectedIndex: currentPageIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.fitness_center),
                  label: 'Rutinas',
                ),
                NavigationDestination(
                  icon: Icon(Icons.list_alt),
                  label: 'Ejercicios',
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart),
                  label: 'Progreso',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
