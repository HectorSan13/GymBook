import 'package:flutter/material.dart';
import 'active_workout_screen.dart';

class RoutineDetailScreen extends StatelessWidget {
  final String routineName;
  const RoutineDetailScreen({super.key, required this.routineName});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    //Para mostrar como se miraria
    final List<String> dummyExercises = [
      'Press de banca plana',
      'Press inclinado con mancuernas',
      'Cristos en polea',
      'Fondos en paralelas',
      'Press militar sentado'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(routineName),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Ejercicios de la rutina:',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: dummyExercises.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: Icon(Icons.fitness_center, color: isDarkMode ? Colors.white : Colors.black),
                      title: Text(
                        dummyExercises[index],
                        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.white : Colors.black,
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ActiveWorkoutScreen(),
                      ),
                    );
                  },
                  child: const Text('Empezar a trabajar',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}