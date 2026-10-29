import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// CONEXIONES LIMPIAS:
import 'package:gymbook/screens/settings_screen.dart';
import 'package:gymbook/screens/exercises_screen.dart';

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
        centerTitle: true,
        title: const Text(
          'Mis rutinas',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                  builder: (context) => SettingsScreen(),
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
                style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500),
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
                      pointColorMapper: (double data, _) => Colors.red,
                      maximumValue: 10000,
                      innerRadius: '75%',
                      cornerStyle: CornerStyle.bothCurve,
                      trackColor: Colors.grey,
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
                backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                foregroundColor: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black,
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
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          // Hace que el texto del label sea blanco (seleccionado y no seleccionado)
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(color: Colors.white, fontSize: 12),
          ),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: Colors.black); // Ícono negro sobre la píldora blanca
            }
            return const IconThemeData(color: Colors.white); // Ícono blanco sobre fondo negro
          }),
        ),
        child: NavigationBar(
          backgroundColor: Colors.black,
          indicatorColor: Colors.white,
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
              selectedIcon: Icon(Icons.fitness_center),
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
      )
    );
  }
}