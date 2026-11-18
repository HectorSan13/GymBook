import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gymbook/main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Empieza con lo que ya estaba guardado
  final _nameController = TextEditingController(text: nicknameNotifier.value);
  String _photoPath = photoNotifier.value;

  // Abre la galeria para escoger una foto
  Future<void> _pickPhoto() async {
    final foto = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (foto != null) {
      setState(() {
        _photoPath = foto.path;
      });
    }
  }

  // Guarda el nombre y la foto, y regresa a Ajustes
  void _save() {
    nicknameNotifier.value = _nameController.text;
    photoNotifier.value = _photoPath;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // Correo del usuario que inicio sesion
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Foto  si no hay foto sale el icono, si hay sale la foto
          Center(
            child: GestureDetector(
              onTap: _pickPhoto,
              child: _photoPath == ''
                  ? const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              )
                  : CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(File(_photoPath)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Toca la foto para cambiarla', textAlign: TextAlign.center),
          const SizedBox(height: 30),

          // Nombre o apodo
          const Text('Nombre o apodo', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              hintText: 'Escribe tu nombre o apodo',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),

          // Correo
          const Text('Correo', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(email),
          const SizedBox(height: 40),

          // Boton guardar
          ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDarkMode ? Colors.white : Colors.black,
              foregroundColor: isDarkMode ? Colors.black : Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}