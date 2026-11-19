class WorkoutSession {
  final String id;
  final DateTime date;
  final int durationMinutes;
  final int caloriesBurned;
  final String routineId;
  final String routineTitle;

  const WorkoutSession({
    required this.id,
    required this.date,
    required this.durationMinutes,
    required this.caloriesBurned,
    required this.routineId,
    required this.routineTitle,
  });

  // Listo para integración futura con Cloud Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'durationMinutes': durationMinutes,
      'caloriesBurned': caloriesBurned,
      'routineId': routineId,
      'routineTitle': routineTitle,
    };
  }

  factory WorkoutSession.fromMap(Map<String, dynamic> map) {
    return WorkoutSession(
      id: map['id'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      durationMinutes: map['durationMinutes'] ?? 0,
      caloriesBurned: map['caloriesBurned'] ?? 0,
      routineId: map['routineId'] ?? '',
      routineTitle: map['routineTitle'] ?? '',
    );
  }
}
