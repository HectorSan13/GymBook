import 'package:flutter/material.dart';
import 'package:gymbook/models/exercise.dart';
import 'package:gymbook/screens/exercise_detail_screen.dart';

// Tarjeta de un ejercicio en la pestaña Ejercicios
class ExerciseInfoItem extends StatelessWidget {
  const ExerciseInfoItem({super.key, required this.exercise});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        // Abrimos el detalle del ejercicio
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseDetailScreen(exercise: exercise),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Foto del ejercicio, se busca con su id
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/exercises/${exercise.id}.jpg',
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                    const SizedBox(height: 4),
                     Text('${exercise.difficulty} - ${exercise.equipment}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}