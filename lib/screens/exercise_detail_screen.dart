import 'package:flutter/material.dart';
import 'package:gymbook/models/exercise.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final Exercise exercise;
  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          exercise.category,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          // Foto del ejercicio de lado a lado (las fotos tienen fondo blanco)
          Container(
            color: Colors.white,
            child: Image.asset(
              'assets/images/exercises/${exercise.id}.jpg',
              height: 280,
              width: double.infinity,
              fit: BoxFit.contain,
              // Si no encuentra la foto mostramos un icono
              errorBuilder: (context, error, stackTrace) =>
              const SizedBox(height: 280, child: Icon(Icons.fitness_center, size: 80)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre
                Text(
                  exercise.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 6),

                // Datos en una sola linea
                Text(
                  '${exercise.target} - ${exercise.equipment} - ${exercise.difficulty}',
                  style: TextStyle(
                    fontSize: 15,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),

                // Musculos secundarios (algunos ejercicios no tienen)
                Text(
                  exercise.secondaryMuscles.isEmpty
                      ? 'Músculos secundarios: ninguno'
                      : 'Músculos secundarios: ${exercise.secondaryMuscles.join(', ')}',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),

                const Divider(height: 40),

                // Descripcion
                Text(
                  'Descripción',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  exercise.description,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.4,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),

                const Divider(height: 40),

                // Pasos con su numero en un circulito
                Text(
                  'Cómo hacerlo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                // Igual que con misRutinas, usamos ... y map para hacer un Row por cada paso
                ...exercise.instructions.map((paso) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 13,
                        backgroundColor: isDarkMode ? Colors.white : Colors.black,
                        child: Text(
                          '${exercise.instructions.indexOf(paso) + 1}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          paso,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.4,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}