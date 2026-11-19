import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymbook/main.dart';
import 'package:gymbook/data/dummy_data.dart';
import 'package:gymbook/models/routine.dart';
import 'package:gymbook/services/firestore_service.dart';
import 'package:gymbook/widgets/daily_progress_rings.dart';
import 'package:gymbook/widgets/active_workout_mini_bar.dart';
import 'package:gymbook/widgets/routine_item.dart';
import 'package:gymbook/screens/settings_screen.dart';
import 'package:gymbook/screens/exercises_list_screen.dart';
import 'package:gymbook/screens/progress_screen.dart';
import 'package:gymbook/screens/profile_screen.dart';
import 'package:gymbook/screens/create_routine_screen.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  int currentPageIndex = 0;

  void _agregarRutina() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateRoutineScreen(),
      ),
    );
  }

  Future<void> _cargarRutinasDeEjemplo(String uid) async {
    await addRoutine(
      uid,
      'Día de Pecho y Tríceps',
      [
        ...temp_exercises[0].exercises.take(3).map((e) => e.id),
        ...temp_exercises[3].exercises.take(2).map((e) => e.id),
      ],
    );
    await addRoutine(
      uid,
      'Día de Espalda y Bíceps',
      [
        ...temp_exercises[1].exercises.take(3).map((e) => e.id),
        ...temp_exercises[3].exercises.skip(1).take(2).map((e) => e.id),
      ],
    );
    await addRoutine(
      uid,
      'Día de Pierna (Cuádriceps)',
      temp_exercises[5].exercises.take(4).map((e) => e.id).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

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
        leading: ValueListenableBuilder<String>(
          valueListenable: photoNotifier,
          builder: (context, photo, child) {
            return IconButton(
              icon: photo == ''
                  ? const Icon(Icons.person)
                  : CircleAvatar(
                      radius: 16,
                      backgroundImage: FileImage(File(photo)),
                    ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
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
      body: currentPageIndex == 1
          ? const ExercisesListScreen()
          : currentPageIndex == 2
              ? const ProgressScreen()
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ValueListenableBuilder<String>(
                          valueListenable: nicknameNotifier,
                          builder: (context, nickname, child) {
                            final nombre =
                                FirebaseAuth.instance.currentUser?.displayName ??
                                    '';
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
                        const DailyProgressRings(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _agregarRutina,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDarkMode ? Colors.white : Colors.black,
                          foregroundColor:
                              isDarkMode ? Colors.black : Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Icon(Icons.add, size: 50),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: getRoutinesStream(uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                'Error al cargar rutinas: ${snapshot.error}',
                              ),
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color:
                                    isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          );
                        }

                        final docs = snapshot.data?.docs ?? [];

                        if (docs.isEmpty) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Toca + para crear tu primera rutina.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                              OutlinedButton(
                                onPressed: () => _cargarRutinasDeEjemplo(uid),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      isDarkMode ? Colors.white : Colors.black,
                                  side: BorderSide(
                                    color: isDarkMode
                                        ? Colors.grey[700]!
                                        : Colors.grey[400]!,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: const Text('Cargar rutinas de ejemplo'),
                              ),
                            ],
                          );
                        }

                        final rutinas = docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final rawIds =
                              data['exerciseIds'] as List<dynamic>? ?? [];
                          final ids = rawIds.map((e) => e.toString()).toList();

                          return Routine(
                            id: doc.id,
                            title: data['title'] ?? 'Sin nombre',
                            exercises: findExercisesByIds(ids),
                          );
                        }).toList();

                        return Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Tus rutinas guardadas:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.white70
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...rutinas.map(
                              (rutina) => RoutineItem(routine: rutina),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
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
                  return IconThemeData(
                    color: isDarkMode ? Colors.white : Colors.black,
                  );
                }
                return IconThemeData(
                  color: isDarkMode ? Colors.black : Colors.white,
                );
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