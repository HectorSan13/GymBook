import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GoalAdjustDialog extends StatefulWidget {
  final String title;
  final String unit;
  final int initialValue;
  final int step;
  final Color themeColor;
  final IconData icon;

  const GoalAdjustDialog({
    super.key,
    required this.title,
    required this.unit,
    required this.initialValue,
    required this.step,
    required this.themeColor,
    required this.icon,
  });

  @override
  State<GoalAdjustDialog> createState() => _GoalAdjustDialogState();
}

class _GoalAdjustDialogState extends State<GoalAdjustDialog> {
  late TextEditingController _controller;
  late int _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    _controller = TextEditingController(text: _currentValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _increment() {
    setState(() {
      _currentValue += widget.step;
      _controller.text = _currentValue.toString();
    });
  }

  void _decrement() {
    if (_currentValue - widget.step >= 0) {
      setState(() {
        _currentValue -= widget.step;
        _controller.text = _currentValue.toString();
      });
    }
  }

  void _onTextChanged(String text) {
    final parsed = int.tryParse(text);
    if (parsed != null && parsed >= 0) {
      _currentValue = parsed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono y Título
            CircleAvatar(
              radius: 28,
              backgroundColor: widget.themeColor.withOpacity(0.15),
              child: Icon(widget.icon, color: widget.themeColor, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ajusta con [+] [-] de ${widget.step} en ${widget.step} o escribe el valor deseado:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            const SizedBox(height: 24),

            // Controles de ajuste: [-]  [ Campo de Texto ]  [+]
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Botón Menos
                IconButton.filledTonal(
                  onPressed: _decrement,
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    foregroundColor: isDarkMode ? Colors.white : Colors.black,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(width: 12),

                // Input para escribir a mano libre
                SizedBox(
                  width: 110,
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: _onTextChanged,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: widget.themeColor,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      suffixText: widget.unit,
                      suffixStyle: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                      filled: true,
                      fillColor: isDarkMode ? Colors.grey[850] : Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: widget.themeColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: widget.themeColor, width: 2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Botón Más
                IconButton.filledTonal(
                  onPressed: _increment,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                    foregroundColor: isDarkMode ? Colors.white : Colors.black,
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // Botones de Acción (Cancelar / Guardar)
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final val = int.tryParse(_controller.text) ?? _currentValue;
                      Navigator.pop(context, val);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.themeColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
