import 'package:flutter/material.dart';
import 'package:gymbook/data/dummy_data.dart';
import 'package:gymbook/models/exercise.dart';
import 'package:gymbook/models/routine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gymbook/services/firestore_service.dart';

class CreateRoutineScreen extends StatefulWidget {
  final Routine? routineToEdit;
  const CreateRoutineScreen({super.key, this.routineToEdit});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<Exercise> _selectedExercises = [];

  @override
  void initState() {
    super.initState();
    if (widget.routineToEdit != null) {
      _nameController.text = widget.routineToEdit!.title;
      _selectedExercises.addAll(widget.routineToEdit!.exercises);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleExercise(Exercise exercise) {
    setState(() {
      final existingIndex = _selectedExercises.indexWhere((e) => e.id == exercise.id);
      if (existingIndex >= 0) {
        _selectedExercises.removeAt(existingIndex);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  Future<void> _saveRoutine() async {
    final routineName = _nameController.text.trim();

    if (routineName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor escribe un nombre para la rutina.')),
      );
      return;
    }

    if (_selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona al menos un ejercicio.')),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final exerciseIds = _selectedExercises.map((e) => e.id).toList();

    if (widget.routineToEdit != null) {
      await updateRoutine(widget.routineToEdit!.id, routineName, exerciseIds);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rutina actualizada correctamente.')),
      );
    } else {
      await addRoutine(uid, routineName, exerciseIds);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rutina guardada en Firebase.')),
      );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isEditing = widget.routineToEdit != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Rutina' : 'Nueva Rutina',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo para el nombre de la rutina
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre de la rutina',
                    hintText: 'Ej. Día de Hombro y Abdomen',
                    prefixIcon: Icon(Icons.edit_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(
                  'Selecciona los ejercicios (${_selectedExercises.length} elegidos):',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Lista por categorías usando temp_exercises
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: temp_exercises.length,
                  itemBuilder: (context, index) {
                    final category = temp_exercises[index];

                    return Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        initiallyExpanded: category.id == 'c1',
                        title: Text(
                          category.title,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        children: category.exercises.map((exercise) {
                          final isSelected = _selectedExercises.any((e) => e.id == exercise.id);

                          return Card(
                            elevation: 0,
                            color: isSelected
                                ? (isDarkMode ? Colors.white : Colors.black)
                                : (isDarkMode ? Colors.grey[900] : Colors.grey[100]),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CheckboxListTile(
                              value: isSelected,
                              activeColor: isDarkMode ? Colors.black : Colors.white,
                              checkColor: isDarkMode ? Colors.white : Colors.black,
                              onChanged: (_) => _toggleExercise(exercise),
                              secondary: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/exercises/${exercise.id}.jpg',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.fitness_center,
                                    color: isSelected
                                        ? (isDarkMode ? Colors.black : Colors.white)
                                        : (isDarkMode ? Colors.white : Colors.black),
                                  ),
                                ),
                              ),
                              title: Text(
                                exercise.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? (isDarkMode ? Colors.black : Colors.white)
                                      : (isDarkMode ? Colors.white : Colors.black87),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),

              // Botón para guardar o actualizar la rutina
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveRoutine,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDarkMode ? Colors.white : Colors.black,
                      foregroundColor: isDarkMode ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      isEditing ? 'Guardar Cambios' : 'Guardar Rutina',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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