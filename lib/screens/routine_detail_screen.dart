import 'package:flutter/material.dart';
import 'active_workout_screen.dart';
import '../models/routine.dart';

class RoutineDetailScreen extends StatelessWidget {
  final Routine routine;
  const RoutineDetailScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(routine.title),
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
                itemCount: routine.exercises.length,
                itemBuilder: (context, index) {
                  final ejercicio = routine.exercises[index];
                  return Card(
                    color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/images/exercises/${ejercicio.id}.jpg',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.fitness_center,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                      title: Text(
                        ejercicio.name,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
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
                        builder: (context) => ActiveWorkoutScreen(routine: routine),
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