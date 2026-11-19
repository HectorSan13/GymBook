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

  Routine copyWith({
    String? id,
    String? title,
    List<Exercise>? exercises,
  }) {
    return Routine(
      id: id ?? this.id,
      title: title ?? this.title,
      exercises: exercises ?? this.exercises,
    );
  }

  // Serialización para Cloud Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'exerciseIds': exercises.map((e) => e.id).toList(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory Routine.fromMap(
    String id,
    Map<String, dynamic> map,
    List<Exercise> catalogExercises,
  ) {
    final List<dynamic> ids = map['exerciseIds'] ?? [];
    final List<Exercise> resolved = [];

    for (final dynamic item in ids) {
      final String exId = item.toString();
      final found = catalogExercises.firstWhere(
        (e) => e.id == exId,
        orElse: () => Exercise(
          id: exId,
          name: 'Ejercicio ($exId)',
          category: 'General',
          target: 'General',
          secondaryMuscles: const [],
          equipment: 'General',
          difficulty: 'Intermedio',
          type: 'Fuerza',
          description: '',
          instructions: const [],
        ),
      );
      resolved.add(found);
    }

    return Routine(
      id: id,
      title: map['title'] ?? 'Rutina',
      exercises: resolved,
    );
  }
}
