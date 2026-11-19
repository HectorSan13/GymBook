import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../services/progress_service.dart';
import 'goal_adjust_dialog.dart';

class DailyProgressRings extends StatelessWidget {
  const DailyProgressRings({super.key});

  void _ajustarCalorias(BuildContext context) async {
    final service = ProgressService.instance;
    final nuevoObjetivo = await showDialog<int>(
      context: context,
      builder: (context) => GoalAdjustDialog(
        title: 'Meta de Calorías',
        unit: 'kcal',
        initialValue: service.dailyGoals.targetCalories,
        step: 50,
        themeColor: Colors.redAccent,
        icon: Icons.local_fire_department,
      ),
    );

    if (nuevoObjetivo != null && nuevoObjetivo > 0) {
      service.updateDailyGoals(targetCalories: nuevoObjetivo);
    }
  }

  void _ajustarTiempo(BuildContext context) async {
    final service = ProgressService.instance;
    final nuevoObjetivo = await showDialog<int>(
      context: context,
      builder: (context) => GoalAdjustDialog(
        title: 'Meta de Tiempo',
        unit: 'min',
        initialValue: service.dailyGoals.targetMinutes,
        step: 5,
        themeColor: Colors.green,
        icon: Icons.timer,
      ),
    );

    if (nuevoObjetivo != null && nuevoObjetivo > 0) {
      service.updateDailyGoals(targetMinutes: nuevoObjetivo);
    }
  }

  Widget _buildRing({
    required BuildContext context,
    required bool isDarkMode,
    required double currentValue,
    required double targetValue,
    required Color color,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    // Si el valor supera la meta, no dejamos que la gráfica falle (máximo relativo)
    final double maxVal = targetValue > 0 ? targetValue : 1;
    final double displayedVal = currentValue > maxVal ? maxVal : currentValue;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 72,
                width: 72,
                child: SfCircularChart(
                  margin: EdgeInsets.zero,
                  series: <CircularSeries>[
                    RadialBarSeries<double, String>(
                      dataSource: [displayedVal],
                      xValueMapper: (double data, _) => label,
                      yValueMapper: (double data, _) => data,
                      pointColorMapper: (double data, _) => color,
                      maximumValue: maxVal,
                      innerRadius: '74%',
                      cornerStyle: CornerStyle.bothCurve,
                      trackColor: isDarkMode ? Colors.grey[850]! : Colors.grey[300]!,
                    ),
                  ],
                  annotations: <CircularChartAnnotation>[
                    CircularChartAnnotation(
                      widget: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 16, color: color),
                          const SizedBox(height: 1),
                          Text(
                            currentValue.toInt().toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Meta: ${targetValue.toInt()} $label',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: ProgressService.instance,
      builder: (context, _) {
        final service = ProgressService.instance;
        final currentCalories = service.todayCalories.toDouble();
        final targetCalories = service.dailyGoals.targetCalories.toDouble();
        final currentMinutes = service.todayMinutes.toDouble();
        final targetMinutes = service.dailyGoals.targetMinutes.toDouble();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Círculo Rojo: KCAL
            _buildRing(
              context: context,
              isDarkMode: isDarkMode,
              currentValue: currentCalories,
              targetValue: targetCalories,
              color: Colors.redAccent,
              icon: Icons.local_fire_department,
              label: 'kcal',
              tooltip: 'Toca para ajustar meta de calorías',
              onTap: () => _ajustarCalorias(context),
            ),
            const SizedBox(width: 6),
            // Círculo Verde: Minutos
            _buildRing(
              context: context,
              isDarkMode: isDarkMode,
              currentValue: currentMinutes,
              targetValue: targetMinutes,
              color: Colors.green,
              icon: Icons.timer,
              label: 'min',
              tooltip: 'Toca para ajustar meta de tiempo',
              onTap: () => _ajustarTiempo(context),
            ),
          ],
        );
      },
    );
  }
}
