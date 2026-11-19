import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gymbook/data/dummy_data.dart';
import 'package:gymbook/models/exercise.dart';

List<Exercise> findExercisesByIds(List<String> ids) {
  final allExercises = temp_exercises.expand((cat) => cat.exercises).toList();
  final List<Exercise> result = [];

  for (final id in ids) {
    final index = allExercises.indexWhere((ex) => ex.id == id);
    if (index != -1) {
      result.add(allExercises[index]);
    }
  }
  return result;
}

//CRUD rutinas
Future<void> addRoutine(String uid, String title, List<String> exerciseIds) {
  CollectionReference rutinas = FirebaseFirestore.instance.collection('rutinas');

  return rutinas
      .add({
        'uid': uid,
        'title': title,
        'exerciseIds': exerciseIds,
      })
      .then((value) => print('Rutina agregada correctamente'))
      .catchError((error) => print('Error al agregar rutina: $error'));
}

Stream<QuerySnapshot> getRoutinesStream(String uid) {
  CollectionReference rutinas = FirebaseFirestore.instance.collection('rutinas');
  return rutinas.where('uid', isEqualTo: uid).snapshots();
}

Future<void> updateRoutine(
    String routineId, String title, List<String> exerciseIds) {
  CollectionReference rutinas = FirebaseFirestore.instance.collection('rutinas');

  return rutinas
      .doc(routineId)
      .update({
        'title': title,
        'exerciseIds': exerciseIds,
      })
      .then((value) => print('Rutina actualizada correctamente'))
      .catchError((error) => print('Error al actualizar rutina: $error'));
}

Future<void> deleteRoutine(String routineId) {
  CollectionReference rutinas = FirebaseFirestore.instance.collection('rutinas');

  return rutinas
      .doc(routineId)
      .delete()
      .then((value) => print('Rutina eliminada correctamente'))
      .catchError((error) => print('Error al eliminar rutina: $error'));
}

//Progrso de pesos
Future<void> saveExerciseProgress({
  required String uid,
  required String routineId,
  required String routineTitle,
  required String exerciseId,
  required String exerciseName,
  required String peso,
  required String reps,
}) {
  final registro = '$peso kg x $reps reps';

  CollectionReference historial =
      FirebaseFirestore.instance.collection('historial_series');

  historial
      .add({
        'uid': uid,
        'routineId': routineId,
        'routineTitle': routineTitle,
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'peso': peso,
        'reps': reps,
        'registro': registro,
        'fecha': Timestamp.now(),
      })
      .then((value) => print('Serie guardada en historial'))
      .catchError((error) => print('Error al guardar en historial: $error'));

  CollectionReference progreso =
      FirebaseFirestore.instance.collection('progreso_ejercicios');

  return progreso
      .doc('${uid}_$exerciseId')
      .set({
        'uid': uid,
        'exerciseId': exerciseId,
        'exerciseName': exerciseName,
        'peso': peso,
        'reps': reps,
        'registro': registro,
        'fecha': Timestamp.now(),
      })
      .then((value) => print('Progreso de ejercicio actualizado'))
      .catchError((error) => print('Error al actualizar progreso: $error'));
}

Stream<DocumentSnapshot> getLastExerciseProgressStream(
    String uid, String exerciseId) {
  CollectionReference progreso =
      FirebaseFirestore.instance.collection('progreso_ejercicios');
  return progreso.doc('${uid}_$exerciseId').snapshots();
}