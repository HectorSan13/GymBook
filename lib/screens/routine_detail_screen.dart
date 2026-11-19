import 'package:flutter/material.dart';
import 'active_workout_screen.dart';
import '../models/routine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_routine_screen.dart';
import '../services/firestore_service.dart';

class RoutineDetailScreen extends StatelessWidget {
  final Routine routine;
  const RoutineDetailScreen({super.key, required this.routine});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('rutinas')
          .doc(routine.id)
          .snapshots(),
      builder: (context, snapshot) {
        Routine currentRoutine = routine;

        if (snapshot.hasData &&
            snapshot.data != null &&
            snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final rawIds = data['exerciseIds'] as List<dynamic>? ?? [];
          final ids = rawIds.map((e) => e.toString()).toList();
          currentRoutine = Routine(
            id: snapshot.data!.id,
            title: data['title'] ?? routine.title,
            exercises: findExercisesByIds(ids),
          );
        }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(routine.title),
        actions: [
              IconButton(
                tooltip: 'Editar rutina',
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateRoutineScreen(routineToEdit: currentRoutine),
                    ),
                  );
                },
              ),
            ],
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
    },
    );
  }
}