import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/routine.dart';
import '../models/workout_session.dart';
import 'progress_service.dart';

class ActiveWorkoutService extends ChangeNotifier {
  static final ActiveWorkoutService instance = ActiveWorkoutService._internal();

  ActiveWorkoutService._internal();

  Routine? _activeRoutine;
  int _currentExerciseIndex = 0;
  int _secondsElapsed = 0;
  bool _isTimerRunning = false;
  Timer? _timer;

  // Guarda las series de la sesión activa: { 'idEjercicio': ['60 kg x 10 reps', ...] }
  final Map<String, List<String>> _seriesDeHoy = {};

  // Historial de pesos anteriores de prueba
  final Map<String, String> _pesoAnterior = {
    '0042': '60 kg x 10 reps',
    '0028': '50 kg x 10 reps',
    '0054': '80 kg x 8 reps',
  };

  // Getters
  bool get isWorkoutActive => _activeRoutine != null;
  Routine? get activeRoutine => _activeRoutine;
  int get currentExerciseIndex => _currentExerciseIndex;
  int get secondsElapsed => _secondsElapsed;
  bool get isTimerRunning => _isTimerRunning;
  Map<String, List<String>> get seriesDeHoy => _seriesDeHoy;
  Map<String, String> get pesoAnterior => _pesoAnterior;

  String get formattedDuration {
    final hours = _secondsElapsed ~/ 3600;
    final minutes = (_secondsElapsed % 3600) ~/ 60;
    final seconds = _secondsElapsed % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  // Iniciar un nuevo entrenamiento o reanudar el existente
  void startWorkout(Routine routine) {
    if (_activeRoutine != null && _activeRoutine!.id == routine.id) {
      // Ya está activa esta misma rutina, solo aseguramos que el cronómetro corra
      if (!_isTimerRunning) {
        _startTimer();
      }
      return;
    }

    // Nuevo entrenamiento
    _timer?.cancel();
    _activeRoutine = routine;
    _currentExerciseIndex = 0;
    _secondsElapsed = 0;
    _seriesDeHoy.clear();
    _startTimer();
    notifyListeners();
  }

  void _startTimer() {
    _isTimerRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isTimerRunning) {
        _secondsElapsed++;
        notifyListeners();
      }
    });
    notifyListeners();
  }

  void toggleTimer() {
    _isTimerRunning = !_isTimerRunning;
    notifyListeners();
  }

  void pauseTimer() {
    if (_isTimerRunning) {
      _isTimerRunning = false;
      notifyListeners();
    }
  }

  void resumeTimer() {
    if (!_isTimerRunning) {
      _isTimerRunning = true;
      notifyListeners();
    }
  }

  void setExerciseIndex(int index) {
    if (_activeRoutine != null && index >= 0 && index < _activeRoutine!.exercises.length) {
      _currentExerciseIndex = index;
      notifyListeners();
    }
  }

  void nextExercise() {
    if (_activeRoutine != null && _currentExerciseIndex < _activeRoutine!.exercises.length - 1) {
      _currentExerciseIndex++;
      notifyListeners();
    }
  }

  void previousExercise() {
    if (_currentExerciseIndex > 0) {
      _currentExerciseIndex--;
      notifyListeners();
    }
  }

  void addSet(String exerciseId, String record) {
    _seriesDeHoy.putIfAbsent(exerciseId, () => []);
    _seriesDeHoy[exerciseId]!.add(record);
    _pesoAnterior[exerciseId] = record;
    notifyListeners();
  }

  // Finalizar y calcular estadísticas
  WorkoutSession? finishWorkout() {
    if (_activeRoutine == null) return null;

    _timer?.cancel();

    // Minutos redondeados (al menos 1 si duró más de 5 seg)
    int minutes = (_secondsElapsed / 60).round();
    if (minutes == 0 && _secondsElapsed >= 5) {
      minutes = 1;
    }

    // Fórmula progresiva estimada para gym (~7.5 kcal por minuto activo)
    final int calories = (minutes * 7.5).round();

    final session = WorkoutSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      durationMinutes: minutes,
      caloriesBurned: calories,
      routineId: _activeRoutine!.id,
      routineTitle: _activeRoutine!.title,
    );

    // Guardar en Progreso
    ProgressService.instance.addSession(session);

    // Resetear sesión activa
    _activeRoutine = null;
    _currentExerciseIndex = 0;
    _secondsElapsed = 0;
    _isTimerRunning = false;
    _seriesDeHoy.clear();

    notifyListeners();
    return session;
  }

  // Cancelar/Descartar sesión activa
  void cancelWorkout() {
    _timer?.cancel();
    _activeRoutine = null;
    _currentExerciseIndex = 0;
    _secondsElapsed = 0;
    _isTimerRunning = false;
    _seriesDeHoy.clear();
    notifyListeners();
  }
}
