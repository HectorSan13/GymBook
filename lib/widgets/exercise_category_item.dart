import 'package:flutter/material.dart';
import 'package:gymbook/models/exercise_category.dart';
import 'exercise_selection_item.dart';

class ExerciseCategoryItem extends StatelessWidget {
  const ExerciseCategoryItem({
    super.key,
    required this.category,
    required this.selectedExerciseIds,
    required this.onToggleExercise,
  });

  final ExerciseCategory category;
  final List<String> selectedExerciseIds;
  final Function(String exerciseId) onToggleExercise;

  @override
  Widget build(BuildContext context) {
    // Variable para detectar el modo oscuro
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          category.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            // Texto dinámico
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        initiallyExpanded: category.title == 'Pecho',
        children: category.exercises.map((exercise) {
          final isSelected = selectedExerciseIds.contains(exercise.id);
          return ExerciseSelectionItem(
            exercise: exercise,
            isSelected: isSelected,
            onTap: () => onToggleExercise(exercise.id),
          );
        }).toList(),
      ),
    );
  }
}