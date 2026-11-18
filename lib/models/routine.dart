import 'exercise.dart';

class Routine {
  final String id;
  final String title;
  final List<Exercise> exercises;

  const Routine({
    required this.id,
    required this.title,
    required this.exercises,
  });
}