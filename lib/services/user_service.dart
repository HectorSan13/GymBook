import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Guarda al usuario en Firestore  junto con el token del celular
Future<void> guardarUsuario(User user, String nombre) async {
  // Token del celular si falla lo dejamos vacio para que no truene el login
  String token = '';
  try {
    token = await FirebaseMessaging.instance.getToken() ?? '';
  } catch (e) {
    print('No se pudo obtener el token: $e');
  }

  //  true para no borrar lo que ya tenga apodo, foto
  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'nombre': nombre,
    'correo': user.email ?? '',
    'token': token,
    'ultimoAcceso': Timestamp.now(),
  }, SetOptions(merge: true));
}