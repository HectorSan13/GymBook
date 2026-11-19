import 'package:flutter/material.dart';
import 'package:gymbook/models/routine.dart';
import 'package:gymbook/screens/routine_detail_screen.dart';
import 'package:gymbook/screens/create_routine_screen.dart';
import 'package:gymbook/services/firestore_service.dart';

class RoutineItem extends StatelessWidget {
  final Routine routine;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const RoutineItem({
    super.key,
    required this.routine,
    this.onEdit,
    this.onDelete,
  });

  void _confirmDelete(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        title: Text(
          'Eliminar rutina',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          '¿Seguro que quieres eliminar "${routine.title}"?',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await deleteRoutine(routine.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Rutina eliminada.')),
                );
              }
            },
            child: Text(
              'Eliminar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoutineDetailScreen(routine: routine),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDark ? Colors.grey[900] : Colors.grey[100],
          ),
          child: Row(
            children: [
              // Ícono de gimnasio
              CircleAvatar(
                radius: 22,
                backgroundColor: isDark ? Colors.grey[800] : Colors.white,
                child: Icon(
                  Icons.fitness_center,
                  color: isDark ? Colors.white : Colors.black,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),

              // Información de la rutina
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routine.title,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${routine.exercises.length} ejercicios',
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Editar rutina',
                icon: Icon(Icons.edit_outlined, color: iconColor, size: 22),
                onPressed: () {
                  if (onEdit != null) {
                    onEdit!();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CreateRoutineScreen(routineToEdit: routine),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                tooltip: 'Eliminar rutina',
                icon: Icon(Icons.delete_outline, color: iconColor, size: 22),
                onPressed: () {
                  if (onDelete != null) {
                    onDelete!();
                  } else {
                    _confirmDelete(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}