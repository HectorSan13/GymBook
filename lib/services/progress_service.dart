import 'package:flutter/foundation.dart';
import '../models/workout_session.dart';
import '../models/daily_goals.dart';

class ProgressService extends ChangeNotifier {
  // Instancia única (Singleton)
  static final ProgressService instance = ProgressService._internal();

  ProgressService._internal() {
    _initSampleData();
  }

  DailyGoals _dailyGoals = const DailyGoals(
    targetCalories: 500,
    targetMinutes: 45,
  );

  final List<WorkoutSession> _sessions = [];

  DailyGoals get dailyGoals => _dailyGoals;
  List<WorkoutSession> get sessions => List.unmodifiable(_sessions);

  void _initSampleData() {
    final now = DateTime.now();
    // Datos de muestra para visualizar el progreso y el calendario
    _sessions.addAll([
      WorkoutSession(
        id: 'sample-1',
        date: DateTime(now.year, now.month, now.day, 8, 30),
        durationMinutes: 30,
        caloriesBurned: 240,
        routineId: 'r1',
        routineTitle: 'Día de Pecho y Tríceps',
      ),
      WorkoutSession(
        id: 'sample-2',
        date: DateTime(now.year, now.month, now.day - 2, 9, 0),
        durationMinutes: 50,
        caloriesBurned: 420,
        routineId: 'r2',
        routineTitle: 'Día de Espalda y Bíceps',
      ),
      WorkoutSession(
        id: 'sample-3',
        date: DateTime(now.year, now.month, now.day - 4, 18, 15),
        durationMinutes: 40,
        caloriesBurned: 350,
        routineId: 'r3',
        routineTitle: 'Día de Pierna (Cuádriceps)',
      ),
    ]);
  }

  // Calorías acumuladas hoy
  int get todayCalories {
    final now = DateTime.now();
    return _sessions
        .where((s) => _isSameDay(s.date, now))
        .fold(0, (sum, s) => sum + s.caloriesBurned);
  }

  // Minutos acumulados hoy
  int get todayMinutes {
    final now = DateTime.now();
    return _sessions
        .where((s) => _isSameDay(s.date, now))
        .fold(0, (sum, s) => sum + s.durationMinutes);
  }

  // Actualizar meta diaria
  void updateDailyGoals({int? targetCalories, int? targetMinutes}) {
    _dailyGoals = _dailyGoals.copyWith(
      targetCalories: targetCalories,
      targetMinutes: targetMinutes,
    );
    notifyListeners();
    // TODO: Sincronizar con Firestore:
    // FirebaseFirestore.instance.collection('users').doc(uid).update({'dailyGoals': _dailyGoals.toMap()});
  }

  // Agregar una nueva sesión completada
  void addSession(WorkoutSession session) {
    _sessions.add(session);
    notifyListeners();
    // TODO: Guardar en Firestore:
    // FirebaseFirestore.instance.collection('users').doc(uid).collection('sessions').add(session.toMap());
  }

  // Eliminar una sesión del historial
  void deleteSession(String sessionId) {
    _sessions.removeWhere((s) => s.id == sessionId);
    notifyListeners();
    // TODO: Eliminar en Firestore:
    // FirebaseFirestore.instance.collection('users').doc(uid).collection('sessions').doc(sessionId).delete();
  }

  // Obtener sesiones para un día específico
  List<WorkoutSession> getSessionsForDay(DateTime day) {
    return _sessions.where((s) => _isSameDay(s.date, day)).toList();
  }

  // Saber si se entrenó en un día específico
  bool hasSessionOnDay(DateTime day) {
    return _sessions.any((s) => _isSameDay(s.date, day));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
