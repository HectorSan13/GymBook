import 'exercise.dart';

class ExerciseCategory {
  const ExerciseCategory({
    required this.id,
    required this.title,
    required this.exercises,
  });
  
  final String id;
  final String title;
  final List<Exercise> exercises;
}