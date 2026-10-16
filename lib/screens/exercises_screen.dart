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
    // Variable para saber si estamos en modo oscuro o claro y ajustar los colores puros
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
        leadingWidth: 100,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Text(
              'Ejercicios',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                // Texto negro puro en modo claro blanco en oscuro
                color: isDarkMode ? Colors.white : Colors.black,
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

          // Barra inferior
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isDarkMode ? const Color(0xFF1A1A1A) : Colors.white,
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
                    // Botón DINÁMICO
                    backgroundColor: isDarkMode ? Colors.white : Colors.black,
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text('Listo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}