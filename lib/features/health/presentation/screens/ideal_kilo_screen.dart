import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class IdealKiloScreen extends StatefulWidget {
  const IdealKiloScreen({super.key});
  @override
  State<IdealKiloScreen> createState() => _IdealKiloScreenState();
}

class _IdealKiloScreenState extends State<IdealKiloScreen> {
  final _boyCtrl = TextEditingController();
  String _cinsiyet = 'Erkek';
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final boy = double.tryParse(_boyCtrl.text.replaceAll(',', '.'));
    if (boy == null || boy < 100 || boy > 250) return;

    // Devine Formülü
    double idealKilo;
    if (_cinsiyet == 'Erkek') {
      idealKilo = 50 + 2.3 * ((boy - 152.4) / 2.54);
    } else {
      idealKilo = 45.5 + 2.3 * ((boy - 152.4) / 2.54);
    }
    final minKilo = idealKilo - 5;
    final maxKilo = idealKilo + 5;

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'İdeal Kilo: $boy cm ($_cinsiyet)',
      result: 'İdeal: ${idealKilo.toStringAsFixed(1)} kg',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText =
          'İdeal Kilo: ${idealKilo.toStringAsFixed(1)} kg\nSağlıklı Aralık: ${minKilo.toStringAsFixed(1)} - ${maxKilo.toStringAsFixed(1)} kg';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CalculatorLayout(
      title: 'İdeal Kilo (Devine Formülü)',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'İdeal Kilo',
      onCalculate: _calculate,
      child: Column(children: [
        CustomInput(controller: _boyCtrl, hintText: 'Boy (cm)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.ruler, onChanged: (_) => setState(() => _showResult = false)),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: GestureDetector(
            onTap: () => setState(() { _cinsiyet = 'Erkek'; _showResult = false; }),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _cinsiyet == 'Erkek' ? Colors.blue.withOpacity(0.3) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cinsiyet == 'Erkek' ? Colors.blue : Colors.white24),
              ),
              child: Center(child: Text('Erkek', style: TextStyle(color: isDark ? Colors.white : Colors.black87))),
            ),
          )),
          const SizedBox(width: 12),
          Expanded(child: GestureDetector(
            onTap: () => setState(() { _cinsiyet = 'Kadın'; _showResult = false; }),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: _cinsiyet == 'Kadın' ? Colors.pink.withOpacity(0.3) : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _cinsiyet == 'Kadın' ? Colors.pink : Colors.white24),
              ),
              child: Center(child: Text('Kadın', style: TextStyle(color: isDark ? Colors.white : Colors.black87))),
            ),
          )),
        ]),
      ]),
    );
  }
}
