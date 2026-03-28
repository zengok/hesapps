import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../widgets/calculator_layout.dart';
import '../../../../widgets/custom_input.dart';
import '../../../utility/data/services/history_service.dart';
import '../../../utility/data/models/calculation_history.dart';

class SuTuketimiScreen extends StatefulWidget {
  const SuTuketimiScreen({super.key});
  @override
  State<SuTuketimiScreen> createState() => _SuTuketimiScreenState();
}

class _SuTuketimiScreenState extends State<SuTuketimiScreen> {
  final _kiloCtrl = TextEditingController();
  String _aktivite = 'Normal';
  String? _resultText;
  bool _showResult = false;

  void _calculate() {
    final kilo = double.tryParse(_kiloCtrl.text.replaceAll(',', '.'));
    if (kilo == null || kilo <= 0) return;
    // Temel formül: kilo × 0.033 litre/gün, aktivite çarpanı
    double carpan = _aktivite == 'Sporcu' ? 1.5 : _aktivite == 'Aktif' ? 1.25 : 1.0;
    final gun = kilo * 0.033 * carpan;
    final bardak = (gun / 0.2).ceil();

    HistoryService.saveHistory(CalculationHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Su Tüketimi: $kilo kg',
      result: 'Günlük: ${gun.toStringAsFixed(1)} L',
      date: DateTime.now(),
    ));
    setState(() {
      _resultText = 'Günlük Su İhtiyacı: ${gun.toStringAsFixed(2)} Litre\nYaklaşık $bardak Bardak (200 ml)';
      _showResult = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CalculatorLayout(
      title: 'Su Tüketimi Takibi',
      showResult: _showResult,
      resultText: _resultText,
      resultLabel: 'Günlük Su İhtiyacı',
      onCalculate: _calculate,
      child: Column(children: [
        CustomInput(controller: _kiloCtrl, hintText: 'Vücut Ağırlığı (kg)', keyboardType: const TextInputType.numberWithOptions(decimal: true), prefixIcon: LucideIcons.droplet, onChanged: (_) => setState(() => _showResult = false)),
        const SizedBox(height: 16),
        Wrap(spacing: 8, children: ['Normal', 'Aktif', 'Sporcu'].map((a) {
          final sel = _aktivite == a;
          return GestureDetector(
            onTap: () => setState(() { _aktivite = a; _showResult = false; }),
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(color: sel ? Colors.blue.withOpacity(0.3) : Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: sel ? Colors.blue : Colors.white24)),
              child: Text(a, style: TextStyle(color: isDark ? Colors.white : Colors.black87))),
          );
        }).toList()),
      ]),
    );
  }
}
