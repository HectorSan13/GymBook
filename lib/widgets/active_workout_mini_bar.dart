import 'package:flutter/material.dart';
import '../services/active_workout_service.dart';
import 'package:provider/provider.dart';
import '../screens/active_workout_screen.dart';

class ActiveWorkoutMiniBar extends StatelessWidget {
  const ActiveWorkoutMiniBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Con Provider escuchamos los cambios del servicio
    return Consumer<ActiveWorkoutService>(
      builder: (context, service, child) {

        // Si no hay entrenamiento activo, no mostramos nada
        if (!service.isWorkoutActive || service.activeRoutine == null) {
          return const SizedBox.shrink();
        }

        final routine = service.activeRoutine!;
        final cardBgColor = isDarkMode ? Colors.white : Colors.black;
        final cardFgColor = isDarkMode ? Colors.black : Colors.white;

        return SafeArea(
          top: false,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActiveWorkoutScreen(routine: routine),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
                  child: Row(
                    children: [
                      // Ícono animado / indicador de estado
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: (service.isTimerRunning ? Colors.green : Colors.orange)
                              .withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          color: service.isTimerRunning ? Colors.green : Colors.orange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Información de la rutina y tiempo
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              routine.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: cardFgColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 13,
                                  color: service.isTimerRunning ? Colors.green : Colors.orange,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  service.formattedDuration,
                                  style: TextStyle(
                                    color: cardFgColor.withOpacity(0.85),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '•  Ej. ${service.currentExerciseIndex + 1}/${routine.exercises.length}',
                                  style: TextStyle(
                                    color: cardFgColor.withOpacity(0.65),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Botón rápido de Play / Pausa
                      IconButton(
                        onPressed: () {
                          service.toggleTimer();
                        },
                        icon: Icon(
                          service.isTimerRunning ? Icons.pause_circle_filled : Icons.play_circle_filled,
                          color: service.isTimerRunning ? Colors.orange : Colors.green,
                          size: 32,
                        ),
                        tooltip: service.isTimerRunning ? 'Pausar' : 'Reanudar',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}