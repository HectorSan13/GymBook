import 'package:flutter/material.dart';
import 'package:gymbook/screens/routine_detail_screen.dart';

class RoutineItem extends StatelessWidget {
  final String title;

  const RoutineItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RoutineDetailScreen(routineName: title),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: isDark ? Colors.grey[900] : Colors.grey[100],
          ),
          child: Row(
            children: [
              Icon(Icons.fitness_center, color: isDark ? Colors.white : Colors.black, size: 30),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: isDark ? Colors.white : Colors.black, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}