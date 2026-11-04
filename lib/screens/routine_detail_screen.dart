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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode 
                ? [const Color(0xFF0A192F), Colors.blueGrey.shade900]
                : [Colors.indigo.shade900, Colors.blue.shade800], // Fondo azul marino
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Ejercicios de la rutina:',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: dummyExercises.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white.withOpacity(0.1),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: const Icon(Icons.fitness_center, color: Colors.white),
                        title: Text(
                          dummyExercises[index],
                          style: const TextStyle(color: Colors.white, fontSize: 16),
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
                      backgroundColor: Colors.indigo.shade900, // Botón azul marino
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.blueAccent, width: 1), // Borde ligero para destacar
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
                        style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}