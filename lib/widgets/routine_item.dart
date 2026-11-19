import 'package:flutter/material.dart';
import 'package:gymbook/models/routine.dart';
import 'package:gymbook/screens/routine_detail_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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

              // Menú de 3 puntos para Editar y Eliminar
              if (onEdit != null || onDelete != null)
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: isDark ? Colors.grey[850] : Colors.white,
                  onSelected: (value) {
                    if (value == 'edit') onEdit?.call();
                    if (value == 'delete') onDelete?.call();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 10),
                          Text('Editar'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                          SizedBox(width: 10),
                          Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDark ? Colors.white70 : Colors.black54,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
