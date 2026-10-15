import 'package:flutter/material.dart';
import 'package:gymbook/data/dummy_data.dart';
import 'package:gymbook/widgets/exercise_category_item.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final List<String> _selectedExerciseIds = [];

  void _toggleExerciseSelection(String exerciseId) {
    setState(() {
      if (_selectedExerciseIds.contains(exerciseId)) {
        _selectedExerciseIds.remove(exerciseId);
      } else {
        _selectedExerciseIds.add(exerciseId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        leadingWidth: 80,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Text(
              'Ejercicios',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: temp_exercises.length,
              itemBuilder: (ctx, index) {
                final category = temp_exercises[index];

                return ExerciseCategoryItem(
                  category: category,
                  selectedExerciseIds: _selectedExerciseIds,
                  onToggleExercise: _toggleExerciseSelection,
                );
              },
            ),
          ),
          
          // Barra inferior de confirmación
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedExerciseIds.length} ejercicios',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectedExerciseIds.isEmpty
                      ? null
                      : () {
                          Navigator.of(context).pop(_selectedExerciseIds);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Listo', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}