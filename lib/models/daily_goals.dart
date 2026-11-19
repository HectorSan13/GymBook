class DailyGoals {
  final int targetCalories;
  final int targetMinutes;

  const DailyGoals({
    this.targetCalories = 500,
    this.targetMinutes = 45,
  });

  DailyGoals copyWith({
    int? targetCalories,
    int? targetMinutes,
  }) {
    return DailyGoals(
      targetCalories: targetCalories ?? this.targetCalories,
      targetMinutes: targetMinutes ?? this.targetMinutes,
    );
  }

  // Preparado para Firestore
  Map<String, dynamic> toMap() {
    return {
      'targetCalories': targetCalories,
      'targetMinutes': targetMinutes,
    };
  }

  factory DailyGoals.fromMap(Map<String, dynamic> map) {
    return DailyGoals(
      targetCalories: map['targetCalories'] ?? 500,
      targetMinutes: map['targetMinutes'] ?? 45,
    );
  }
}
