import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/routine.dart';
import '../models/exercise.dart';
import '../data/dummy_data.dart';

class RoutinesService {
  static final RoutinesService instance = RoutinesService._internal();

  RoutinesService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Catálogo completo plano de ejercicios para resolver IDs
  List<Exercise> get _allExercises =>
      temp_exercises.expand((category) => category.exercises).toList();

  String? get _currentUserId => _auth.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _routinesCollection {
    final uid = _currentUserId;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('routines');
  }

  // Rutinas por defecto para cuando el usuario es nuevo
  List<Routine> get defaultRoutines => [
        Routine(
          id: 'r1',
          title: 'Día de Pecho y Tríceps',
          exercises: [
            ...temp_exercises[0].exercises.take(3),
            ...temp_exercises[3].exercises.take(2),
          ],
        ),
        Routine(
          id: 'r2',
          title: 'Día de Espalda y Bíceps',
          exercises: [
            ...temp_exercises[1].exercises.take(3),
            ...temp_exercises[3].exercises.skip(1).take(2),
          ],
        ),
        Routine(
          id: 'r3',
          title: 'Día de Pierna (Cuádriceps)',
          exercises: temp_exercises[5].exercises.take(4).toList(),
        ),
      ];

  // LEER (Read) - Obtener rutinas de Firestore
  Future<List<Routine>> fetchRoutines() async {
    final collection = _routinesCollection;

    // Si no ha iniciado sesión, retornamos las de respaldo
    if (collection == null) {
      return defaultRoutines;
    }

    try {
      final snapshot = await collection.get();

      // Si la colección está vacía en Firestore, precargamos las de muestra
      if (snapshot.docs.isEmpty) {
        await _seedDefaultRoutines(collection);
        return defaultRoutines;
      }

      final catalog = _allExercises;
      return snapshot.docs.map((doc) {
        return Routine.fromMap(doc.id, doc.data(), catalog);
      }).toList();
    } catch (e) {
      // Si falla la red o Firestore, retorno seguro
      return defaultRoutines;
    }
  }

  // CREAR (Create) - Guardar una nueva rutina en Firestore
  Future<Routine> createRoutine({
    required String title,
    required List<Exercise> exercises,
  }) async {
    final collection = _routinesCollection;

    if (collection == null) {
      // Modo offline/local
      return Routine(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        exercises: exercises,
      );
    }

    final docRef = collection.doc();
    final routine = Routine(
      id: docRef.id,
      title: title,
      exercises: exercises,
    );

    await docRef.set(routine.toMap());
    return routine;
  }

  // ACTUALIZAR (Update) - Modificar una rutina existente en Firestore
  Future<void> updateRoutine(Routine routine) async {
    final collection = _routinesCollection;
    if (collection == null) return;

    await collection.doc(routine.id).set(
          routine.toMap(),
          SetOptions(merge: true),
        );
  }

  // ELIMINAR (Delete) - Borrar una rutina de Firestore
  Future<void> deleteRoutine(String routineId) async {
    final collection = _routinesCollection;
    if (collection == null) return;

    await collection.doc(routineId).delete();
  }

  // Precargar las rutinas iniciales en la base de datos de Firestore
  Future<void> _seedDefaultRoutines(
    CollectionReference<Map<String, dynamic>> collection,
  ) async {
    final defaults = defaultRoutines;
    for (final r in defaults) {
      await collection.doc(r.id).set(r.toMap());
    }
  }
}
