import 'package:gymbook/models/exercise_category.dart';
import 'package:gymbook/models/exercise.dart';

const temp_exercises = [
  ExerciseCategory(
    id: 'c1',
    title: 'Pecho',
    exercises: [
      Exercise(id: 'e1', name: 'Press de banca', category: 'Pecho'),
      Exercise(id: 'e2', name: 'Press inclinado con mancuernas', category: 'Pecho'),
      Exercise(id: 'e3', name: 'Aperturas en polea', category: 'Pecho'),
      Exercise(id: 'e4', name: 'Fondos en paralelas', category: 'Pecho'),
    ],
  ),
  ExerciseCategory(
    id: 'c2',
    title: 'Espalda',
    exercises: [
      Exercise(id: 'e5', name: 'Jalón al pecho', category: 'Espalda'),
      Exercise(id: 'e6', name: 'Remo con barra', category: 'Espalda'),
    ],
  ),
  ExerciseCategory(
    id: 'c3',
    title: 'Hombros',
    exercises: [
      Exercise(id: 'e7', name: 'Press militar', category: 'Hombros'),
      Exercise(id: 'e8', name: 'Elevaciones laterales', category: 'Hombros'),
    ],
  ),
  ExerciseCategory(
    id: 'c4',
    title: 'Bíceps',
    exercises: [
      Exercise(id: 'e9', name: 'Curl de bíceps con barra', category: 'Bíceps'),
    ],
  ),
  ExerciseCategory(
    id: 'c5',
    title: 'Tríceps',
    exercises: [
      Exercise(id: 'e10', name: 'Extensión de tríceps en polea', category: 'Tríceps'),
    ],
  ),
];