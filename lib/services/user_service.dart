import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:gymbook/main.dart';

// Guarda al usuario en Firestore  junto con el token del celular
Future<void> guardarUsuario(User user, String nombre) async {
  // Token del celular  si falla lo dejamos vacio para que no truene el login
  String token = '';
  try {
    token = await FirebaseMessaging.instance.getToken() ?? '';
  } catch (e) {
    print('No se pudo obtener el token: $e');
  }

  // merge: true para no borrar lo que ya tenga (apodo, foto)
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'nombre': nombre,
    'correo': user.email ?? '',
    'token': token,
    'ultimoAcceso': Timestamp.now(),
  }, SetOptions(merge: true));

  // Traemos el apodo que tenga guardado para mostrarlo en la app
  final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  nicknameNotifier.value = doc.data()?['apodo'] ?? '';
}

// Guarda el apodo del usuario en Firestore
Future<void> guardarApodo(String apodo) async {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance.collection('users').doc(uid).update({'apodo': apodo});
}

// Borra las rutinas, los datos y la cuenta del usuario
Future<void> eliminarCuenta() async {
  final user = FirebaseAuth.instance.currentUser!;

  // Borramos sus rutinas
  final rutinas = await FirebaseFirestore.instance
      .collection('rutinas')
      .where('uid', isEqualTo: user.uid)
      .get();
  for (final rutina in rutinas.docs) {
    await rutina.reference.delete();
  }

  // Borramos su documento de users
  await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

  // Borramos la cuenta de Firebase Auth
  await user.delete();
}