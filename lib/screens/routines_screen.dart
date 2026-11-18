import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymbook/models/routine.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:gymbook/screens/settings_screen.dart';
import 'package:gymbook/widgets/routine_item.dart';
import 'package:gymbook/screens/exercises_list_screen.dart';
import 'package:gymbook/screens/profile_screen.dart';
import 'package:gymbook/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymbook/data/dummy_data.dart';
import 'package:gymbook/screens/create_routine_screen.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  int currentPageIndex = 0;

  final List<Routine> misRutinas = [//Rutinas que apareceran por defecto
    Routine(
      id: 'r1',
      title: 'Día de Pecho y Tríceps',
      exercises: [
        ...temp_exercises[0].exercises.take(3),
        ...temp_exercises[3].exercises.take(2),
      ],
    ),
    Routine(
      id: 'r2',
      title: 'Día de Espalda y Bíceps',
      exercises: [
        ...temp_exercises[1].exercises.take(3),
        ...temp_exercises[3].exercises.skip(1).take(2),
      ],
    ),
    Routine(
      id: 'r3',
      title: 'Día de Pierna (Cuádriceps)',
      exercises: temp_exercises[5].exercises.take(4).toList(),
    ),
  ];

  Future<void> _agregarRutina() async {
    final nuevaRutina = await Navigator.push<Routine>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateRoutineScreen(),
      ),
    );

    //Cuando se de a guardar rutina, la agregamos y refrescamos la pantalla
    if (nuevaRutina != null) {
      setState(() {
        misRutinas.add(nuevaRutina);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          currentPageIndex == 1 ? 'Ejercicios' : 'Mis rutinas',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // Foto de perfil, si no hay foto sale el icono
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
      // Si estamos en la pestaña Ejercicios mostramos el catalogo
      body: currentPageIndex == 1
          ? const ExercisesListScreen()
          : ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // FILA PRINCIPAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // El nombre cambia cuando lo editan en Perfil
              ValueListenableBuilder<String>(
                valueListenable: nicknameNotifier,
                builder: (context, nickname, child) {
                  // Si no ha puesto apodo, sale el nombre con el que se registro
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

              // GRÁFICA
              SizedBox(
                height: 80,
                width: 80,
                child: SfCircularChart(
                  margin: EdgeInsets.zero,
                  series: <CircularSeries>[
                    RadialBarSeries<double, String>(
                      dataSource: const [6500],
                      xValueMapper: (double data, _) => 'Pasos',
                      yValueMapper: (double data, _) => data,
                      pointColorMapper: (double data, _) => Colors.red,
                      maximumValue: 10000,
                      innerRadius: '75%',
                      cornerStyle: CornerStyle.bothCurve,
                      trackColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                    )
                  ],
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.directions_walk,
                            size: 16,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          Text(
                            '6.5k',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.all(16),
          ),

          // Botón gigante del medio
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
                misRutinas.isEmpty
                    ? 'Toca + para crear tu primera rutina.'
                    : 'Tus rutinas guardadas:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...misRutinas.map((rutina) => RoutineItem(routine: rutina)), ///////////////////////7
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
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
            if (index == 0 || index == 1) {
              setState(() {
                currentPageIndex = index;
              });
            } else {
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('Pendiente'),
                  content: Text('Esta sección aún no está funcional.'),
                ),
              );
            }
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
    );
  }
}