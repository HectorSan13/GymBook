import 'package:flutter/material.dart';
import '../models/routine.dart';
import '../services/active_workout_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';

class ActiveWorkoutScreen extends StatefulWidget {
  final Routine routine;

  const ActiveWorkoutScreen({super.key, required this.routine});

  @override
  State<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends State<ActiveWorkoutScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _repsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Inicia el entrenamiento en el servicio global si aún no está corriendo
    ActiveWorkoutService.instance.startWorkout(widget.routine);
  }

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  Future<void> _guardarSerie() async {
    final peso = _weightController.text.trim();
    final reps = _repsController.text.trim();

    if (peso.isEmpty || reps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa el peso y las repeticiones.')),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
    final service = ActiveWorkoutService.instance;
    final ejercicioActual = widget.routine.exercises[service.currentExerciseIndex];
    final registro = '$peso kg x $reps reps';

    service.addSet(ejercicioActual.id, registro);

    _weightController.clear();
    _repsController.clear();
    FocusScope.of(context).unfocus();

    await saveExerciseProgress(
      uid: uid,
      routineId: widget.routine.id,
      routineTitle: widget.routine.title,
      exerciseId: ejercicioActual.id,
      exerciseName: ejercicioActual.name,
      peso: peso,
      reps: reps,
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Serie guardada en Firebase: $registro')),
    );
  }

  // Finalizar entrenamiento y registrar calorías + tiempo en Progreso
  Future<void> _finalizarEntrenamiento() async {
    final service = ActiveWorkoutService.instance;
    final session = service.finishWorkout();

    if (session == null) {
      Navigator.pop(context);
      return;
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Mostrar diálogo de felicitación y resumen
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
            const SizedBox(width: 10),
            Text(
              '¡Entrenamiento listo!',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Has completado tu rutina "${session.routineTitle}".',
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.timer, color: Colors.green),
                      const SizedBox(height: 4),
                      Text(
                        '${session.durationMinutes} min',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Text('Tiempo', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.local_fire_department, color: Colors.redAccent),
                      const SizedBox(height: 4),
                      Text(
                        '${session.caloriesBurned} kcal',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Text('Calorías', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tus metas diarias han sido actualizadas.',
              style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.white54 : Colors.black54),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // Cierra diálogo
              Navigator.pop(context); // Regresa a pantalla anterior
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.white : Colors.black,
              foregroundColor: isDarkMode ? Colors.black : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Aceptar', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmarDescartar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        title: const Text('¿Descartar entrenamiento?'),
        content: const Text('El tiempo transcurrido y las series registradas no se guardarán.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Continuar',
              style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ActiveWorkoutService.instance.cancelWorkout();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Descartar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

    // Con Provider escuchamos los cambios del servicio
    return Consumer<ActiveWorkoutService>(
      builder: (context, service, child) {
        final ejercicios = widget.routine.exercises;
        final index = service.currentExerciseIndex;
        final ejercicioActual = ejercicios[index];
        final seriesActuales = service.seriesDeHoy[ejercicioActual.id] ?? [];
        final textoPesoAnterior = service.pesoAnterior[ejercicioActual.id] ?? 'Sin registro previo';

        return Scaffold(
          appBar: AppBar(
            // Flecha hacia abajo para minimizar y volver a la pantalla de Rutinas
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
              tooltip: 'Minimizar entrenamiento',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            title: Text(
              widget.routine.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            actions: [
              TextButton.icon(
                onPressed: _finalizarEntrenamiento,
                icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                label: const Text(
                  'Finalizar',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'discard') _confirmarDescartar();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'discard',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                        SizedBox(width: 8),
                        Text('Descartar sesión', style: TextStyle(color: Colors.redAccent)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Column(
                  children: [
                    // BANNER DEL CRONÓMETRO (con controles)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: service.isTimerRunning
                              ? Colors.green.withOpacity(0.5)
                              : Colors.orange.withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.timer_outlined,
                                color: service.isTimerRunning ? Colors.green : Colors.orange,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                service.formattedDuration,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              service.toggleTimer();
                            },
                            icon: Icon(
                              service.isTimerRunning
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_filled,
                              color: service.isTimerRunning ? Colors.orange : Colors.green,
                              size: 32,
                            ),
                            tooltip: service.isTimerRunning ? 'Pausar' : 'Reanudar',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    Text(
                      'Ejercicio ${index + 1} de ${ejercicios.length}',
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
                        fontSize: 26,
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
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => SizedBox(
                            height: 180,
                            child: Icon(
                              Icons.fitness_center,
                              size: 80,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Tarjeta de peso anterior
                    StreamBuilder<DocumentSnapshot>(
                      stream: getLastExerciseProgressStream(uid, ejercicioActual.id),
                      builder: (context, snapshot) {
                        String pesoDesdeFirebase = 'Sin registro previo';

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          pesoDesdeFirebase = 'Cargando...';
                        } else if (snapshot.hasData &&
                            snapshot.data != null &&
                            snapshot.data!.exists) {
                          final data = snapshot.data!.data() as Map<String, dynamic>;
                          pesoDesdeFirebase = data['registro'] ?? 'Sin registro previo';
                        }

                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey[900]
                                : Colors.grey[100],
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
                              Flexible(
                                child: Text(
                                  'Peso anterior: $pesoDesdeFirebase',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // Inputs de Peso y Repeticiones
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
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Guardar Serie',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Series registradas hoy
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

                    // Navegación entre ejercicios
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (index > 0)
                          OutlinedButton.icon(
                            onPressed: () => service.previousExercise(),
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
                            if (index < ejercicios.length - 1) {
                              service.nextExercise();
                            } else {
                              _finalizarEntrenamiento();
                            }
                          },
                          icon: Icon(
                            index < ejercicios.length - 1 ? Icons.arrow_forward : Icons.check,
                          ),
                          label: Text(
                            index < ejercicios.length - 1 ? 'Siguiente' : 'Finalizar',
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
      },
    );
  }
}