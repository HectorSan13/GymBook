import 'package:flutter/material.dart';
import 'package:gymbook/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Ajustes', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Preferencias',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Modo Oscuro', style: TextStyle(fontSize: 18)),
              Switch(
                value: themeNotifier.value == ThemeMode.dark,
                onChanged: (bool valor) {
                  setState(() {
                    themeNotifier.value = valor ? ThemeMode.dark : ThemeMode.light;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}