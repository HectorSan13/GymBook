import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/exercise.dart';
import '../models/routine.dart';

class CreateRoutineScreen extends StatefulWidget {
  final Routine? routineToEdit;

  const CreateRoutineScreen({super.key, this.routineToEdit});

  @override
  State<CreateRoutineScreen> createState() => _CreateRoutineScreenState();
}

class _CreateRoutineScreenState extends State<CreateRoutineScreen> {
  late final TextEditingController _nameController;
  final List<Exercise> _selectedExercises = [];

  bool get isEditing => widget.routineToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.routineToEdit?.title ?? '',
    );
    if (widget.routineToEdit != null) {
      // Mapeamos los ejercicios existentes buscando coincidencias por ID
      final catalogExercises = temp_exercises.expand((cat) => cat.exercises).toList();
      for (final existingEx in widget.routineToEdit!.exercises) {
        final match = catalogExercises.firstWhere(
          (catEx) => catEx.id == existingEx.id,
          orElse: () => existingEx,
        );
        _selectedExercises.add(match);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleExercise(Exercise exercise) {
    setState(() {
      final exists = _selectedExercises.any((e) => e.id == exercise.id);
      if (exists) {
        _selectedExercises.removeWhere((e) => e.id == exercise.id);
      } else {
        _selectedExercises.add(exercise);
      }
    });
  }

  void _saveRoutine() {
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

    final rutinaResult = Routine(
      id: widget.routineToEdit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: routineName,
      exercises: List.from(_selectedExercises),
    );

    Navigator.pop(context, rutinaResult);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Editar Rutina' : 'Nueva Rutina',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
