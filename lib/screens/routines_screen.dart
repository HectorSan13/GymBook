import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'settings_screen.dart';
import 'exercises_screen.dart';

class RoutinesScreen extends StatefulWidget {
  const RoutinesScreen({super.key});

  @override
  State<RoutinesScreen> createState() => _RoutinesScreenState();
}

class _RoutinesScreenState extends State<RoutinesScreen> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Mis rutinas',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text('Pendiente'),
                content: Text('Aquí se abrirá tu perfil.'),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // FILA PRINCIPAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jair Ernesto Aguilar Limón',
                style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w500),
              ),

              // GRÁFICA
              SizedBox(
                height: 80,
                width: 80,
                child: SfCircularChart(
                  margin: EdgeInsets.zero,
                  series: <CircularSeries>[
                    RadialBarSeries<double, String>(
                      dataSource: const [6500],
                      xValueMapper: (double data, _) => 'Pasos',
                      yValueMapper: (double data, _) => data,
                      pointColorMapper: (double data, _) => Colors.pinkAccent,
                      maximumValue: 10000,
                      innerRadius: '75%',
                      cornerStyle: CornerStyle.bothCurve,
                      trackColor: Colors.pink.withOpacity(0.2),
                    )
                  ],
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.directions_walk, size: 16),
                          Text('6.5k', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),

          const Padding(
            padding: EdgeInsets.all(30),
          ),

          // Botón gigante del medio
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExercisesScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Icon(Icons.add, size: 50),
            ),
          ),

          const Center(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Toca + para crear tu primera rutina.',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: Colors.grey.shade200,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          if (index == 0) {
            setState(() {
              currentPageIndex = index;
            });
          } else {
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                title: Text('Pendiente'),
                content: Text('Esta sección aún no está funcional.'),
              ),
            );
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Rutinas',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt),
            label: 'Ejercicios',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart),
            label: 'Progreso',
          ),
        ],
      ),
    );
  }
}