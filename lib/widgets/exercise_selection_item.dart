import 'package:flutter/material.dart';
import 'package:gymbook/models/exercise.dart';

class ExerciseSelectionItem extends StatelessWidget {
  const ExerciseSelectionItem({
    super.key,
    required this.exercise,
    required this.isSelected,
    required this.onTap
  });

  final Exercise exercise;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                exercise.name,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}