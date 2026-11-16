class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.target,
    required this.secondaryMuscles,
    required this.equipment,
    required this.difficulty,
    required this.type,
    required this.description,
    required this.instructions,
  });
// agregue nuevas condiciones para cada campo con lo que nos paso Dorx 
  final String id;
  final String name;
  final String category;
  final String target;
  final List<String> secondaryMuscles;
  final String equipment;
  final String difficulty;
  final String type;
  final String description;
  final List<String> instructions;
}