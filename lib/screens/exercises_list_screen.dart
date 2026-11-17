import 'package:flutter/material.dart';
import 'package:gymbook/data/dummy_data.dart';
import 'package:gymbook/widgets/exercise_info_item.dart';

// Contenido de la pestaña Ejercicios
class ExercisesListScreen extends StatelessWidget {
  const ExercisesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: temp_exercises.length,
      itemBuilder: (ctx, index) {
        final category = temp_exercises[index];


        return Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text(
              category.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            children: category.exercises.map((exercise) {
              return ExerciseInfoItem(exercise: exercise);
            }).toList(),
          ),
        );
      },
    );
  }
}