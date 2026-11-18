import 'package:flutter/material.dart';
import '../models/routine.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final Routine routine;

  const ActiveWorkoutScreen({super.key, required this.routine});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  int _currentExerciseIndex = 0;

  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  //Guarda el peso anterior por ID de ejercicio, siendo que estos solo son valores de prueba
  static final Map<String, String> _pesoAnterior = {
    '0042': '60 kg x 10 reps',
    '0028': '50 kg x 10 reps',
    '0054': '80 kg x 8 reps',
  };

  //Guarda las series anotadas en esta sesión para cada ID de ejercicio
  final Map<String, List<String>> _seriesDeHoy = {};

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _guardarSerie() {
    final peso = _weightController.text.trim();
    final reps = _repsController.text.trim();

    if (peso.isEmpty || reps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el peso y las repeticiones.')),
      );
      return;
    }

    final ejercicioActual = widget.routine.exercises[_currentExerciseIndex];
    final registro = '$peso kg x $reps reps';

    setState(() {
      _seriesDeHoy.putIfAbsent(ejercicioActual.id, () => []);
      _seriesDeHoy[ejercicioActual.id]!.add(registro);
      _pesoAnterior[ejercicioActual.id] = registro;
      _weightController.clear();
      _repsController.clear();
    });

    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Serie guardada: $registro')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final ejercicios = widget.routine.exercises;
    final ejercicioActual = ejercicios[_currentExerciseIndex];
    final seriesActuales = _seriesDeHoy[ejercicioActual.id] ?? [];
    final textoPesoAnterior = _pesoAnterior[ejercicioActual.id] ?? 'Sin registro previo';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.routine.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
            child: Column(
              children: [
                Text(
                  'Ejercicio ${_currentExerciseIndex + 1} de ${ejercicios.length}',
                  style: TextStyle(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),

                Text(
                  ejercicioActual.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    color: Colors.white,
                    child: Image.asset(
                      'assets/images/exercises/${ejercicioActual.id}.jpg',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => SizedBox(
                        height: 200,
                        child: Icon(
                          Icons.fitness_center,
                          size: 80,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                //Tarjeta que tiene el peso anterior
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Peso anterior: $textoPesoAnterior',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                //Campos de Peso y Repeticiones
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _weightController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          labelText: 'Peso (kg)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _repsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Repeticiones',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: _guardarSerie,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.white : Colors.black,
                    foregroundColor: isDarkMode ? Colors.black : Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Guardar Serie',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                //Series registradas hoy
                if (seriesActuales.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Series registradas hoy:',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...seriesActuales.asMap().entries.map(
                        (entry) => Card(
                          elevation: 0,
                          color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              backgroundColor: isDarkMode ? Colors.white : Colors.black,
                              radius: 14,
                              child: Text(
                                '${entry.key + 1}',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.black : Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              entry.value,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                ],

                const SizedBox(height: 24),

                //Navegación entre ejercicios de la rutina
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentExerciseIndex > 0)
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentExerciseIndex--;
                          });
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                        label: Text(
                          'Anterior',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      )
                    else
                      const SizedBox(),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (_currentExerciseIndex < ejercicios.length - 1) {
                          setState(() {
                            _currentExerciseIndex++;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('¡Rutina completada!')),
                          );
                          Navigator.pop(context);
                        }
                      },
                      icon: Icon(
                        _currentExerciseIndex < ejercicios.length - 1
                            ? Icons.arrow_forward
                            : Icons.check,
                      ),
                      label: Text(
                        _currentExerciseIndex < ejercicios.length - 1
                            ? 'Siguiente'
                            : 'Finalizar',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDarkMode ? Colors.white : Colors.black,
                        foregroundColor: isDarkMode ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}